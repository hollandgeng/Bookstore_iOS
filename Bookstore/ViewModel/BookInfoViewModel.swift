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
    
    var imageData : Data? = nil
    
    init(bookRepo: IBookRepository = DependencyContainer.instance.bookRepository, book:Book) {
        self.bookRepo = bookRepo
        self.currentBook = book
        
        if(bookRepo.GetBookById(bookId: book.id) == nil)
        {
            self.currentState = BookViewState.Create
            self.ActionText = "Done"
        }
        else
        {
            self.currentState = BookViewState.View
            self.ActionText = "Edit"
        }
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
        //give a small buffer period to create the image file before notifying changes to UI
        //prevent file not found exception from BookList
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0)
//        {
//            self.bookRepo.UpdateBook(book:self.currentBook)
//        }
        
    }
    
    
    private func UpdateState()
    {
        switch(currentState)
        {
        case BookViewState.Create:
            AddBook()
            DependencyContainer.instance.SetChangesFlag(hasChanged: true)
            currentState = BookViewState.View
            ActionText = "Edit"
            
        case BookViewState.Edit:
            UpdateBook()
            DependencyContainer.instance.SetChangesFlag(hasChanged: true)
            currentState = BookViewState.View
            ActionText = "Edit"
            
        case BookViewState.View:
            currentState = BookViewState.Edit
            ActionText = "Done"
        }
    }
    
    private func OverwritePhoto()
    {
        if(imageData == nil) {return}
        
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let cacheFile = dir.appendingPathComponent("\(currentBook.id.uuidString)_\(GetDatetimeString()).jpeg")
        print(cacheFile)
        try? imageData!.write(to: cacheFile)
        
        let oldImagePath = currentBook.image
        
        Task
        {
            DeleteOldPhoto(path: oldImagePath)
        }
        
        currentBook.image = cacheFile.absoluteString
    }
    
    private func AddNewPhoto()
    {
        if(imageData == nil) {return}
        
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let cacheFile = dir.appendingPathComponent("\(currentBook.id.uuidString)_\(GetDatetimeString()).jpeg")
        print(cacheFile)
        try? imageData!.write(to: cacheFile)
        
        currentBook.image = cacheFile.absoluteString
    }
    
    private func DeleteOldPhoto(path:String)
    {
        let _url = NSURL(string: path)?.path
        
        do
        {
            if(FileManager.default.fileExists(atPath: _url!))
            {
                try FileManager.default.removeItem(atPath: _url!)
                print("Deleted")
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
