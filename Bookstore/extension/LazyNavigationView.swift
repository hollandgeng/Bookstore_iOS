//
//  LazyNavigationView.swift
//  Bookstore
//
//  Created by Jing Wei on 11/09/2023.
//

import Foundation
import SwiftUI

struct LazyNavigationView<Content:View> : View
{
    let build : () -> Content
    init(_ build: @autoclosure @escaping () -> Content)
    {
        self.build = build
    }
    
    var body: some View
    {
        build()
    }
}
