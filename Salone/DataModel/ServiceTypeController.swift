import Foundation
import SwiftUI
import CoreData

class ServiceTypeController:ObservableObject{
    let serviceTypeContainer = NSPersistentContainer(name: "ServiceTypeModel")
    
    
    init() {
        serviceTypeContainer.loadPersistentStores{ desc, error in
            if let error = error {
                 print("Failed to load data From ServicesType Container \(error.localizedDescription)")
            }
        }
    }
    
    func save(context:NSManagedObjectContext){
        do{
            try context.save();
            print("Data saved")
           
        } catch{
            print("Error on data saving")
        }
    }
    
    func addServiceType( id:String,name:String,price:Float, context:NSManagedObjectContext){
        let serviceType = ServiceType(context: context);
        serviceType.id = id
        serviceType.date = Date()
        serviceType.name = name
        serviceType.usedTime = 0
        serviceType.price = price
        save(context: context)
    }
    func editServiceType( usedTime:Int16,serviceType:ServiceType, context:NSManagedObjectContext){
        serviceType.date = Date()
        serviceType.usedTime = usedTime
        save(context: context)
    }
    func addHistory(id:String,context:NSManagedObjectContext){
        let service = ServiceX(context: context);
        service.id=id
        service.date=Date()
        save(context: context)
    }
    
    func getService(id:String,serviceTypes:FetchedResults<ServiceType>)->ServiceType{
        for serviceType in serviceTypes {
            if serviceType.id==id{
                return serviceType
            }
        }
        return serviceTypes[0];
    }
    
    func getServiceCount(id:String,services:FetchedResults<ServiceX>)->Int16{
        var count:Int16=0
        for service in services {
            if service.id==id{
                count += 1 ;
            }
        }
        return count;
    }
    
    
    
    func delete1ServiceFromHistory (id:String, services:FetchedResults<ServiceX>, context:NSManagedObjectContext) {
        for service in services {
            if service.id==id{
                context.delete(service)
                return;
            }
        }
    }
    func deleteServiceFromHistory (id:String, services:FetchedResults<ServiceX>, context:NSManagedObjectContext) {
        for service in services {
            if service.id==id{
                context.delete(service)
            }
        }
    }
}
