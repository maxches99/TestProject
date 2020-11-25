//
//  AppDelegate.swift
//  FKStest
//
//  Created by Студия on 07.10.2020.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let appCoordinator = AppCoordinator(navC: UINavigationController())
	
	lazy var persistanceContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "UserModel")
		
		container.loadPersistentStores() { (storeDescription, error) in
			if let error = error {
				fatalError(error.localizedDescription)
			}
		}

		return container
	}()
	
	func saveContext() {
		let context = persistanceContainer.viewContext
		
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				fatalError(error.localizedDescription)
			}
		}
	}

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.appCoordinator.start()
        
		return true
	}

}

