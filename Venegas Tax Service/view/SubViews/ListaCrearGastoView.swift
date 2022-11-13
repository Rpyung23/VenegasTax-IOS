//
//  ListaCrearGastoView.swift
//  Venegas Tax Service
//
//  Created by Vigitrack on 2/11/22.
//

import SwiftUI






struct ListaCrearGastoView: View
{
    
    @State var isShowAlertNewCategoria: Bool = false
    @State private var username: String = ""
    @State private var password: String = ""
    @Namespace var animation
    @ObservedObject var categorias = CategoriaModel()
    
    
    func primerCaracter(texto:String) -> String {
        let saludo = texto

        let letra = String(saludo[saludo.startIndex])
        
        return letra
    }
    
    
    func getRandomColor() -> UIColor {
         //Generate between 0 to 1
         let red:CGFloat = CGFloat(drand48())
         let green:CGFloat = CGFloat(drand48())
         let blue:CGFloat = CGFloat(drand48())

         return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
    
    var body: some View {
        
        
        

        NavigationStack {
            VStack{
                
                HStack(){
                    DrawerCloseButton(animation: animation)
                    Text("Crear Gasto").font(.largeTitle).bold().frame(maxWidth: .infinity,alignment: .leading)
                    
                    NavigationLink(destination: LoginView().navigationBarHidden(true)){
                        Image(systemName: "rectangle.portrait.and.arrow.forward")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding(.trailing,5)
                    }.navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                    
                }.frame(maxWidth: .infinity).padding(.leading)
                
                
                
                ZStack(alignment: .bottomTrailing){
                    List(categorias.categoriasLista) {
                        oCategoria in ZStack {
                            NavigationLink(destination: NewGasto(nameCategoria: oCategoria.nombre ?? "", idCategoria: oCategoria.id ?? "0"), label: {
                                HStack {
                                    ZStack{
                                        Circle().fill(Color(getRandomColor())).frame(width: 50,height: 50)
                                        Text(primerCaracter(texto:oCategoria.nombre ?? "")).foregroundColor(.white).padding()
                                            .cornerRadius(90)
                                    }
                                    Text(oCategoria.nombre ?? "")
                                }
                            }).navigationBarHidden(true)
                                
                        
                            
                                
                        }
                    }

                    
                    
                   
                    
                    Button(action:{
                        if isShowAlertNewCategoria {
                            isShowAlertNewCategoria = false
                        }else{
                            isShowAlertNewCategoria = true
                        }
                    }) {
                        Image(systemName: "plus").foregroundColor(.white).imageScale(.large)
                    }.padding().background(Color("redTax")).cornerRadius(50).padding(.trailing,20)
                        .alert("Agregar Categoría", isPresented: $isShowAlertNewCategoria, actions: {
                                TextField("Categoria", text: $username)
                                Button("Agregar", action: {
                                    categorias.registroCategoriaCliente(NameCategoria: username)
                                    isShowAlertNewCategoria = false
                                })
                                Button("Cancelar", role: .cancel, action: {
                                    isShowAlertNewCategoria = false
                                })
                            }, message: {
                                Text("Ingrese los siguientes datos.")
                            })
                }
            }
        }.navigationBarHidden(true)
    }
}


struct GastoItem: Identifiable {
    let id = UUID();
    let idGasto: Int
    let letraGasto: String
    let NameGasto: String
}


struct ListaCrearGastoView_Previews: PreviewProvider {
    static var previews: some View {
        /*ListaCrearGastoView()*/
        Home()
    }
}
