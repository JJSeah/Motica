//
//  AppDelegate.swift
//  Motica
//
//  Created by MAD2 on 7/1/19.
//  Copyright © 2019 Jeremy. All rights reserved.
//

import UIKit
import CoreData
var game = "something"
var petselected = 0

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        StoreTestAccount()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Motica")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func StoreTestAccount(){
        
        if(CountAccount() == 0){
            let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            //Stored First Account
            let title = "MAD"
            let notes = "Motica"
            let task1 = Task(context: context)
            task1.title = title
            task1.subtext = notes
            task1.deletion = "N"
            task1.difficulty = 3
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let someDateTime = formatter.date(from: "25/01/2019")
            task1.duedate = someDateTime
        
            let money = Account(context: context)
            money.money = 0;
            
            let pet = Pet(context: context)
            pet.name = "Sharkie"
            pet.health = 5;
            pet.energy = 0;
            pet.exp = 0;
            pet.lvl = 1;
            pet.lock = 1;
            pet.picture = "shark"
            
            appDelegate.saveContext()
            
            let pet2 = Pet(context: context)
            pet2.name = "Whalie"
            pet2.health = 5;
            pet2.energy = 0;
            pet2.exp = 0;
            pet2.lvl = 1;
            pet2.lock = 0; //lock is 0
            pet2.picture = "whale"
            
            appDelegate.saveContext()
            
            let pet3 = Pet(context: context)
            pet3.name = "Ollie"
            pet3.health = 5;
            pet3.energy = 0;
            pet3.exp = 0;
            pet3.lvl = 1;
            pet3.lock = 0; //lock is 0
            pet3.picture = "otter"
            
            appDelegate.saveContext()
            
            let game1 = Game(context: context)
            game1.name = "flappypet"
            game1.highscore = 0
            appDelegate.saveContext()
            
            let game2 = Game(context: context)
            game2.name = "PetJump"
            game2.highscore = 0
            appDelegate.saveContext()
            

        }
        
    }
    // check if it is empty
    func CountAccount() -> Int {
        var numofAccount:Int = 0
        do {
            let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let result = try context.fetch(Task.fetchRequest())
            let task = result as! [Task]
            numofAccount = task.count
        }
        catch{
            print("Error")
            numofAccount = 0
        }
        return numofAccount
    }
    
    

}

