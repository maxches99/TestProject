//
//  ViewModel.swift
//  FKStest
//
//  Created by Студия on 07.10.2020.
//

import Foundation
import RxSwift
import RxCocoa
import LocalAuthentication
import CryptoSwift

class LoginWithPinCodeViewModel {
	
	let loggedIn = PublishSubject<(Bool, Bool)>()
    let alertError = PublishSubject<String>()
    let goToNextScreen = PublishSubject<Void>()
    let logOut = PublishSubject<Void>()
    let currentDotIndex = PublishSubject<(Int, Bool)>()
	var typeOfLA: LABiometryType = .none
    
    var name: String {
        UserConfigurator.shared.name ?? ""
    }
    
    private let context = LAContext()
    
    private var password: String {
        return UserConfigurator.shared.pincode
    }
	private var currentPassword = ""
	
	private let bag = DisposeBag()
	
	init() {
        UserConfigurator.shared.refresh()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            switch context.biometryType {
            case .faceID:
                typeOfLA = UserConfigurator.shared.isFaceID ?? false ? .faceID : .none
            case .touchID:
                typeOfLA = UserConfigurator.shared.isTouchID ?? false ? .touchID : .none
            case .none:
                typeOfLA = .none
            }} else {
                typeOfLA = .none
            }
	}
    
    func auth() {
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Biometric Auth") {
			[weak self] (res, err) in
			DispatchQueue.main.async {
				self?.loggedIn.onNext((res, true))
			}
		}
	}
	
	func tryPass(password: String) {
		if password == self.password {
			loggedIn.onNext((true, false))
		} else {
			loggedIn.onNext((false, false))
		}
		
	}
	
	func addToCurrentString(string: String) {
		if currentPassword.count < password.count {
			currentPassword.append(string)
			currentDotIndex.onNext((currentPassword.count - 1, true))
			if currentPassword.count == password.count {
				tryPass(password: currentPassword)
			}
			
		}
	}
	
	func deleteCharacterInToCurrentString() {
		if currentPassword.count > 0 {
			currentPassword.removeLast()
			currentDotIndex.onNext((currentPassword.count, false))
		}
	}
    
    func shouldLogOut() {
        UserConfigurator.shared.logOut()
        logOut.onNext(())
    }
	
}
