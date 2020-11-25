//
//  ProfileViewModel.swift
//  FKStest
//
//  Created by Администратор on 12.10.2020.
//

import Foundation
import RxSwift

class ProfileViewModel {
    
    let name: String
    let email: String
    
    let goToSecurityScreen = PublishSubject<Void>()
	let changePhoto = PublishSubject<Void>()
    let logOut = PublishSubject<Void>()
    
    private let user = UserConfigurator.shared
    
    init() {
        name = user.name ?? ""
        email = user.email ?? ""
    }
    
    func logout() {
        user.logOut()
        logOut.onNext(())
    }
}
