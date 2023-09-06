//
//  DependencyContainer.swift
//  Bookstore
//
//  Created by Jing Wei on 29/08/2023.
//

import Foundation

class DependencyContainer
{
    static let instance = DependencyContainer()
    
    let bookRepository : BookRepository;
    
    private(set) var hasUpdate = false
    
    private init()
    {
        bookRepository = BookRepository()
    }
    
    func SetChangesFlag(hasChanged : Bool)
    {
        self.hasUpdate = hasChanged
    }
}
