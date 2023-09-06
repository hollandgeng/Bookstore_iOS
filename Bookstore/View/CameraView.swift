//
//  CameraView.swift
//  Bookstore
//
//  Created by Jing Wei on 04/09/2023.
//

import SwiftUI

struct CameraView: View {
    @State var selectedImage : UIImage?
    
    var body: some View {
        Camera(capturedImage: $selectedImage)
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}

struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
        PickerView()
    }
}

struct PickerView : View{
    @State var selectedImage : UIImage?
    @State var show : Bool = false
    
    var body: some View {
        VStack
        {
            if (selectedImage != nil)
            {
                Image(uiImage: selectedImage!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250,height: 250)
                    .onTapGesture {
                        show = true
                    }
                    .overlay
                    {
                        RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1)
                    }
            }
            else
            {
                Image(systemName:"swift")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250,height: 250)
                    .onTapGesture {
                        show = true
                    }
                    .overlay
                    {
                        RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1)
                    }
            }
        }.sheet(isPresented: $show)
        {
            CustomPhotoPicker(selectedImage: $selectedImage)
        }
        
    }
}
