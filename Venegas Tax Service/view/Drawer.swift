//
//  Drawer.swift
//  Venegas Tax Service
//
//  Created by Vigitrack on 5/11/22.
//

import SwiftUI

struct Drawer: View {
    
    @EnvironmentObject var menuData: MenuViewModel
    @State var nameUser:String = Configuration.value(defaultValue: "", forKey: "nameUser")
    
    
    // Animation...
    var animation: Namespace.ID
    

    
    var body: some View {
        
        
        
        VStack{
            
            HStack{
                
                Image("img-tax")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                
                Spacer().background(Color(.black))
                
                // Close Button..
                
                if menuData.showDrawer {
                    DrawerCloseButton(animation: animation)
                }
            }.padding()
            
            VStack(alignment: .leading, spacing: 10, content: {
                
                HStack{
                    Text("HOLA ")
                    Text(nameUser)
                        .font(.title2)
                }
            })
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.top,5)
            
            // Menu Buttons....
            
            VStack(spacing: 22){
                
                MenuButton(name: "Crear Gasto", image: "doc.text", selectedMenu: $menuData.selectedMenu,animation: animation)
                    .environmentObject(menuData)
                
                MenuButton(name: "Gastos", image: "house", selectedMenu: $menuData.selectedMenu,animation: animation).environmentObject(menuData)
                
                /*MenuButton(name: "Cerrar Sesión", image: "rectangle.portrait.and.arrow.forward", selectedMenu: $menuData.selectedMenu,animation: animation).environmentObject(menuData)*/
                
        
                
                Spacer()
                
             
            }
            .padding(.leading)
            .frame(width: 250, alignment: .leading)
            .padding(.top,30).background(Color(.white))
            
            Spacer()
            
        }
        // Default Size...
        .frame(width: 250)
        .background(
            Color(.black)
                .ignoresSafeArea(.all, edges: .vertical)
        )
    }
}

struct Drawer_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

// Close Button....

struct DrawerCloseButton: View {
    
    @EnvironmentObject var menuData: MenuViewModel
    var animation: Namespace.ID
    
    var body: some View{
        
        Button(action: {
            withAnimation(.easeInOut){
                menuData.showDrawer.toggle()
            }
        }, label: {
            
            VStack(spacing: 5){
                
                Capsule()
                    .fill(menuData.showDrawer ? Color.white : Color.primary)
                    .frame(width: 35, height: 3)
                    .rotationEffect(.init(degrees: menuData.showDrawer ? -50 : 0))
                // Adjusting Like X....
                    // Based On Trail And Error...
                    .offset(x: menuData.showDrawer ? 2 : 0, y: menuData.showDrawer ? 9 : 0)
                
                VStack(spacing: 5){
                    
                    Capsule()
                        .fill(menuData.showDrawer ? Color.white : Color.primary)                        .frame(width: 35, height: 3)
                    
                    Capsule()
                        .fill(menuData.showDrawer ? Color.white : Color.primary)                        .frame(width: 35, height: 3)
                    // Moving This View TO Hide...
                        .offset(y: menuData.showDrawer ? -8 : 0)
                }
                // Rotating Like XMark....
                .rotationEffect(.init(degrees: menuData.showDrawer ? 50 : 0))
            }
        })
        // Making It Little Small...
        .scaleEffect(0.8)
        .matchedGeometryEffect(id: "MENU_BUTTON", in: animation)
    }
}
