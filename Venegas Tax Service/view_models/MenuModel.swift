//
//  MenuModel.swift
//  Venegas Tax Service
//
//  Created by Vigitrack on 2/11/22.
//

import SwiftUI

class MenuViewModel: ObservableObject
{
    @Published var selectedMenu = "Crear Gasto"
    @Published var showDrawer = false
}
