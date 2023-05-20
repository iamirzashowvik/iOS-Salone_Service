//
//  SaloneApp.swift
//  Salone
//
//  Created by Mirza  on 20/5/23.
//

import SwiftUI

@main
struct SaloneApp: App {
    @StateObject private var serviceTypeController = ServiceTypeController()
    
    
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(
                \.managedObjectContext,serviceTypeController.serviceTypeContainer.viewContext)
        }
    }
}
