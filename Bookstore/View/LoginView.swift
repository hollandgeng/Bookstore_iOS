//
//  ContentView.swift
//  Bookstore
//
//  Created by Jing Wei on 28/08/2023.
//

import SwiftUI

struct LoginView: View {
    @State private var username : String = ""
    @State private var password : String = ""
    
    @ObservedObject var viewmodel = LoginViewModel()
    
    var body: some View {
        VStack {
            TextField("Username",text: $viewmodel.username)
                .border(.secondary)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
            
            SecureField("Password",text: $viewmodel.password)
                .border(.secondary)
                        
            Button(action:viewmodel.Login,
                   label: {
                Text("Submit")
                    .frame(maxWidth: .infinity,maxHeight: 60)
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal,20)
                    .padding(.vertical,0)
            })
        }
        .padding()
        .textFieldStyle(.roundedBorder)
        .alert(isPresented: $viewmodel.showAlert,
               content: {
            Alert(title: Text(viewmodel.username),
                  message: Text(viewmodel.password),
                  dismissButton: .default(Text("OK")))
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
