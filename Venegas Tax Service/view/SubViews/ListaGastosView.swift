//
//  ListaGastosView.swift
//  Venegas Tax Service
//
//  Created by Vigitrack on 5/11/22.
//

import SwiftUI

struct ListaGastosView: View
{
    @Namespace var animation
    @ObservedObject var gastos = GastoModel()
    
    var body: some View {
        
        NavigationStack {
            VStack{
                HStack(){
                    //DrawerCloseButton(animation: animation)
                    DrawerCloseButton(animation: animation)
                    Text("Gasto").font(.largeTitle).bold().frame(maxWidth: .infinity,alignment: .leading)
                    NavigationLink(destination: LoginView().navigationBarHidden(true)){
                        Image(systemName: "rectangle.portrait.and.arrow.forward")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding(.trailing,5)
                    }.navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                    
                }.frame(maxWidth: .infinity).padding(.leading)
                   
         
                    
                List(gastos.gastosLista) {
                        oGasto in VStack {
                            NavigationLink(destination: DetalleGastoView(categoria: oGasto.categoria ?? "", fecha: oGasto.fecha ?? "", monto: oGasto.monto ?? "", nota: oGasto.nota ?? "", imagenUrl: oGasto.foto ?? ""), label: {
                                HStack {
                                    AsyncImage(url: URL(string: oGasto.foto ?? "https://firebasestorage.googleapis.com/v0/b/vigitrack-empresas.appspot.com/o/s_imagen.png?alt=media"),scale: 2){ image in
                                        image.resizable()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                        .frame(maxWidth: 80,maxHeight: 80).imageScale(.small)
                                        .clipShape(RoundedRectangle(cornerRadius: 0)).scaledToFit()
                    
                                    VStack{
                                        Text(oGasto.monto ?? "$ 0.00").fontWeight(.bold)
                                            .font(.title2).frame(maxWidth: .infinity,alignment: .leading)
                                        Text(oGasto.categoria ?? "").frame(maxWidth: .infinity,alignment: .leading)
                                        Text(oGasto.fecha ?? "").frame(maxWidth: .infinity,alignment: .leading)
                                    }
                                }
                            }).navigationBarHidden(true)
                        }
                    }
            }
        }.navigationBarHidden(true)
        }
    }

struct ListaGastosView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
