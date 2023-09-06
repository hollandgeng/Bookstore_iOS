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
    
    func ActionButtonDelegate()
    {
        UpdateState()
    }
    
    func AddBook()
    {
        bookRepo.AddBook(book:currentBook)
    }
    
    func DeleteBook()
    {
        bookRepo.DeleteBook(book:currentBook)
    }
    
    func UpdateBook()
    {
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
}
