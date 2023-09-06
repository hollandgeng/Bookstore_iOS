//
//  KeyboardDismissEffect.swift
//  Bookstore
//
//  Created by Jing Wei on 05/09/2023.
//

import Foundation
import SwiftUI
import UIKit

extension View
{
    func hideKeyboardOnTapped() -> some View
    {
        return self.onTapGesture
        {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
