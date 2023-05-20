import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObject
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date,order:.reverse)]) var services:FetchedResults<ServiceType>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date,order:.reverse)]) var servicesX:FetchedResults<ServiceX>
    
    @State private var showingAddView = false
    @State private var showingCart = false
    @State private var showingAlert = false
    @State private var isArrayLoaded = false
    @State private var serviceCount:[Int16]=[]
    @State private var birthDate = Date.now
    @State private var datepickerCounter=0
    @State private var navigateToSecondPage = false
    
   func initialService(){
       self.serviceCount=[];
       self.isArrayLoaded=false
        for service in services {
            self.serviceCount.append(ServiceTypeController().getServiceCount(id: service.id!, services: servicesX))
        }
        self.isArrayLoaded=true;
    }
    
    var body: some View {
        
        NavigationView{
            VStack(alignment:.leading ){
                Text("Top Services").onAppear{
                   initialService()
                }.padding().bold()
                if services.isEmpty {
                    HStack{
                        Spacer()
                        VStack{
                            AsyncImage(url: URL(string: "https://i.pinimg.com/originals/ae/8a/c2/ae8ac2fa217d23aadcc913989fcc34a2.png"), content: { image in
                                       image.resizable()
                                   }, placeholder: {
                                       ProgressView()
                                   })
                                       .frame(width: 100, height: 100)
                                       .clipShape(Circle())
                            Text("No Service Available").padding()
                        }
                        Spacer()
                    }
                }
                if self.isArrayLoaded {
                    List{
                        ForEach(Array(services.enumerated()),id: \.element){ index,service in
                            HStack{
                                VStack(alignment:.leading){
                                    Text("\(service.name!)").bold()
                                    Text("\(String(format: "%.2f", service.price)) Taka")}
                                Spacer()
                                if self.serviceCount.count>0{
                                    HStack{
                                        Button(action: {}, label: {Image(systemName: "minus.square")}).onTapGesture {
                                            self.serviceCount[index] -= 1 ;
                                            ServiceTypeController().editServiceType(usedTime: self.serviceCount[index], serviceType: service, context: managedObject)
                                            ServiceTypeController().delete1ServiceFromHistory(id: service.id!, services: servicesX, context: managedObject)
                                            if self.serviceCount[index]==0 {
                                                ServiceTypeController().deleteServiceFromHistory(id: service.id!, services: servicesX, context: managedObject)
                                            }
                                            initialService()
                                        }
                                        if self.serviceCount.count==services.count {
                                            Text("\(self.serviceCount[index])")
                                        }
                                       
                                    }
                                }
                               
                                Button(action: {}, label: {Image(systemName: "plus.app")}).onTapGesture {
                                    self.serviceCount[index] += 1 ;
                                    ServiceTypeController().editServiceType(usedTime: self.serviceCount[index], serviceType: service, context: managedObject)
                                    ServiceTypeController().addHistory(id: service.id!, context: managedObject)
                                    initialService()
                                }
                                
                            }
                            
                        }.onDelete(perform: deleteService)
                        DatePicker(selection: $birthDate, in: ...Date.now, displayedComponents: .date) {
                                       Text("Check history")
                        }.onTapGesture {
                            self.updateWeekAndDayFromDate()
                        }
                    }.navigationTitle("Salone")
                        .toolbar{
                            ToolbarItem(placement: .navigationBarTrailing ){
                                if servicesX.count>0 {

                                    NavigationLink(destination: TakenServices(date:birthDate ).onDisappear() {
                                        initialService()
                                        print("Hello world!exit")
                                    },isActive: $navigateToSecondPage) {
                                                    Label("Work Folder", systemImage: "clock.arrow.circlepath")
                                    }.hidden()
                                }
                            }
                            ToolbarItem(placement: .navigationBarTrailing ){

                                NavigationLink(destination: AddServiceTypeView().onDisappear() {
                                    initialService()
                                   
                                }) {
                                                Label("Work Folder", systemImage: "plus.circle")
                                            }
                            }
                            
                        }.sheet(isPresented: $showingAddView){
                            AddServiceTypeView()
                        }
                      
                }
            }.navigationViewStyle(.stack).alert("Important message", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            }
            
            .onReceive(NotificationCenter.default.publisher(for: AlertClassX.showAlertMsg)) { msg in
                self.showingAlert = true
            }
        }
        
    }
    func updateWeekAndDayFromDate() {
        datepickerCounter+=1;
        if datepickerCounter%2==0{
            print(birthDate)
          navigateToSecondPage = true
        }
            
        }
    func deleteService(offsets:IndexSet){
        withAnimation {
            offsets.map { services[$0] }.forEach (managedObject.delete)
            ServiceTypeController().save(context: managedObject)
        }
    }}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

