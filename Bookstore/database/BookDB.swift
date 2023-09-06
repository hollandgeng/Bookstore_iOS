//
//  BookDB.swift
//  Bookstore
//
//  Created by Jing Wei on 04/09/2023.
//

import Foundation
import CoreData

struct BookDB
{
    static let shared = BookDB()
    
    let container : NSPersistentContainer
    
    init()
    {
        container = NSPersistentContainer(name:"BookModel")
        
        container.loadPersistentStores
        {
            (store , error) in
            if let error = error as NSError?
            {
                fatalError("Load Failed: \(error)")
            }
        }
    }
}
