//
//  CustomPhotoPicker.swift
//  Bookstore
//
//  Created by Jing Wei on 05/09/2023.
//

import Foundation
import SwiftUI
import PhotosUI

struct CustomPhotoPicker : UIViewControllerRepresentable
{
    typealias UIViewControllerType = PHPickerViewController
    
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedImage : UIImage?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CustomPhotoPicker>) -> PHPickerViewController {
        var pickerViewConfig = PHPickerConfiguration(photoLibrary: .shared())
        pickerViewConfig.filter = .images
        pickerViewConfig.selectionLimit = 1
        pickerViewConfig.preferredAssetRepresentationMode = .automatic
        
        let pickerView = PHPickerViewController(configuration: pickerViewConfig)
        pickerView.delegate = context.coordinator
        return pickerView
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: UIViewControllerRepresentableContext<CustomPhotoPicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent:self)
    }
    
    final class Coordinator : NSObject , PHPickerViewControllerDelegate, UINavigationControllerDelegate
    {
        private let parent : CustomPhotoPicker
        
        init(parent: CustomPhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if let pickedPhoto = results.first
            {
                pickedPhoto.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier)
                {
                    url, error in
                    if let zz = url
                    {
                        if let imageData = try? Data(contentsOf: zz)
                        {
                            if let image = UIImage(data: imageData)
                            {
                                DispatchQueue.main.async {
                                    self.parent.selectedImage = image
                                }
                            }
                        }
                    }
                }
                self.parent.dismiss()
            }
            else
            {
                self.parent.dismiss()
            }
            
        }
    }
    
    func UIImageConverter(provider: NSItemProvider) async -> UIImage?
    {
        await withCheckedContinuation
        {
            continuation in
            if (provider.canLoadObject(ofClass: UIImage.self))
            {
                provider.loadObject(ofClass: UIImage.self)
                {
                    image, _ in
                    continuation.resume(returning: image as? UIImage)
                }
            }
        }
    }
    
}
