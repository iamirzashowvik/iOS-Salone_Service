//
//  TakenServices.swift
//  Salone
//
//  Created by Mirza  on 20/5/23.
//

import SwiftUI

struct TakenServices: View {
    
    @Environment(\.managedObjectContext) var managedObject
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date,order:.reverse)]) var services:FetchedResults<ServiceX>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date,order:.reverse)]) var servicesType:FetchedResults<ServiceType>
    
    @Environment(\.dismiss) var dismiss
    
    
    
    @State private var showingAlert = false
    @State private var productCount:[Int16]=[]
    @State private var isArrayLoaded = false
    @State private var totalIncome:Float = 0.0
    @State private var tips:Float=10.0
    
   
        var date: Date

        init(date: Date) {
            self.date=date
        }
  
    func initialization(){
       
      
        self.totalIncome = 0.0
        for service in services{
            if isSameDay(date1: service.date!, date2: date) {
                self.totalIncome += ServiceTypeController().getService(id: service.id!, serviceTypes:  servicesType).price
            }
        }
    }
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    var body: some View {
      
       
        
            VStack(alignment:.leading ){
                HStack{
                    Text("Service History").onAppear{
                       initialization()
                       
                    }
                    Spacer()
                   
                    
                }.padding()
                if totalIncome>0.0{
                    Text("Total Income \(String(format: "%.2f",self.totalIncome)) of \(date, formatter: dateFormatter)").padding()
                }
                
                if totalIncome==0.0 {
                    Spacer()
                    HStack{
                        Spacer()
                        Text("No Service done in \(date, formatter: dateFormatter)")
                        Spacer()
                        
                    }
                }
                List{
                    ForEach(services) { service in
                       
                            if isSameDay(date1: service.date!, date2: date) {
                                VStack(alignment: .leading){
                                Text(ServiceTypeController().getService(id: service.id!, serviceTypes:  servicesType).name!)
                                Text(calcTimeSince(date:service.date!))
                            }
                        }
                    }.onDelete(perform: deleteProduct)
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
            initialization()
        }
    }
    let doubleFormatter: NumberFormatter = {
              let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
              return formatter
         }()
}
