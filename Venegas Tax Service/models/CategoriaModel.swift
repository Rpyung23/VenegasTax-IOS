//
//  CategoriaModel.swift
//  Venegas Tax Service
//
//  Created by Vigitrack on 10/11/22.
//

import SwiftUI

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let categoriaJSON = try? newJSONDecoder().decode(CategoriaJSON.self, from: jsonData)

import Foundation


struct CategoriaJSONElement: Identifiable,Decodable
{
    let id, nombre: String?
}

struct CategoriaRegistroJSON: Identifiable,Decodable
{
    let error, id: Int?
    let descripcion: String?
}


class CategoriaModel:ObservableObject {
    @Published var categoriasLista = [CategoriaJSONElement]();
    @Published var categoriaRegistro: CategoriaRegistroJSON?
    
    
    private func readCategoriasClientes()
    {
        let idCliente = Configuration.value(defaultValue: "0", forKey: "idUser")
        // Encode your JSON data
        let jsonString = "{ \"idioma\" : \"es\", \"token\" : \"511ef473a779b64b1b52ce0cce7e512c7348fa0f32629cd82e76353dd6d190\" ,\"idCliente\" : \""+idCliente+"\"}"
        
        
        print(jsonString)
        
        guard let jsonData = jsonString.data(using: .utf8) else { return }

        // Send request
        guard let url  = URL(string: "https://fast-fix.com.mx/pruebas/venegas/ws/v1/api/getCategorias")
                         else {return}
            
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("token", forHTTPHeaderField: "Authorization") // Most likely you want to add some token here
        // request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        
        
        URLSession.shared.dataTask(with: request){data,response,error in
            guard let data = data else {return}
            
            
            
            if let decodedData = try? JSONDecoder().decode([CategoriaJSONElement].self, from: data) {
                DispatchQueue.main.async {
                    self.categoriasLista = decodedData
    
                }
            }else{
                //ContentView()
                
                //self.showAlternoLogin = true
                self.categoriasLista = []
                
            }
        }.resume()
    }
    
    
    
    func registroCategoriaCliente(NameCategoria:String)
    {
        let idCliente = Configuration.value(defaultValue: "0", forKey: "idUser")
        // Encode your JSON data
        let jsonString = "{ \"idioma\" : \"es\", \"token\" : \"511ef473a779b64b1b52ce0cce7e512c7348fa0f32629cd82e76353dd6d190\" ,\"idCliente\" : \""+idCliente+"\",\"nombre\" : \""+NameCategoria+"\"}"
        
        
        print(jsonString)
        
        guard let jsonData = jsonString.data(using: .utf8) else { return }

        // Send request
        guard let url  = URL(string: "https://fast-fix.com.mx/pruebas/venegas/ws/v1/api/agregarCategoria")
                         else {return}
            
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("token", forHTTPHeaderField: "Authorization") // Most likely you want to add some token here
        // request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        
        
        URLSession.shared.dataTask(with: request){data,response,error in
            guard let data = data else {return}
            
            
            
            if let decodedData = try? JSONDecoder().decode(CategoriaRegistroJSON.self, from: data) {
                DispatchQueue.main.async {
                    self.categoriaRegistro = decodedData
                    
                    if self.categoriaRegistro?.error == 0 {
                        self.readCategoriasClientes()
                    }
    
                }
            }else{
                //ContentView()
                
                //self.showAlternoLogin = true
                self.categoriasLista = []
                
            }
        }.resume()
    }
    
    init() {
        readCategoriasClientes()
    }

}

