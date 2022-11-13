//
//  SplashScreenView.swift
//  Venegas Tax Service
//
//  Created by Vigitrack on 1/11/22.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    @ObservedObject var oP = PersistenciaLogin()
    
    
    var body: some View {
        
        if isActive {
            //LoginView()
            if oP.isPersistencia == 0{
                LoginView()
            }else{
                ContentView()
            }
        }else{
            
            NavigationView{
                ZStack {
                    Color.black.ignoresSafeArea()
                    VStack {
                        Image("img-tax")
                    }.onAppear {
                        withAnimation(.easeIn(duration: 1.2)){
                            self.size = 0.9
                            self.opacity = 1.0
                        }
                    }
                }
            }
            .navigationBarHidden(true).onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.isActive = true
                }
            }

        }

    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
