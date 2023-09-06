//
//  Camera.swift
//  Bookstore
//
//  Created by Jing Wei on 04/09/2023.
//

import Foundation
import UIKit
import SwiftUI
import PhotosUI

struct Camera : UIViewControllerRepresentable
{
    typealias UIViewControllerType = UIImagePickerController
    
    @Environment(\.dismiss) private var dismiss
    @Binding var capturedImage : UIImage?
    
    private let source : UIImagePickerController.SourceType = .camera
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<Camera>) -> UIImagePickerController {
        let camera = UIImagePickerController()
        camera.allowsEditing = false
        camera.sourceType = source
        camera.delegate = context.coordinator
        return camera
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<Camera>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate
    {
        var parent : Camera
        
        init(_ parent: Camera) {
            self.parent = parent
        }
        
        func imagePickerController(_ controller : UIImagePickerController, didFinishPickingMediaWithInfo info : [UIImagePickerController.InfoKey : Any])
        {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            {
                parent.capturedImage = image

            }
            
            parent.dismiss()
        }
    }
    
    private func saveTemp(imageData : Data?)
    {
        if(imageData == nil) { return }
        
        do
        {
            let temporaryDirectory = FileManager.default.temporaryDirectory
            let temporaryFileUrl = temporaryDirectory.appendingPathComponent(UUID().uuidString + ".jpg")
            try imageData!.write(to: temporaryFileUrl)
        }
        catch
        {
            print("\(error)")
        }
    }
}
