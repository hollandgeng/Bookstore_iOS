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
            LoginView()
        }
            
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(UserStateViewModel())
    }
}
