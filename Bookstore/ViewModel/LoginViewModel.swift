//
//  LoginViewModel.swift
//  Bookstore
//
//  Created by Jing Wei on 28/08/2023.
//

import Foundation

class LoginViewModel : ObservableObject{
    
    @Published var username : String = ""
    @Published var password : String = ""
    
    @Published var showAlert : Bool = false
    
    func Login() -> LoginResponse
    {
        if(userProfile.isEmpty)
        {
            return AccountNotFoundException()
        }
        
        if let pw = userProfile[username]
        {
            return ValidatePassword(checker: pw)
        }
        else
        {
            return AccountNotFoundException()
        }

    }
    
    private func ValidatePassword(checker: String) -> LoginResponse
    {
        if (password != checker)
        {
            return InvalidPasswordException()
        }
        
        return LoginResponse()
    }
}
