//
//  RecoveryPasswordView.swift
//  Venegas Tax Service
//
//  Created by Vigitrack on 2/11/22.
//

import SwiftUI
import Foundation

struct RecuperarPasswordJSON: Codable {
    let error: Int?
    let descripcion: String?
}



struct RecoveryPasswordView: View {
    
    @State private var txtEmail = ""
    @State private var message = "El correo ingresado no exite"
    @State private var oR: RecuperarPasswordJSON?
    @State var showAlterRecovery = false
    

    func recoveryPassword(email:String)
    {
        // Encode your JSON data
        let jsonString = "{ \"idioma\" : \"es\", \"token\" : \"511ef473a779b64b1b52ce0cce7e512c7348fa0f32629cd82e76353dd6d190\" ,\"email\" : \""+email+"\"}"
        
        
        print(jsonString)
        
        guard let jsonData = jsonString.data(using: .utf8) else { return }

        // Send request
        guard let url  = URL(string: "https://fast-fix.com.mx/pruebas/venegas/ws/v1/api/recuperPassword")
                         else {return}
            
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("token", forHTTPHeaderField: "Authorization") // Most likely you want to add some token here
        // request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        
        
        URLSession.shared.dataTask(with: request){data,response,error in
            guard let data = data else {return}
            
            
            
            if let decodedData = try? JSONDecoder().decode(RecuperarPasswordJSON.self, from: data) {
                DispatchQueue.main.async {
                    self.oR = decodedData
                    print("JSON RESPONSE")

                    if self.oR?.error == 0
                    {
                        self.txtEmail = ""
                        self.showAlterRecovery = true
                        
                    }

                     
                    
                    
                }
            }else{
                //ContentView()
                
                
            }
        }.resume()
    }
    
    var body: some View {
        VStack {
            
            Image("img-tax").padding()
            Text("Por seguridad de tu cuenta debes ingresar correctamente el siguiente dato : ")
                .frame(maxWidth: .infinity,alignment: .center).padding()
            
            
            
            Text("Ingresa tu correo electrónico para buscar tu cuenta.")
                .frame(maxWidth: .infinity,alignment: .leading)
                .fontWeight(.ultraLight)
            
            
            TextField("Ingresa tu correo", text: $txtEmail)
            //.textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(Color.gray.opacity(0.25))
                .font(.headline)
                .cornerRadius(5.0)
                .keyboardType(.emailAddress)
           
            Text("").padding()
            
           Button("RECUPERAR CONTRASEÑA", action: {
               recoveryPassword(email: txtEmail)
           }).foregroundColor(.white).padding()
                .frame(maxWidth: .infinity)
                .background(Color("redTax"))
                .font(.title3)
                .fontWeight(.bold)
                .cornerRadius(50.0)
     


            
        }.padding(.trailing, 19).padding(.leading, 19)
            .alert("VENEGAS TAX SERVICE", isPresented: $showAlterRecovery, actions: {
                    Button("Aceptar", role: .cancel, action: {
                        self.showAlterRecovery = false
                    })
                }, message: {
                    Text("CORREO ENVIADO CON EXITO")
                })
    }
}

struct RecoveryPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        RecoveryPasswordView()
    }
}
