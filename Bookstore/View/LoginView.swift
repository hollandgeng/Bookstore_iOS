//
//  ContentView.swift
//  Bookstore
//
//  Created by Jing Wei on 28/08/2023.
//

import SwiftUI

enum InputField : CaseIterable
{
    case Username,Password
}

struct LoginView: View {
    @FocusState private var focusField : InputField?
    @State private var showLoginAlert : Bool = false
    
    @State private var errorMsg = ""
    
    @EnvironmentObject var userStateViewModel : UserStateViewModel
    @ObservedObject var viewmodel = LoginViewModel()
    
    func Login()
    {
        focusField = nil
        
        let result = viewmodel.Login()
        
        if (result.success)
        {
            userStateViewModel.Login()
        }
        else
        {
            errorMsg = result.error ?? "Login Failed"
            showLoginAlert = true
        }
    }
    
    var body: some View {
            VStack(alignment:.leading) {
                Form
                {
                    Section
                    {
                        TextField("Username",text: $viewmodel.username)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                            .focused($focusField,equals: .Username)
                            .submitLabel(.next)
                            .onSubmit
                            {
                                focusField = .Password
                            }
                        
                        SecureField("Password",text: $viewmodel.password)
                            .focused($focusField, equals: .Password)
                            .submitLabel(.go)
                            .onSubmit
                            {
                                Login()
                            }
                    }

                }
                .toolbar
                {
                    ToolbarItem(placement: .keyboard)
                    {
                        Button("Done")
                        {
                            focusField = nil
                        }
                    }
                }
                        
                
                SubmitButton(action: {
                    Login()
                })
                .disabled(viewmodel.username.isEmpty || viewmodel.password.isEmpty)
                .alert(isPresented: $viewmodel.showAlert,
                       content: {
                    Alert(title: Text(viewmodel.username),
                          message: Text(viewmodel.password),
                          dismissButton: .default(Text("OK")))
                })
                .alert(isPresented: $showLoginAlert)
                {
                    Alert(title: Text("Login Failed"),
                          message: Text(errorMsg),
                          dismissButton: .default(Text("OK")))
                }
                
                Spacer()
            }
        .hideKeyboardOnTapped()
    
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
  LoginView()

        
    }
}

struct SubmitButton : View
{
    @Environment (\.isEnabled) private var isEnabled
    let action : () -> Void
    
    var body: some View
    {
        Button(action: {
            action()
        },
               label:{
            Text("Submit")
                .frame(maxWidth: .infinity,maxHeight: 60)
                .foregroundColor(Color.white)
                .background(isEnabled ? Color.blue : Color.gray)
                .cornerRadius(10)
                .padding(.horizontal,20)
                .padding(.vertical,0)
        })
    }
}
