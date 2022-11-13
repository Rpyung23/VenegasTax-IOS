//
//  Home.swift
//  Venegas Tax Service
//
//  Created by Vigitrack on 5/11/22.
//

import SwiftUI


struct Home: View {
    
    // Hiding tab Bar...
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    @StateObject var menuData = MenuViewModel()
    
    @Namespace var animation
    
    var body: some View {
        NavigationView{
            
            
            HStack(spacing: 0){
                // Drawer And Main View...
     
                // Drawer...
                Drawer(animation: animation)
                

                
                // Main View...
                
                TabView(selection: $menuData.selectedMenu){
                    
                    ListaCrearGastoView()
                        .tag("Crear Gasto")
                    
                    ListaGastosView()
                        .tag("Gastos")

                }
                .frame(width: UIScreen.main.bounds.width)
            }
            // Max Frame...
            .frame(width: UIScreen.main.bounds.width)
            // Moving View....
            // 250/2 => 125....
            .offset(x: menuData.showDrawer ? 125 : -125)
            /*.overlay(
            
                ZStack{
                    
                    if !menuData.showDrawer {
                        
                        DrawerCloseButton(animation: animation)
                            .padding(.leading,10)
                    }
                },
                alignment: .topLeading
            )*/
            
            // Setting As Environment Object....
            // For Avoiding Re-Declarations...
            .environmentObject(menuData)
        }.navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
