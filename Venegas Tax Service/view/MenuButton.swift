//
//  MenuButton.swift
//  Venegas Tax Service
//
//  Created by Vigitrack on 5/11/22.
//

import SwiftUI

struct MenuButton: View {
    
    var name: String
    var image: String
    @Binding var selectedMenu: String
    
    var animation: Namespace.ID
    
    var body: some View {
       
        Button(action: {
            withAnimation(.spring()){
                selectedMenu = name
            }
        }, label: {
            
            HStack(spacing: 15){
                
                Image(systemName: image)
                    .font(.title2)
                    .foregroundColor(.black)
                
                Text(name)
                    .foregroundColor(.black)
            }
            .padding(.horizontal)
            .padding(.vertical,12)
            .frame(width: 200,alignment: .leading)
            // Smooth Slide Animation.....
            .background(
            
                ZStack{
                    if selectedMenu == name{
                        Color.red
                            .cornerRadius(10)
                            .matchedGeometryEffect(id: "TAB", in: animation)
                    }
                    else{
                        Color.clear
                    }
                }
            )
        })
    }
}

struct MenuButton_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
