import SwiftUI
import Foundation


// MARK: - CategoriaJSON
struct GastoJSONElement: Identifiable,Decodable {
    let id: String?
    let foto: String?
    let categoria, cliente, fecha, monto: String?
    let nota: String?
}


class GastoModel:ObservableObject {
    @Published var gastosLista = [GastoJSONElement]()
    
    private func readGastosClientes()
    {
        let idCliente = Configuration.value(defaultValue: "0", forKey: "idUser")
        // Encode your JSON data
        let jsonString = "{ \"idioma\" : \"es\", \"token\" : \"511ef473a779b64b1b52ce0cce7e512c7348fa0f32629cd82e76353dd6d190\" ,\"idCliente\" : \""+idCliente+"\"}"
        
        
        print(jsonString)
        
        guard let jsonData = jsonString.data(using: .utf8) else { return }

        // Send request
        guard let url  = URL(string: "https://fast-fix.com.mx/pruebas/venegas/ws/v1/api/getGastosByCliente")
                         else {return}
            
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("token", forHTTPHeaderField: "Authorization") // Most likely you want to add some token here
        // request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        
        
        URLSession.shared.dataTask(with: request){data,response,error in
            guard let data = data else {return}
            
            
            
            if let decodedData = try? JSONDecoder().decode([GastoJSONElement].self, from: data) {
                DispatchQueue.main.async {
                    self.gastosLista = decodedData
    
                }
            }else{
                //ContentView()
                
                //self.showAlternoLogin = true
                self.gastosLista = []
                
            }
        }.resume()
    }
    
    init() {
        readGastosClientes()
    }

}
