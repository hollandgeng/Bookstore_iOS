//
//  KeyboardAdaptiveView.swift
//  Bookstore
//
//  Created by Jing Wei on 04/09/2023.
//

import Foundation
import Combine
import SwiftUI


//Not using it now
//has bug
//pushing too much padding
struct KeyboardAdaptive : ViewModifier
{
    @State private var bottomPadding : CGFloat = 0
    
    func body(content: Content) -> some View{
        GeometryReader
        {
            geometry in
            content.padding(.bottom, self.bottomPadding)
                .onReceive(Publishers.keyboardHeight)
                {
                    height in
                    let top = geometry.frame(in:.global).height - height
                    let targetFieldBottom = UIResponder.currentResponder?.globalFrame?.maxY ?? 0
                    self.bottomPadding = max(0, targetFieldBottom - top - geometry.safeAreaInsets.bottom)
                }
                .animation(.easeOut, value: 0.2)
        }
        
    }
}

extension View
{
    func KeyboardAdaptiveView() -> some View
    {
        ModifiedContent(content: self, modifier: KeyboardAdaptive())
    }
}
