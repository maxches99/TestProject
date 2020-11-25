//
//  UserConfigurator.swift
//  FKStest
//
//  Created by Администратор on 12.10.2020.
//

import Foundation
import LocalAuthentication
import UIKit
import CoreData

class UserConfigurator {
    
    static let shared = UserConfigurator()
    
    let context = LAContext()
	
	var user: [NSManagedObject] = []
    
	var name: String
    
	var email: String
    
	var pincode: String {
		UserDefaults.standard.string(forKey: "pincode") ?? ""
	}
    
	private(set) var isTouchID: Bool
    
	private(set) var isFaceID: Bool
	
	private var person: NSManagedObject
	
	private let managedContext: NSManagedObjectContext
	
	init() {
		
		guard let appDelegate =
				UIApplication.shared.delegate as? AppDelegate else {
			name = ""
			
			email =  ""
			
			isTouchID = false
			
			isFaceID = false
			
			person = NSManagedObject()
			
			managedContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
			
			return
		}
		
		managedContext =
			appDelegate.persistanceContainer.viewContext
		
		let fetchRequest =
			NSFetchRequest<NSManagedObject>(entityName: "User")
		
		guard let user = try? managedContext.fetch(fetchRequest) else {
			name = ""
			
			email =  ""
			
			isTouchID = false
			
			isFaceID = false
			
			person = NSManagedObject()
			
			return
		}
		
		guard let person = user.first(where: {
										$0.value(forKeyPath: "email") as? String ?? "" ==
											UserDefaults.standard.string(forKey: "email")
			
		}) else {
			name = ""
			
			email =  ""
			
			isTouchID = false
			
			isFaceID = false
			
			self.person = NSManagedObject()
			
			return
		}
		
		self.person = person
		
		name = person.value(forKeyPath: "name") as? String ?? ""
		
		email = person.value(forKeyPath: "email") as? String ?? ""
		
		isTouchID = person.value(forKeyPath: "isTouchID") as? Bool ?? false
		
		isFaceID = person.value(forKeyPath: "isFaceID") as? Bool ?? false
	}
	
	func refresh() {
		guard let person = user.first(where: {
										$0.value(forKeyPath: "email") as? String ?? "" ==
											UserDefaults.standard.string(forKey: "email")
			
		}) else {
			return
		}
		
		self.person = person
		
		isTouchID = person.value(forKeyPath: "isTouchID") as? Bool ?? false
		
		isFaceID = person.value(forKeyPath: "isFaceID") as? Bool ?? false
	}
	
	func toggleTouchID() {
		person.setValue(!(isTouchID ?? false), forKey: "isTouchID")
		try? managedContext.save()
	}
	
	func toggleFaceID() {
		person.setValue(!(isFaceID ?? false), forKey: "isFaceID")
		try? managedContext.save()
	}
	
	func setPincode(pinCode: String) {
		UserDefaults.standard.setValue(pinCode, forKey: "pincode")
	}
	
	func logOut() {
        UserDefaults.standard.setValue(nil, forKey: "pincode")
        UserDefaults.standard.setValue(nil, forKey: "email")
    }
    
}
