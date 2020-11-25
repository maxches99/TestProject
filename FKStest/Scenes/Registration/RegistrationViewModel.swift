//
//  RegistrationViewModel.swift
//  FKStest
//
//  Created by Администратор on 11.10.2020.
//

import RxSwift
import RxCocoa
import CryptoSwift
import Foundation
import CoreData
import UIKit

class RegistrationViewModel {
    
    let isSignIn = PublishSubject<Bool>()
    let goToAuth = PublishSubject<Void>()
    let user = UserConfigurator.shared
    
    func passwordHash(from email: String, password: String) -> String {
      let salt = "x4vV8bGgqqmQwgCoyXFQj+(o.nUNQhVP7ND"
      return "\(password).\(email).\(salt)".sha256()
    }
    
    func signIn(_ email: String, password: String, name: String) {
        if let passwordItems = try? KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: email).readPassword() {
            isSignIn.onNext(false)
        } else {
            do{
                try KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: email).savePassword(passwordHash(from: email, password: password))
                try KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: "\(email).name").savePassword(name)
                user.name = name
                user.email = email
                UserDefaults.standard.setValue(name, forKey: "name")
                UserDefaults.standard.setValue(email, forKey: "email")
				
				guard let appDelegate =
					UIApplication.shared.delegate as? AppDelegate else {
					return
				  }
				  
				  // 1
				  let managedContext =
					appDelegate.persistanceContainer.viewContext
				  
				  // 2
				  let entity =
					NSEntityDescription.entity(forEntityName: "User",
											   in: managedContext)!
				  
				  let person = NSManagedObject(entity: entity,
											   insertInto: managedContext)
				  
				  // 3
				  person.setValue(name, forKeyPath: "name")
				  person.setValue(email, forKeyPath: "email")
				  
				  // 4
				  do {
					try managedContext.save()
				  } catch let error as NSError {
					print("Could not save. \(error), \(error.userInfo)")
				  }
				
                isSignIn.onNext(true)
            }
            catch {
                isSignIn.onNext(false)
        }
            
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
