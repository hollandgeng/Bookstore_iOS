//
//  BookInfoViewModel.swift
//  Bookstore
//
//  Created by Jing Wei on 29/08/2023.
//

import Foundation

class BookInfoViewModel : ObservableObject
{
    private let bookRepo : IBookRepository
    
    @Published var ActionText : String = "Edit"
    @Published var currentBook : Book
    @Published var currentState : BookViewState
    {
        didSet
        {
            ActionText = mapStateToActionText(currentState)
        }
    }
    
    var imageData : Data? = nil
    
    
    init(bookRepo: IBookRepository = DependencyContainer.instance.bookRepository, book:Book) {
        self.bookRepo = bookRepo
        self.currentBook = book
        
        if(bookRepo.GetBookById(bookId: book.id) == nil)
        {
            self.currentState = BookViewState.Create
        }
        else
        {
            self.currentState = BookViewState.View
        }
        
        self.ActionText = mapStateToActionText(self.currentState)
    }
    
    func SetTempImageData(data : Data?)
    {
        imageData = data
    }
    
    func ActionButtonDelegate()
    {
        UpdateState()
    }
    
    func AddBook()
    {
        AddNewPhoto()
        bookRepo.AddBook(book:currentBook)
    }
    
    func DeleteBook()
    {
        bookRepo.DeleteBook(book:currentBook)
    }
    
    func UpdateBook()
    {
        OverwritePhoto()
        bookRepo.UpdateBook(book:currentBook)        
    }
    
    
    private func UpdateState()
    {
        switch(currentState)
        {
        case BookViewState.Create:
            AddBook()
            DependencyContainer.instance.SetChangesFlag(hasChanged: true)
            currentState = BookViewState.View
            
        case BookViewState.Edit:
            UpdateBook()
            DependencyContainer.instance.SetChangesFlag(hasChanged: true)
            currentState = BookViewState.View
            
        case BookViewState.View:
            currentState = BookViewState.Edit
        }
    }
    
    private func mapStateToActionText(_ state : BookViewState) -> String
    {
        switch state
        {
        case .Create:
            return "Done"
        case .Edit:
            return "Done"
        case .View:
            return "Edit"
        }
    }
    
    private func OverwritePhoto()
    {
        if(imageData == nil) {return}
        
        let filename = "\(currentBook.id.uuidString)_\(GetDatetimeString()).jpeg";
        let filepath = GetImagePath(filename: filename)
      
        do
        {
            try imageData!.write(to: filepath)
        }
        catch
        {
            print("\(error)")
            return
        }
        
        let oldImageFile = currentBook.image
        
        
        Task
        {
            DeleteOldPhoto(filename: oldImageFile)
        }
                    
        currentBook.image = filename
        
        imageData = nil
    }
    
    private func AddNewPhoto()
    {
        if(imageData == nil) {return}
        
        let filename = "\(currentBook.id.uuidString)_\(GetDatetimeString()).jpeg";
        let filepath = GetImagePath(filename: filename)
      
        try? imageData!.write(to: filepath)
        
        currentBook.image = filename
        
        imageData = nil
    }
    
    private func DeleteOldPhoto(filename:String)
    {
        if(filename.isEmpty) {return}
        let filepath = GetImagePath(filename: filename).path()
        
        do
        {
            if(FileManager.default.fileExists(atPath: filepath))
            {
                try FileManager.default.removeItem(atPath: filepath)
            }
        }
        catch
        {
            print("\(error)")
        }
        
    }
    
    private func GetDatetimeString() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        
        let currentDate = Date()
        return dateFormatter.string(from: currentDate)
    }
    
        
}
