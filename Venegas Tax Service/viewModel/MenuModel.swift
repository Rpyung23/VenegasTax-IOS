//
//  MenuModel.swift
//  Venegas Tax Service
//
//  Created by Vigitrack on 5/11/22.
//

import SwiftUI

// Menu Data...

class MenuViewModel: ObservableObject{
    
    //Default...
    @Published var selectedMenu = "Crear Gasto"
    
    // Show...
    @Published var showDrawer = false
    

    
}
