import Foundation
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
        
    }
}
