//
//  HomeView.swift
//  Bookstore
//
//  Created by Jing Wei on 28/08/2023.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userStateViewModel : UserStateViewModel
    
    var body: some View {
        if(userStateViewModel.loggedIn)
        {
            BooklistView()
        }
        else
        {
            NavigationStack
            {
                LoginView()
                    .navigationTitle("Book Store")
                    .navigationBarTitleDisplayMode(.inline)
            }
            
        }
            
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(UserStateViewModel())
    }
}
