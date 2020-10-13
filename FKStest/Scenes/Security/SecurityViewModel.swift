//
//  SecurityViewModel.swift
//  FKStest
//
//  Created by Администратор on 12.10.2020.
//

import Foundation
import RxSwift
import RxCocoa
import LocalAuthentication

class SecurityViewModel {
    
    private(set) var isTouchID: Bool
    private(set) var isFaceID: Bool
    
    let goBack = PublishSubject<Void>()
    let goToChangePincode = PublishSubject<Void>()
    let toggleTouchID = PublishSubject<Void>()
    let toggleFaceID = PublishSubject<Void>()
    
    private let bag = DisposeBag()
    
    private let user = UserConfigurator()
    
    private let context = LAContext()
    
    init() {
        isFaceID = user.isFaceID
        isTouchID = user.isTouchID
    }
    
    private func setupBindings() {
        toggleTouchID
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                
                strongSelf.context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Biometric Auth") {
                    [weak self] (res, err) in
                    DispatchQueue.main.async {
                        if res {
                            strongSelf.user.toggleTouchID()
                        }
                    }
                }
                strongSelf.isTouchID = strongSelf.user.isTouchID
            })
            .disposed(by: bag)
        
        toggleFaceID
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Biometric Auth") {
                    [weak self] (res, err) in
                    DispatchQueue.main.async {
                        if res {
                            strongSelf.user.toggleFaceID()
                        }
                    }
                }
                strongSelf.isFaceID = strongSelf.user.isFaceID
            })
            .disposed(by: bag)
    }
    
    
}
