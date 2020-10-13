//
//  AuthAccountViewModel.swift
//  FKStest
//
//  Created by Администратор on 11.10.2020.
//

import RxSwift
import RxCocoa
import CryptoSwift
import Foundation

class AuthAccountViewModel {
    
    let isSignIn = PublishSubject<Bool>()
    let goToRegistration = PublishSubject<Void>()
    let user = UserConfigurator.shared
    
    func passwordHash(from email: String, password: String) -> String {
      let salt = "x4vV8bGgqqmQwgCoyXFQj+(o.nUNQhVP7ND"
      return "\(password).\(email).\(salt)".sha256()
    }
    
    func signIn(_ email: String, password: String) {
        do{
            let passwordItems = try KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: email).readPassword()
            if passwordHash(from: email, password: password) == passwordItems {
                let name = try KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: "\(email).name").readPassword()
                user.name = name
                user.email = email
                UserDefaults.standard.setValue(name, forKey: "name")
                UserDefaults.standard.setValue(email, forKey: "email")
                isSignIn.onNext(true)
            } else {
                isSignIn.onNext(false)
            }
        }
        catch {
            isSignIn.onNext(false)
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
