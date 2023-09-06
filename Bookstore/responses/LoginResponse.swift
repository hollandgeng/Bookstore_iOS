//
//  LoginResponse.swift
//  Bookstore
//
//  Created by Jing Wei on 06/09/2023.
//

import Foundation

class LoginResponse
{
    var success : Bool
    var error : String? = nil
    
    init()
    {
        success = true
        error = nil
    }
    
    init(err : String)
    {
        success = false
        error = err
    }
}

class AccountNotFoundException : LoginResponse
{
    override init() {
        super.init(err: "Account Not Found")
    }
}

class InvalidPasswordException : LoginResponse
{
    override init() {
        super.init(err: "Invalid Password")
    }
}
