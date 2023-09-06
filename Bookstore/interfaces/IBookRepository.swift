//
//  File.swift
//  Bookstore
//
//  Created by Jing Wei on 29/08/2023.
//

import Foundation

protocol IBookRepository
{
    func GetAllBook() -> [Book]
    
    func GetBookById(bookId : UUID) -> Book?
    
    func AddBook(book:Book)
    
    func DeleteBook(book:Book)
    
    func UpdateBook(book : Book)
}
