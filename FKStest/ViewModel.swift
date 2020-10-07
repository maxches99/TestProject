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

class ViewModel {
	
	var loggedIn = PublishSubject<(Bool, Bool)>()
	var alertError = PublishSubject<String>()
	var currentDotIndex = PublishSubject<(Int, Bool)>()
	var typeOfLA: LABiometryType = .none
	
	private let context = LAContext()
	
	private var password = "1111"
	private var currentPassword = ""
	
	private let bag = DisposeBag()
	
	init() {
		typeOfLA = context.biometryType
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
