//
//  BookRepository.swift
//  Bookstore
//
//  Created by Jing Wei on 29/08/2023.
//

import Foundation
import CoreData
import SwiftUI

class BookRepository : IBookRepository
{
    private let dbContext : NSManagedObjectContext
    private var books : [Book]
    
    init()
    {
        dbContext = BookDB.shared.container.viewContext
        books = []
    }
    
    private func GetBooks()
    {
        let fetchRequest = NSFetchRequest<BookEntity>(entityName:"BookEntity")
        let sortDesc = NSSortDescriptor(key:"creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDesc]
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try dbContext.fetch(fetchRequest)
            let count = results.count
            let books = results.map{Book(from: $0)}
            self.books = books
        }
        catch
        {
            
        }
        
    }
    
    func GetBookById(bookId: UUID) -> Book? {
        return books.first(where: {$0.id == bookId})
    }
    
    
    func GetAllBook() -> [Book] {
        GetBooks()
        return books
    }
    
    
    func UpdateBook(book : Book) {
        UpdateBook_DB(book: book)
    }
    
    func AddBook(book:Book)
    {
        AddBook_DB(book:book)
    }
    
    func DeleteBook(book:Book)
    {
        DeleteBook_DB(book: book)
    }
    
    private func AddBook_DB(book:Book)
    {
        let newbook = BookEntity(context: dbContext)
        
        newbook.id = book.id
        newbook.title = book.title
        newbook.author  = book.author
        newbook.note = book.note
        newbook.creationDate = book.creationDate
        newbook.image = book.image
        
        do{
            try dbContext.save()
        }
        catch
        {
            let err = error as NSError
            fatalError("\(err)")
        }
    }
    
    private func UpdateBook_DB(book:Book)
    {
        let fetchRequest : NSFetchRequest<BookEntity> = NSFetchRequest(entityName: "BookEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", book.id as CVarArg)
        
        do
        {
            let result = try dbContext.fetch(fetchRequest)
            
            if let result = result.first
            {
                result.title = book.title
                result.author = book.author
                result.note = book.note
                result.image = book.image
            }
            
            try dbContext.save()
        }
        catch
        {
            
        }
    }
    
    private func DeleteBook_DB(book:Book)
    {
        let fetchRequest : NSFetchRequest<BookEntity> = NSFetchRequest(entityName: "BookEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", book.id as CVarArg)
        
        do
        {
            let result = try dbContext.fetch(fetchRequest)
            
            if let result = result.first
            {
                dbContext.delete(result)
            }
            
            try dbContext.save()
        }
        catch
        {
            print("\(error)")
            return
        }
        
        Task
        {
            DeleteBookImage(filename:book.image)
        }
    }
    
    private func DeleteBookImage(filename : String)
    {
        let fileManager = FileManager.default
        let filepath = GetImagePath(filename: filename).path()
        
        do
        {
            if(fileManager.fileExists(atPath: filepath))
            {
                try fileManager.removeItem(atPath: filepath)
                print("Deleted \(filename)")
            }
        }
        catch
        {
            print("\(error)")
        }
        
    }
}

