//
//  NotificationView.swift
//  Bookstore
//
//  Created by Jing Wei on 06/09/2023.
//

import SwiftUI

struct NotificationView : View{
    var size : CGSize
    @State var isExpanded : Bool = false
    @State var notification : NotificationModel?
    
    var body : some View{
        HStack
        {
            Image(systemName: "swift")
                .resizable()
                .background(Color.white)
                .scaledToFit()
                .frame(width: 30, height: 30)
                .overlay(Circle().stroke(Color.white, lineWidth:2))
                .clipShape(Circle())
            
            Spacer()
            
            Text(notification?.content ?? "Book Added").foregroundColor(Color.white).padding()
        }.padding()
        .frame(width: isExpanded ? size.width - 22 : 126 ,
               height: isExpanded ? 120 : 37.33)
        .blur(radius: isExpanded ? 0 : 30)
        .opacity(isExpanded ? 1 : 0)
        .scaleEffect(isExpanded ? 1 : 0.5, anchor: .top)
        .background
        {
            RoundedRectangle(cornerRadius: isExpanded ? 50 : 63,
                             style: .continuous).fill(.black)
        }
        .clipped()
        .offset(y:11)
        .onReceive(NotificationCenter.default.publisher(for: .init("NOTIFY")))
        {
            output in
            guard let notification = output.object as? NotificationModel else { return }
            self.notification = notification
            withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.7, blendDuration: 0.7))
            {
                isExpanded = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2)
            {
                withAnimation(.interactiveSpring(response: 0.7,dampingFraction: 0.7,blendDuration: 0.7))
                {
                    isExpanded = false
                    self.notification = nil
                }
            }
        }
    }
}

struct NotificationTestView: View {
    var body: some View {
        VStack
        {
            Button("Test Noti")
            {
                NotificationCenter.default.post(name:.init("NOTIFY"),object:NotificationModel(content: "Test"))
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .top) {
                GeometryReader
                {
                    proxy in
                    let size = proxy.size
                    NotificationView(size: size).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .ignoresSafeArea()
                }
            }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationTestView()
    }
}
