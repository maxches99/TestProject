//
//  CreateChangePincodeViewModel.swift
//  FKStest
//
//  Created by Администратор on 12.10.2020.
//

import Foundation
import RxSwift
import RxCocoa

class CreateChangePincodeViewModel {
    
    var currentDotIndex = PublishSubject<(Int, Bool)>()
    let pincodeCompleted = PublishSubject<Void>()
    let goToNextScreen = PublishSubject<Void>()
    
    private let user = UserConfigurator.shared
    private var currentPassword = ""
    
    private let bag = DisposeBag()
    
    init() {
        setupBindings()
    }
    
    func addToCurrentString(string: String) {
        if currentPassword.count < 4 {
            currentPassword = string
            if currentPassword.count > 0 {
                currentDotIndex.onNext((currentPassword.count - 1, true))
            }
            if currentPassword.count == 4 {
                pincodeCompleted.onNext(())
            }
            
        }
    }
    
    private func setupBindings() {
        pincodeCompleted
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.user.setPincode(pinCode: strongSelf.currentPassword)
            })
            .disposed(by: bag)
    }
    
    
    
}
