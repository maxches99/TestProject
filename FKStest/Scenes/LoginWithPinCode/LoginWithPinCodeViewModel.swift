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
        user.name ?? ""
    }
	
	private let context = LAContext()
    
    private var user = UserConfigurator.shared
	
    private var password: String {
        guard let pincode = user.pincode else { return "" }
        return pincode
    }
	private var currentPassword = ""
	
	private let bag = DisposeBag()
	
	init() {
		switch context.biometryType {
			case .faceID:
                typeOfLA = user.isFaceID ? .faceID : .none
			case .touchID:
                typeOfLA = user.isTouchID ? .touchID : .none
			case .none:
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
        user.logOut()
        logOut.onNext(())
    }
	
}
