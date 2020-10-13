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
