//
//  TakenServices.swift
//  Salone
//
//  Created by Mirza  on 20/5/23.
//

import SwiftUI

struct TakenServices: View {
    
    @Environment(\.managedObjectContext) var managedObject
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date,order:.reverse)]) var services:FetchedResults<ServiceType>
    @Environment(\.dismiss) var dismiss
    
    
    
    @State private var showingAlert = false
    @State private var productCount:[Int16]=[]
    @State private var isArrayLoaded = false
    @State private var totalPrice:Float = 0.0
    @State private var tips:Float=10.0
    
  
    
    var body: some View {
      
       
        
            VStack(alignment:.leading ){
               
                List{
                    ForEach(services) { service in
                        Text(service.id!)
                    }
                }
               
        }.navigationViewStyle(.stack).alert("Important message", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        }
        
        .onReceive(NotificationCenter.default.publisher(for: AlertClassX.showAlertMsg)) { msg in
            self.showingAlert = true
        }
        
    }
    func deleteProduct(offsets:IndexSet){
        withAnimation {
            offsets.map { services[$0] }.forEach (managedObject.delete)
      ServiceTypeController() . save (context: managedObject)
        }
    }
    let doubleFormatter: NumberFormatter = {
              let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
              return formatter
         }()
}
