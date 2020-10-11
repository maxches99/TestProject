//
//  RegistrationViewModel.swift
//  FKStest
//
//  Created by Администратор on 11.10.2020.
//

import RxSwift
import RxCocoa
import CryptoSwift

class RegistrationViewModel {
    
    let isSignIn = PublishSubject<Bool>()
    
    func passwordHash(from email: String, password: String) -> String {
      let salt = "x4vV8bGgqqmQwgCoyXFQj+(o.nUNQhVP7ND"
      return "\(password).\(email).\(salt)".sha256()
    }
    
    func signIn(_ email: String, password: String) {
        do{
            try KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: email).savePassword(passwordHash(from: email, password: password))
            isSignIn.onNext(true)
        }
        catch {
            isSignIn.onNext(false)
        }
    }
}
