//
//  DetalleGastoView.swift
//  Venegas Tax Service
//
//  Created by Vigitrack on 7/11/22.
//

import SwiftUI

struct DetalleGastoView: View {
    
    @State var categoria: String
    @State var fecha: String
    @State var monto: String
    @State var nota: String
    @State var imagenUrl: String
    
    
        var body: some View {
            ZStack{
                
                VStack{
                    
                    Text("").font(.title).fontWeight(.bold).foregroundColor(.blue)
            
                    TextField("Categoria", text: $categoria).padding()
                        .background(.white)
                        .font(.headline)
                        .cornerRadius(5.0)
                        .disabled(true)
                
               
                    
                    TextField("Nota", text: $nota,axis: .vertical).lineLimit(3).padding()
                        .background(.white)
                        .font(.headline)
                        .cornerRadius(5.0)
                        .disabled(true)
                    
                    TextField("Fecha", text: $fecha,axis: .vertical).lineLimit(3).padding()
                        .background(.white)
                        .font(.headline)
                        .cornerRadius(5.0).padding(.bottom,10)
                        .disabled(true)
                    
                    AsyncImage(url: URL(string: imagenUrl),scale: 1){ image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity).imageScale(.large)
                        .clipShape(RoundedRectangle(cornerRadius: 0)).scaledToFit()
                    
                    Spacer()
                    
                    
                }.padding()
            }.background(Color("fondo"))
        }
}

struct DetalleGastoView_Previews: PreviewProvider {
    static var previews: some View {
        DetalleGastoView(categoria: "CAT", fecha: "2022-09-22 11:00:00", monto: "0.00", nota: ".", imagenUrl: "https://firebasestorage.googleapis.com/v0/b/vigitrack-empresas.appspot.com/o/329083.jpg?alt=media")
    }
}
