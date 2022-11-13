//
//  LoginView.swift
//  Venegas Tax Service
//
//  Created by Vigitrack on 2/11/22.
//

import SwiftUI


struct LoginView: View {
    @State private var isSelectable = false
    @State private var txtUser = ""
    @State private var txtPassword = ""
    @State private var oL: LoginJSON?
    @State var showAlternoLogin = false
    @State var showOkLogin: Int? = nil
    
    init() {
        UITabBar.appearance().isHidden = true
        Configuration.value(value: 0, forKey: "persistenciaLogin")
        
    }
    
    
    // MARK: - LoginJSON
    struct LoginJSON: Codable {
        let error: Int
        let descripcion, id, nombre, email: String
    }
    
    /*struct LoginJSON: Codable {
        let id, author, en: String?
    }*/
    
    private func readLogin()
    {
        
        
        
        // Encode your JSON data
        let jsonString = "{ \"idioma\" : \"es\", \"token\" : \"511ef473a779b64b1b52ce0cce7e512c7348fa0f32629cd82e76353dd6d190\" ,\"usuario\" : \""+self.txtUser+"\", \"password\" : \""+self.txtPassword+"\" }"
        
        
        print(jsonString)
        
        guard let jsonData = jsonString.data(using: .utf8) else { return }

        // Send request
        guard let url  = URL(string: "https://fast-fix.com.mx/pruebas/venegas/ws/v1/api/login")
                         else {return}
            
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("token", forHTTPHeaderField: "Authorization") // Most likely you want to add some token here
        // request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        
        
        URLSession.shared.dataTask(with: request){data,response,error in
            guard let data = data else {return}
            
            
            
            if let decodedData = try? JSONDecoder().decode(LoginJSON.self, from: data) {
                DispatchQueue.main.async {
                    self.oL = decodedData
                    print("JSON RESPONSE")
                    print(self.oL?.descripcion)
                    print(self.oL?.email)
                    print(self.oL?.id)
                    
                    if self.oL?.error == 0
                    {
                        Configuration.value(value: (self.oL?.email ?? "noEmail" ), forKey: "emailUser")
                        Configuration.value(value: (self.oL?.nombre ?? "S/N" ), forKey: "nameUser")
                        Configuration.value(value: (self.oL?.id ?? "0" ), forKey: "idUser")
                        
                        if self.isSelectable == true {
                            Configuration.value(value: 1, forKey: "persistenciaLogin")
                            let myValue = Configuration.value(defaultValue: 0, forKey: "persistenciaLogin")
                            print(myValue)
                        }
                        
                        
                        /*let myValue = Configuration.value(defaultValue: "noEmail", forKey: "emailUser")
                        
                        print("RECUPERANDO EMAIL")
                        print(myValue)*/
                        
                        self.showOkLogin = 1
                        
                    }else{
                        print(self.oL?.descripcion)
                        
                        
                    }
                    
                    
                }
            }else{
                //ContentView()
                
                self.showAlternoLogin = true
                
            }
        }.resume()
                
    }
    
    var body: some View {
        
        NavigationView {
            ZStack {
                
                Color.black.ignoresSafeArea()
                
                
                VStack {
                    VStack {
                        Image("img-tax").padding()
                    }
                    
                    
                    
                    VStack {
                        
                        TextField("Ingresa tu usuario", text: $txtUser)
                        //.textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .background(Color.gray.opacity(0.25))
                            .font(.headline)
                            .cornerRadius(5.0)
                            .keyboardType(.emailAddress)
                        
                        SecureField("Ingresa tu contraseña", text: $txtPassword)
                        //.textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .background(Color.gray.opacity(0.25))
                            .font(.headline)
                            .cornerRadius(5.0)
                        
                        
                        Toggle(isOn: $isSelectable,label: {
                            Text("Recordar Cuenta").foregroundColor(.black)
                        })
                        .foregroundColor(.black)
                        
                        
                        
                        
                        
                        
                        NavigationLink(destination: ContentView(), tag: 1, selection: $showOkLogin) {
                            Button(action: {
                                readLogin()
                            }, label: {
                                Text("INICIAR SESIÓN").foregroundColor(.white)
                                    .font(.title2)
                                .fontWeight(.bold)
                            }).padding().frame(maxWidth: .infinity)
                                .background(Color("redTax")).cornerRadius(50.0)
                        }
                    
                        
                        NavigationLink(destination: RegisterView(), label: {
                            Text("REGISTRATE").foregroundColor(.white).padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .font(.title2)
                                .fontWeight(.bold)
                                .cornerRadius(50.0)
                        }).navigationTitle("Registrate")
                        
                        

                        
                        
                        
                        Text("¿Olvidaste tu contraseña? puedes recuperarla Aqui")
                            .frame(maxWidth: .infinity,alignment: .leading)
                            .foregroundColor(.black)
                            .fontWeight(.light)
                        
                            
                        VStack {
                            Spacer()
                            NavigationLink(destination: RecoveryPasswordView(), label: {
                                Text("Recuperar Contraseña").foregroundColor(Color("blueTax"))
                                    .frame(maxWidth: .infinity)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding()
                            }).navigationTitle("Recuperar Contraseña")
                        }
                        
                    }.padding()
                        .background(.white).cornerRadius(10)
                    
                }.padding(.trailing, 19).padding(.leading, 19)
            }.navigationBarHidden(true).navigationBarTitleDisplayMode(.inline)
                .alert("VENEGAS TAX SERVICE", isPresented: $showAlternoLogin, actions: {
                        Button("Aceptar", role: .cancel, action: {
                            self.showAlternoLogin = false
                        })
                    }, message: {
                        Text("Datos incorrectos")
                    })
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
