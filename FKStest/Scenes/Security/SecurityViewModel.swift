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
    let changeStateFaceID = PublishSubject<Void>()
    let changeStateTouchID = PublishSubject<Void>()
    
    private let bag = DisposeBag()
    
    private let user = UserConfigurator.shared
    
    init() {
        isFaceID = user.isFaceID
        isTouchID = user.isTouchID
        
        setupBindings()
    }
    
    private func setupBindings() {
        toggleTouchID
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                let context = LAContext()
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Biometric Auth") {
                    [weak self] (res, err) in
                    DispatchQueue.main.async {
                        if res {
                            self?.user.toggleFaceID()
                            self?.isTouchID.toggle()
                            self?.changeStateTouchID.onNext(())
                        } else {
                            self?.changeStateTouchID.onNext(())
                        }
                    }
                }
            })
            .disposed(by: bag)
        
        toggleFaceID
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                let context = LAContext()
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Biometric Auth") {
                    [weak self] (res, err) in
                    DispatchQueue.main.async {
                        if res {
                            self?.user.toggleFaceID()
                            self?.isFaceID.toggle()
                            self?.changeStateFaceID.onNext(())
                        } else {
                            self?.changeStateFaceID.onNext(())
                        }
                    }
                }
            })
            .disposed(by: bag)
    }
    
    
}
