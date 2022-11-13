//
//  RegisterView.swift
//  Venegas Tax Service
//
//  Created by Vigitrack on 1/11/22.
//

import SwiftUI
import AlertMessage


struct RegistroUsuarioJSON: Identifiable,Decodable {
    let error, id: Int?
    let descripcion: String?
}

struct RegisterView: View {
    
    @State private var txtNombres = ""
    @State private var txtApellidos = ""
    @State private var txtTelefono = ""
    @State private var txtEmail = ""
    @State private var txtContrasenia = ""
    @State private var txtContraseniaConfir = ""
    @State private var oR: RegistroUsuarioJSON?
    @State private var showAlterCuentaCReada: Bool = false;
    @State var showOkCuenta: Int? = nil
    @State var showDatosVacios = false
    @State var showPasswordNoCoinciden = false
    
    func registroCategoriaCliente()
    {
        
        
        if !txtNombres.isEmpty || !txtEmail.isEmpty || !txtApellidos.isEmpty
            || !txtTelefono.isEmpty || !txtContrasenia.isEmpty || !txtContraseniaConfir.isEmpty {
            
            
            
            if txtContrasenia == txtContraseniaConfir {
                let jsonString = "{ \"idioma\" : \"es\", \"token\" : \"511ef473a779b64b1b52ce0cce7e512c7348fa0f32629cd82e76353dd6d190\",\"nombre\" : \""+txtNombres+"\",\"telefono\" : \""+txtTelefono+"\",\"apellidos\" : \""+txtApellidos+"\",\"email\" : \""+txtEmail+"\",\"passord\" : \""+txtContrasenia+"\"}"
                
                
                print(jsonString)
                
                guard let jsonData = jsonString.data(using: .utf8) else { return }

                // Send request
                guard let url  = URL(string: "https://fast-fix.com.mx/pruebas/venegas/ws/v1/api/agregarCliente")
                                 else {return}
                    
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.httpBody = jsonData

                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("token", forHTTPHeaderField: "Authorization") // Most likely you want to add some token here
                // request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

                
                
                URLSession.shared.dataTask(with: request){data,response,error in
                    guard let data = data else {return}
                    
                    
                    
                    if let decodedData = try? JSONDecoder().decode(RegistroUsuarioJSON.self, from: data) {
                        DispatchQueue.main.async {
                            self.oR = decodedData
                            
                            if self.oR?.error == 0
                            {
                                self.txtContrasenia = ""
                                self.txtEmail = ""
                                self.txtNombres = ""
                                self.txtApellidos = ""
                                self.txtTelefono = ""
                                self.txtContraseniaConfir = ""
                                self.showAlterCuentaCReada = true
                                
                            }
            
                        }
                    } else{
                        self.showDatosVacios = true
                    }
                }.resume()
            }else{
                self.showPasswordNoCoinciden = true
            }
            
        }else{
            self.showDatosVacios = true
        }
        

    }
    
    
    
    
    var body: some View
    {
        
        
        ScrollView {
            VStack {
                
                Image("img-tax").padding()
                
                TextField("Nombres", text: $txtNombres)
                //.textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color.gray.opacity(0.25))
                    .font(.headline)
                    .cornerRadius(5.0)
                
                TextField("Apellidos", text: $txtApellidos)
                //.textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color.gray.opacity(0.25))
                    .font(.headline)
                    .cornerRadius(5.0)
                
                TextField("Teléfono", text: $txtTelefono)
                //.textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color.gray.opacity(0.25))
                    .font(.headline)
                    .cornerRadius(5.0)
                    .keyboardType(.phonePad)
                
                TextField("Email", text: $txtEmail)
                //.textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color.gray.opacity(0.25))
                    .font(.headline)
                    .cornerRadius(5.0)
                    .keyboardType(.emailAddress)
                
                SecureField("Contraseña", text: $txtContrasenia)
                //.textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color.gray.opacity(0.25))
                    .font(.headline)
                    .cornerRadius(5.0)
                
                SecureField("Confirmar Contraseña", text: $txtContraseniaConfir)
                //.textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color.gray.opacity(0.25))
                    .font(.headline)
                    .cornerRadius(5.0)
                
                
                Spacer()
                
                Button(action: {
                    registroCategoriaCliente()
                    //self.showOkCuenta = 1
                }, label: {
                    Text("REGISTRATE").foregroundColor(.white)
                }).padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("redTax"))
                    .font(.title2)
                    .fontWeight(.bold)
                    .cornerRadius(50.0)
                    .padding(.top,20)
                
                
                /*NavigationLink(destination: LoginView(),tag: 1, selection: $showOkCuenta){
                    Button(action: {
                        //registroCategoriaCliente()
                        self.showOkCuenta = 1
                    }, label: {
                        Text("REGISTRATE").foregroundColor(.white)
                    }).padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("redTax"))
                        .font(.title2)
                        .fontWeight(.bold)
                        .cornerRadius(50.0)
                        .padding(.top,20)
                }.navigationBarHidden(true)*/
                

                
            }.padding(.trailing, 19).padding(.leading, 19)
                .alert("VENEGAS TAX SERVICE", isPresented: $showAlterCuentaCReada, actions: {
                    Button("Aceptar", role: .cancel, action:
                            {
                        //self.showAlterCuentaCReada = true
                        self.showOkCuenta = 1
                        
                    })
                }, message: {
                    Text("Cuenta creada con éxito")
                })
        }.alertMessage(isPresented: $showDatosVacios, type: .banner,autoHideIn: 1.5) {
            HStack {
                Image(systemName: "checkmark.seal")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .foregroundColor(.white)
                    .padding()
                        
                Text("Existen datos vacios.")
                     .foregroundColor(.white)
                        
                Spacer()
             }
              .background(Color.red)
        }.alertMessage(isPresented: $showPasswordNoCoinciden, type: .banner,autoHideIn: 1.5) {
            HStack {
                Image(systemName: "checkmark.seal")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .foregroundColor(.white)
                    .padding()
                        
                Text("Su contraseña no coincide.")
                     .foregroundColor(.white)
                        
                Spacer()
             }
              .background(Color.orange)
        }
        
        
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
