//
//  KeybaordExtension.swift
//  Bookstore
//
//  Created by Jing Wei on 04/09/2023.
//

import Foundation
import Combine
import UIKit


extension Publishers
{
    static var keyboardHeight : AnyPublisher<CGFloat, Never>
    {
        let keyboardWillShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification).map{$0.keyboardHeight}
        
        let keyboardWillHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification).map{_ in CGFloat(0)}
        
        return MergeMany(keyboardWillShow,keyboardWillHide).eraseToAnyPublisher()
    }
}


extension Notification
{
    var keyboardHeight : CGFloat
    {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}

extension UIResponder
{
    private static weak var _currentResponder : UIResponder?
    
    static var currentResponder : UIResponder?
    {
        _currentResponder = nil
        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(_:)), to: nil, from: nil, for: nil)
        return _currentResponder
    }
    
    @objc private func findFirstResponder(_ sender : Any)
    {
        UIResponder._currentResponder = self
    }
    
    var globalFrame : CGRect?
    {
        guard let view = self as? UIView else { return nil }
        return view.superview?.convert(view.frame, to: nil)
    }
}
