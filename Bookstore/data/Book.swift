//
//  Book.swift
//  Bookstore
//
//  Created by Jing Wei on 28/08/2023.
//

import Foundation
import CoreData

struct Book
{
    var id : UUID = UUID()
    var title : String
    var author : String
    var note : String
    var creationDate : Date
    var image : String

    init(title: String, author: String, note: String = "", image: String = "",creationDate : Date = Date.now) {
        self.title = title
        self.author = author
        self.note = note
        self.creationDate = creationDate
        self.image = image
    }
}


var Mock_Book : [Book] =
[
    Book(title: "AAA", author: "Jogn Doe", creationDate: Calendar(identifier: .gregorian).date(from: DateComponents(year:2023,month: 10,day: 11))!),
    Book(title: "BBB", author: "John Doe Jr", note: "ZZZ",creationDate: Calendar(identifier: .gregorian).date(from: DateComponents(year:2023,month: 12,day: 16))!)
]


class MockDataViewModel : ObservableObject
{
    func DeleteBook(id:UUID)
    {
        Mock_Book.removeAll(where: {$0.id == id})
    }
}

extension Book
{
    init(from bookEntity: BookEntity)
    {
        self.id = bookEntity.id ?? UUID()
        self.title = bookEntity.title ?? ""
        self.note = bookEntity.note ?? ""
        self.author = bookEntity.author ?? ""
        self.creationDate = bookEntity.creationDate ?? Date.now
        self.image = bookEntity.image ?? ""
    }
}
