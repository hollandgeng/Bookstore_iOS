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
                    refreshing = true
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
                 Text("Sure?")
             })
        }
        
    }
}

struct BookRow : View
{
    var book : Book
    
    @State private var imageData : Data?
    @Binding var isRefreshing : Bool
    
    func loadImageData(path:String)
    {
        if(path.isEmpty) {return}
//        if(book.image.isEmpty)
//        {
//            return
//        }
        
        let _url = NSURL(string: path)?.path

        if(FileManager.default.fileExists(atPath:_url!))
        {
            let url = URL(string:path)
            
            if let data = try? Data(contentsOf:url! )
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
            loadImageData(path:book.image)
        }
        .onChange(of: isRefreshing)
        {
            refresh in
            if(refresh)
            {
                loadImageData(path:book.image)
                isRefreshing = false
            }
        }
        .onChange(of: book.image)
        {
            image in
            loadImageData(path:image)
            
            
        }
        
    }
    
}


struct BooklistView_Previews: PreviewProvider {
    static var previews: some View {

        BooklistView().environmentObject(UserStateViewModel())

    }
}
