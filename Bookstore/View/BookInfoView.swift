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
    
    @FocusState private var focusField : Field?
    
    @State private var currentImage : UIImage?
    
    @State private var showImageAction : Bool = false
    
    @State private var customImagePicker : Bool = false
    
    @State private var showCamera : Bool = false
    
    var onPhotoChanged : (Data?) -> Void = {data in return}
    
    //not passing parameter because book data only pass in once by @Binding
    //no need to worry on update race condition
    //hence it can just grab data from book state
    func loadImageData()
    {
        if(book.image.isEmpty)
        {
            return
        }
        
        let filepath = GetImagePath(filename: book.image)
        
        if(FileManager.default.fileExists(atPath:filepath.path()))
        {
            if let data = try? Data(contentsOf: filepath)
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
                .font(.system(size: 16))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .focused($focusField, equals: .title)
                .disabled(currentViewState == .View)
            TextField("Author",text: $book.author)
                .padding(4)
                .font(.system(size: 16))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .focused($focusField, equals: .author)
                .disabled(currentViewState == .View)
            TextField("Note", text:$book.note, axis:.vertical)
                .padding(4)
                .font(.system(size:16))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .focused($focusField, equals: .note)
                .disabled(currentViewState == .View)
                .lineLimit(10, reservesSpace: true)
            
        }
        .toolbar
        {
            ToolbarItemGroup(placement:.keyboard)
            {
                Button(action:FocusPrevious)
                {
                    Image(systemName: "chevron.up")
                }.disabled(!CanFocusPrievious())
                
                Button(action:FocusNext)
                {
                    Image(systemName: "chevron.down")
                }.disabled(!CanFocusNext())
                
                Spacer()
            }
            
            
            ToolbarItem(placement:.keyboard)
            {
                
                
                Button("Done")
                {
                    focusField = nil
                }
            }
            
        }
        .confirmationDialog("Action", isPresented: $showImageAction, actions: {
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
            newImage in
            onPhotoChanged(newImage?.jpegData(compressionQuality: 0.5))
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

extension BookInfo
{
    private enum Field : Int, CaseIterable
    {
        case title, author, note
    }
    
    private func FocusPrevious()
    {
        focusField = focusField.map{
            Field(rawValue: $0.rawValue - 1) ?? .note
        }
    }
    
    private func FocusNext()
    {
        focusField = focusField.map{
            Field(rawValue: $0.rawValue + 1) ?? .title
        }
    }
    
    private func CanFocusPrievious() -> Bool
    {
        guard let currentField = focusField else
        {
            return false
        }
        
        return currentField.rawValue > 0
    }
    
    private func CanFocusNext() -> Bool
    {
        guard let currentField = focusField else
        {
            return false
        }
        
        return currentField.rawValue < Field.allCases.count - 1
    }
}

