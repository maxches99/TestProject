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
	
	var loggedIn = PublishSubject<(Bool, Bool)>()
	var alertError = PublishSubject<String>()
	var currentDotIndex = PublishSubject<(Int, Bool)>()
	var typeOfLA: LABiometryType = .none
	
	private let context = LAContext()
	
	private var password = "11111"
	private var currentPassword = ""
	
	private let bag = DisposeBag()
	
	init(accessTypesOfBiometry: [BiometryType]) {
		switch context.biometryType {
			case .faceID:
				typeOfLA = accessTypesOfBiometry.contains(.faceID) ? .faceID : .none
			case .touchID:
				typeOfLA = accessTypesOfBiometry.contains(.touchID) ? .touchID : .none
			case .none:
				typeOfLA = .none
		}
        setPinCode()
	}
    
    func setPinCode() {
        let salt = "x4vV8bGgqqmQwgCoyXFQj+(o.nUNQhVP7ND"
        let email = UserDefaults.standard.string(forKey: "email")
        let key = "\(email).\(salt)".sha256()
        guard let password = UserDefaults.standard.string(forKey: key) else { return }
        self.password = password
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
	
}
