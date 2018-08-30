//
//  UserCore.swift
//  TelminApp
//
//  Created by KEOSALY on 10/3/17.
//  Copyright © 2017 KEOSALY. All rights reserved.
//

import Foundation
import CoreData
class UserCore {
    static func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    static func storeUser (_ username: String, password:String, token:String) {
        let context = getContext()
        
        //retrieve the entity that we just created
        let entity = NSEntityDescription .entity(forEntityName: "UserEntity", in: context)
        
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        
        //set the entity values
        transc.setValue(username, forKey: "username")
        transc.setValue(token, forKey: "token")
        transc.setValue(password, forKey: "password")
       
        
        //save the object
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
    static func getUser () -> String {
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        
        do {
            //go get the results
            let searchResults = try getContext().fetch(fetchRequest)
            
            //I like to check the size of the returned results!
           // print ("num of results = \(searchResults.count)")
            
            //You need to convert to NSManagedObject to use 'for' loops
            for trans in searchResults as [NSManagedObject] {
                //get the Key Value pairs (although there may be a better way to do that...
                var tokentID = trans.value(forKey: "token")!
                return tokentID as! String
            }
            
    
        } catch {
            print("Error with request: \(error)")
        }
        return ""
    }
    static func deleteRecords() -> Void {
        let moc = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
        
        let result = try? moc.fetch(fetchRequest)
        let resultData = result as! [UserEntity]
        
        for object in resultData {
            moc.delete(object)
        }
        
        do {
            try moc.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
        
    }
}
