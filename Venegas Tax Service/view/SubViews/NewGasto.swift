//
//  NewGasto.swift
//  Venegas Tax Service
//
//  Created by Vigitrack on 5/11/22.
//

import SwiftUI
import PhotosUI
import Foundation
import Cloudinary
import AlertMessage


struct RegistroGastoJSON: Codable {
    let error, id: Int?
    let descripcion: String?
}

final class ViewModel:ObservableObject{
    @Published var showFoto  = false;
    @Published var image: Image = Image("no_foto")
    @Published var pngData: Data = Data()
    @Published var photoSelecction: PhotosPickerItem? {
        didSet{
            if let photoSelecction {
                loadTransferable(from: photoSelecction)
            }
        }
    }
    
    private func loadTransferable(from photoSelecction: PhotosPickerItem)
    {
        photoSelecction.loadTransferable(type: Data.self){
            result in DispatchQueue.main.async {
                guard photoSelecction == self.photoSelecction else {
                    return
                }
                switch result {
                case .success(let data):
                    let uiImage = UIImage(data: data!)
                    print(uiImage?.pngData())
                    self.pngData = uiImage?.pngData() ?? Data()
                    self.image = Image(uiImage: uiImage!)
                    self.showFoto = true
                    
                case .failure(let error):
                    print(error)
                    self.image = Image("no_foto")
                    self.showFoto = false
                }
            }
        }
    }
}



struct AlertView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .foregroundColor(.black.opacity(0.8))
            VStack {
                HStack {
                    ProgressView().tint(.white)
                    Text("Subiendo Gato...").foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.leading,10)
                }
            }
        }.ignoresSafeArea()
    }
}


struct NewGasto: View {
    

    var nameCategoria: String
    var idCategoria: String
    var configCloud = CLDConfiguration(cloudName: "virtualcode7",apiKey:"326765852589769", secure: true)
    @StateObject var viewModel = ViewModel()

    @State private var monto: String = ""
    @State private var nota: String = ""
    @State var showAlertProgress = false
    @State var oG: RegistroGastoJSON?
    @State var showAlertErrorRegistro = false
    @State var showSnackbnar = false
    
    
    func openCamera()
    {

    }
    
    private func uploadFoto(idCategoria:String,monto:String,nota:String)
    {
        if viewModel.photoSelecction == nil {
            self.showSnackbnar = true
        }else{
            
            let cloudinary = CLDCloudinary(configuration: configCloud)
            let preprocessChain = CLDImagePreprocessChain()
              .addStep(CLDPreprocessHelpers.limit(width: 500, height: 500))
              .addStep(CLDPreprocessHelpers.dimensionsValidator(minWidth: 10, maxWidth: 500, minHeight: 10, maxHeight: 500))
              .setEncoder(CLDPreprocessHelpers.customImageEncoder(format: EncodingFormat.PNG, quality: 70))
                       

            let requestCloud = cloudinary.createUploader().upload(
                data: viewModel.pngData, uploadPreset: "zirihja1",preprocessChain: preprocessChain) { (progress) in
                  print(progress)
            } completionHandler: { (image, error) in
                  // Handle result
                var url = image?.url
                print(url)
                print(error)
                
                if url != nil {
                    insertGasto(urlFoto: url ?? "https://venegastaxservice.com/img/venegas_logo.jpg",idCategoria: idCategoria, monto: monto, nota: nota)
                }else{
                    print("ERROR AL SUBIRA LA FOTO")
                    self.showAlertProgress = false
                }
                
                
            }
        }
        
        
    }
    
    private func insertGasto(urlFoto:String,idCategoria:String,monto:String,nota:String)
    {

        
        
        if urlFoto.isEmpty || monto.isEmpty || nota.isEmpty {
            self.showSnackbnar = true
        }else{
            let idCliente = Configuration.value(defaultValue: "0", forKey: "idUser")
            
            
            
            let jsonString = "{ \"idioma\" : \"es\", \"token\" : \"511ef473a779b64b1b52ce0cce7e512c7348fa0f32629cd82e76353dd6d190\" ,\"idCliente\" : \""+idCliente+"\" ,\"idCategoria\" : \""+idCategoria+"\" ,\"monto\" : \""+monto+"\" ,\"nota\" : \""+nota+"\",\"rutaFoto\" : \""+urlFoto+"\"}"
            
            
            print(jsonString)
            
            guard let jsonData = jsonString.data(using: .utf8) else { return }

            // Send request
            guard let url  = URL(string: "https://fast-fix.com.mx/pruebas/venegas/ws/v1/api/agregarGasto")
                             else {return}
                
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData

            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("token", forHTTPHeaderField: "Authorization") // Most likely you want to add some token here
            // request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

            
            
            URLSession.shared.dataTask(with: request){data,response,error in
                guard let data = data else {return}
                
                
                
                if let decodedData = try? JSONDecoder().decode(RegistroGastoJSON.self, from: data)
                {
                    DispatchQueue.main.async {
                        self.oG = decodedData
                        print(self.oG?.error)
                        print(self.oG?.descripcion)
                        if self.oG?.error == 0 {
                            self.monto = ""
                            self.nota = ""
                            self.viewModel.showFoto = false
                        }
                        
                        self.showAlertProgress = false
                        
        
                    }
                }else{
                    self.showAlertProgress = false
                    
                }
            }.resume()
        }

        
    }
    

 
    
    var body: some View {
        
        ZStack{
            
            VStack{
                
                Text(nameCategoria).font(.title).fontWeight(.bold).foregroundColor(Color("blueTax")).multilineTextAlignment(.center)
                TextField("Ingrese el monto", text: $monto).padding()
                    .background(.white)
                    .font(.headline)
                    .cornerRadius(5.0)
                    .keyboardType(.numbersAndPunctuation)
                
                TextField("Agregar nota", text: $nota,axis: .vertical).lineLimit(3).padding()
                    .frame(height: 100)
                    .background(.white)
                    .font(.headline)
                    .cornerRadius(5.0)
                
                

                
                
                HStack{
                    
                    /*Button(action: {}, label: {
                        HStack{
                            Image(systemName: "photo").foregroundColor(.black).imageScale(.large)
                            Text("Galería").foregroundColor(.blue)
                        }
                    }).frame(maxWidth: .infinity).padding().background(Color(.white)).foregroundColor(.white).fontWeight(.bold).cornerRadius(10)*/
                    
                    
                    PhotosPicker(selection: $viewModel.photoSelecction, matching: .images,
                                 photoLibrary: .shared()){
                        Label("Galería", systemImage: "photo").foregroundColor(Color("blueTax")).imageScale(.large)
                    }.frame(maxWidth: .infinity).padding().background(Color(.white)).foregroundColor(.white).fontWeight(.bold).cornerRadius(10)
                    
                    Button(action: {}, label: {
                        HStack{
                            Image(systemName: "camera").foregroundColor(Color("blueTax")).imageScale(.large)
                            Text("Cámara").foregroundColor(Color("blueTax"))
                        }
                        
                        
                    }).frame(maxWidth: .infinity).padding().background(Color(.white)).foregroundColor(.white).fontWeight(.bold).cornerRadius(10)
                }.padding(.top,20)
                
                
                if viewModel.showFoto {
                    viewModel.image
                        .resizable()
                        .frame(maxWidth: 150,maxHeight: 150)
                        .imageScale(.large)
                        .padding(.top,15)
                }
                
                Spacer()
                
                
                Button(action: {
                    
                    uploadFoto(idCategoria: idCategoria, monto: monto, nota: nota)
                    //insertGasto(idCategoria: idCategoria, monto: monto, nota: nota)
                }, label: {
                    Text("SUBIR FOTO")
                    
                }).frame(maxWidth: .infinity).padding().background(Color("redTax")).foregroundColor(.white).fontWeight(.bold).cornerRadius(50)
                
            }.padding()
            
            if showAlertProgress {
                AlertView()
            }
            
            
        }.background(Color("fondo"))
        .alert("VENEGAS TAX SERVICE", isPresented: $showAlertErrorRegistro, actions: {
            Button("Aceptar", role: .cancel, action: {
                self.showAlertProgress = false
            })
        }, message: {
            Text("No se ha podido regitrar el gasto.")
        }).alertMessage(isPresented: $showSnackbnar, type: .banner,autoHideIn: 1.5) {
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
        }
    }
}

struct NewGasto_Previews: PreviewProvider {
    static var previews: some View {
        NewGasto(nameCategoria: "DEFAULT",
                 idCategoria: "100")
    }
}
