//
//  ServiceController.swift
//  Salone
//
//  Created by Mirza  on 20/5/23.
//

import Foundation
import CoreData

class ServiceController:ObservableObject{
    let servicesContainer    =  NSPersistentContainer(name: "ServiceModel")
    
    init() {
        servicesContainer.loadPersistentStores{ desc , error in
            if let error = error {
                 print("Failed to load data From Services Container \(error.localizedDescription)")
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
    func addHistory( id:String, context:NSManagedObjectContext){
        let serviceType = ServiceType(context: context);
        serviceType.id = id
        serviceType.date = Date()
        save(context: context)
    }
}
