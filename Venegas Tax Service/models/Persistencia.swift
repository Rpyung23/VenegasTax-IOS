//
//  Persistencia.swift
//  Venegas Tax Service
//
//  Created by Vigitrack on 10/11/22.
//

import SwiftUI

import Foundation


class PersistenciaLogin:ObservableObject {
    
    @Published var isPersistencia = 0
    
    private func readPersistencia()
    {
        let myValue = Configuration.value(defaultValue: 0, forKey: "persistenciaLogin")
        print(myValue)
        self.isPersistencia = myValue

    }
    
    init() {
        readPersistencia()
    }
    
}
