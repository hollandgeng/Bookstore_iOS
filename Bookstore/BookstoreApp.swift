//
//  BookstoreApp.swift
//  Bookstore
//
//  Created by Jing Wei on 28/08/2023.
//

import SwiftUI

@main
struct BookstoreApp: App {
    @StateObject var userStateViewModel = UserStateViewModel()
    
    var body: some Scene {
        WindowGroup
        {
            HomeView()
            .environmentObject(userStateViewModel)
        }
    }
}


