//
//  ContentView.swift
//  Salone
//
//  Created by Mirza  on 20/5/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObject
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date,order:.reverse)]) var services:FetchedResults<ServiceType>
    
    @State private var showingAddView = false
    @State private var showingCart = false
    @State private var showingAlert = false
    @State private var isArrayLoaded = false
    @State private var serviceCount:[Int16]=[]
    
    
    
    var body: some View {
        
        NavigationView{
            VStack(alignment:.leading ){
                Text("Top Services").onAppear{
                    for service in services {
                        self.serviceCount.append(service.usedTime)
                    }
                    self.isArrayLoaded=true;
                    
                }.padding()
                List{
                    ForEach(Array(services.enumerated()),id: \.element){ index,service in
                        HStack{
                            VStack(alignment:.leading){
                                Text("\(service.name!) ").bold()
                                Text("\(String(format: "%.2f", service.price)) Taka")
                                
                            }
                            Spacer()
                            if service.usedTime>0{
                                HStack{
                                    Text("\(service.usedTime)")
                                    Image(systemName: "checkmark")
                                }
                            }
                            Spacer()
                            Button(action: {}, label: {Image(systemName: "plus.app")}).onTapGesture {
                                self.serviceCount[index] += 1 ;
                                print("plus called")
                                
                                print(self.serviceCount)
                                ServiceTypeController().editServiceType(usedTime: self.serviceCount[index], serviceType: service, context: managedObject)
                                
                                
                                
                            }
                            
                        }.onDelete(perform: deleteProduct)
                    }
                    
                }.navigationTitle("Salone")
                    .toolbar{
                        ToolbarItem(placement: .navigationBarTrailing ){
                            Button{
                                showingAddView.toggle();
                            } label: {
                                Label("Add Product",systemImage: "plus.circle")
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing ){
                            Button{
                                showingCart.toggle();
                            } label: {
                                Label("Cart",systemImage: "cart")
                            }
                        }
                    }.sheet(isPresented: $showingAddView){
                        AddServiceTypeView()
                    }
                    .sheet(isPresented: $showingCart){
                        TakenServices()
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
}
