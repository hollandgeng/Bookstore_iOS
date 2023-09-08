//
//  BooklistView.swift
//  Bookstore
//
//  Created by Jing Wei on 28/08/2023.
//

import SwiftUI

struct BooklistView: View {
    @EnvironmentObject var userStateViewModel : UserStateViewModel
    
    @ObservedObject var viewmodel = BooklistViewModel()
    
    var body: some View {
        NavigationStack
        {
            BookList(viewmodel: viewmodel)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Booklist")
                .toolbar(content: {
                    ToolbarItem(placement:.navigationBarLeading)
                    {
                        Button(action: {userStateViewModel.Logout()},
                               label:{
                            Text("Logout")
                                .foregroundColor(Color.red)
                        })
                    }
                    
                    ToolbarItem(placement:.navigationBarTrailing)
                    {
                        NavigationLink
                        {
                            BookInfoView(viewmodel: BookInfoViewModel(book: Book(title: "", author: "")))
                        }label:
                        {
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                    
                })
        }
        
    }
}

struct BookList : View
{
    @State var alert = false
    @State var currentBook : Book?
    
    @ObservedObject var viewmodel = BooklistViewModel()
    
    @State var refreshing = false
    
    var body: some View
    {
        NavigationStack
        {
            List{
                Section{
                    ForEach(viewmodel.books,id:\.id)
                    {
                        _book in
                        
                        NavigationLink
                        {
                            BookInfoView(viewmodel:BookInfoViewModel(book:_book))
                        }label: {
                            BookRow(book: _book, isRefreshing: $refreshing)
                                .swipeActions(edge: .trailing,
                                              allowsFullSwipe: false){
                                    Button(role:.destructive)
                                    {
                                        currentBook = _book
                                        alert = true
                                    }label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    
                }
            }
            .onAppear
            {
                if(DependencyContainer.instance.hasUpdate)
                {
                    viewmodel.getBook()
                    DependencyContainer.instance.SetChangesFlag(hasChanged: false)
                    //refreshing = true
                }
            }
            .refreshable {
                viewmodel.getBook()
                refreshing = true
            }.confirmationDialog("Delete",
                                 isPresented: $alert,
                                 presenting: currentBook,
                                 actions:{
                book in
                Button(role:.destructive)
                {
                    withAnimation{
                        viewmodel.DeleteBook(book: currentBook!)
                        viewmodel.getBook()
                    }
                    
                }label: {
                    Text("Delete")
                }
            },message:{
                book in
                Text("Are You Sure You Want to Delete This Book?")
            })
        }
        
    }
}

struct BookRow : View
{
    var book : Book
    
    @State private var imageData : Data?
    @State private var hasInit = false
    @Binding var isRefreshing : Bool
    
    //pass parameter here because to make sure data is always up-to-date
    //prevent image error due to race condition
    func loadImageData(filename:String)
    {
        if(filename.isEmpty) {return}

        let filepath = GetImagePath(filename: filename)
        
        if(FileManager.default.fileExists(atPath:filepath.path()))
        {

            if let data = try? Data(contentsOf:filepath )
            {
                imageData = data
            }
            else
            {
                imageData = nil
            }
        }
    }
    
    var body : some View
    {
        HStack()
        {
            if let imageData, let currentImage = UIImage(data: imageData)
            {
                Image(uiImage: currentImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .overlay(Circle().stroke(Color.black, lineWidth:2))
                    .clipShape(Circle())
            }
            else
            {
                Image(systemName: "swift")
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .overlay(Circle().stroke(Color.black, lineWidth:2))
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading)
            {
                Text(book.title)
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)
                    .font(.system(size:14))
                Text(book.author)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color.gray)
                    .font(.system(size:8))
            }
            
            
            Spacer()
            Text(book.creationDate, style: .date)
                .font(.system(size: 10))
        }
        .onAppear
        {
            //make sure appearing load only happen once
            //prevent image load on navigating back and forth
            //new image load will be called on data changed or refresh
            if(!hasInit)
            {
                loadImageData(filename:book.image)
                hasInit = true
            }
        }
        .onChange(of: isRefreshing)
        {
            refresh in
            if(refresh)
            {
                loadImageData(filename:book.image)
                isRefreshing = false
            }
        }
        .onChange(of: book.image)
        {
            image in
            loadImageData(filename:image)
        }
    }
}


struct BooklistView_Previews: PreviewProvider {
    static var previews: some View {
        
        BooklistView().environmentObject(UserStateViewModel())
        
    }
}
