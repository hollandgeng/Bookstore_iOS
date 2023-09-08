//
//  BookInfoView.swift
//  Bookstore
//
//  Created by Jing Wei on 28/08/2023.
//

import SwiftUI
import PhotosUI
import Combine

struct BookInfoView: View {
    @State private var showAlert : Bool = false
    
    @ObservedObject var viewmodel : BookInfoViewModel
    
    @State private var keyboardPadding : CGFloat = 0
    
    var body: some View {
        ScrollViewReader
        {
            sp in
            ScrollView
            {
                BookInfo(book: $viewmodel.currentBook,
                         currentViewState: $viewmodel.currentState,
                onPhotoChanged: {
                    imageData in
                    viewmodel.SetTempImageData(data: imageData)
                })
                .navigationTitle("Book")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarTrailing, content: {
                        Button(action: {
                            viewmodel.ActionButtonDelegate()
                        }, label: {
                            Text(viewmodel.ActionText)
                        })
                        .disabled(viewmodel.currentBook.title.isEmpty || viewmodel.currentBook.author.isEmpty)
                    })
                })
            }
        }.padding().hideKeyboardOnTapped()
    }
}

struct BookInfoView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView
        {
            BookInfoView(viewmodel: BookInfoViewModel(book: Mock_Book[0]))
        }
    }
}

struct BookInfoPreview : PreviewProvider
{
    @State static var _book = Book(title:"AA",author:"MM")
    @State static var state = BookViewState.Edit
    static var previews: some View
    {
        BookInfo(book:$_book, currentViewState:$state)
    }
}

struct BookInfo : View {
    @Binding var book : Book
    @Binding var currentViewState : BookViewState
    
    @State private var currentImage : UIImage?
    
    @State private var showImageAction : Bool = false
    
    @State private var customImagePicker : Bool = false

    @State private var showCamera : Bool = false
    
    var onPhotoChanged : (Data?) -> Void = {data in return}
    
    func loadImageData()
    {
        if(book.image.isEmpty)
        {
            return
        }
        
        let _url = NSURL(string: book.image)?.path
        
        if(FileManager.default.fileExists(atPath:_url!))
        {
            let url = URL(string:book.image)
            
            if let data = try? Data(contentsOf: url!)
            {
                currentImage = UIImage(data: data)
            }
            else
            {
                currentImage = nil
            }
        }
    }
    
    
    
    var body: some View {
        VStack
        {
            if (currentImage != nil)
            {
                Image(uiImage: currentImage!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250,height: 250)
                    .allowsHitTesting(currentViewState != .View)
                    .onTapGesture {
                        showImageAction = true
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1)
                    }
            }
            else
            {
                Image(systemName: "swift")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250,height: 250)
                    .allowsHitTesting(currentViewState != .View)
                    .onTapGesture {
                        showImageAction = true
                    }
                    .overlay
                {
                    RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1)
                }
            }
            
            TextField("Title",text: $book.title)
                .padding(4)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.system(size: 16))
                .disabled(currentViewState == .View)
            TextField("Author",text: $book.author)
                .padding(4)
                .font(.system(size: 16))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disabled(currentViewState == .View)
            TextField("Note", text:$book.note, axis:.vertical)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.system(size:16))
                .disabled(currentViewState == .View)
                .padding(4)
                .lineLimit(10, reservesSpace: true)
            }.confirmationDialog("Action", isPresented: $showImageAction, actions: {
            Button("Take A Photo", action: {
                showCamera = true
            })
            
            Button("Pick from Gallery", action: {
                customImagePicker = true
            })
            Button("Cancel", role: .cancel, action: {})
        })
        .onAppear(perform: {
            loadImageData()
        })
        .sheet(isPresented: $showCamera)
        {
            //Camera(selectedImage: $selectedImageData)
            Camera(capturedImage: $currentImage)
        }
        .sheet(isPresented: $customImagePicker)
        {
            CustomPhotoPicker(selectedImage: $currentImage)
        }
        .onChange(of: currentImage, perform: {
            image in
            onPhotoChanged(image?.jpegData(compressionQuality: 0.5))
//            if(image == nil) { return }
//
//            let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//
//            let cacheFile = dir.appendingPathComponent("bookimage_\(book.id.uuidString).png")
//
//            try? image?.jpegData(compressionQuality: 0.5)!.write(to: cacheFile)
//
//            book.image = cacheFile.absoluteString
        })
        
    }
}


enum BookViewState
{
    case View
    case Create
    case Edit
    
    func toString() -> String
    {
        switch self
        {
        case .Create: return "Create"
        case .Edit: return "Edit"
        case .View : return "View"
        }
    }
}

