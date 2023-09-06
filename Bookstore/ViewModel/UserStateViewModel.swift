//
//  UserStateViewModel.swift
//  Bookstore
//
//  Created by Jing Wei on 28/08/2023.
//

import Foundation

@MainActor
class UserStateViewModel : ObservableObject
{
    @Published var loggedIn : Bool =  false
    
    func Login()
    {
        loggedIn = true
    }
    
    func Logout()
    {
        loggedIn = false
    }
}
