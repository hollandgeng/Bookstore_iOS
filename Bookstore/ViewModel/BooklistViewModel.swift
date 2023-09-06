//
//  BooklistViewModel.swift
//  Bookstore
//
//  Created by Jing Wei on 29/08/2023.
//

import Foundation

class BooklistViewModel : ObservableObject
{
    private let bookRepo : IBookRepository
    
    @Published var books : [Book]
    
    init(bookRepo: IBookRepository = DependencyContainer.instance.bookRepository) {
        self.bookRepo = bookRepo
        self.books = bookRepo.GetAllBook()
    }
    
    func getBook()
    {
        books = bookRepo.GetAllBook()
    }
    
    func AddBook(book:Book)
    {
        bookRepo.AddBook(book: book)
    }
    
    func DeleteBook(book:Book)
    {
        bookRepo.DeleteBook(book: book)
    }
}
