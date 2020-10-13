//
//  SecurityCoordinator.swift
//  FKStest
//
//  Created by Администратор on 12.10.2020.
//

import Foundation
import RxSwift
import RxCocoa

class SecurityCoordinator: BaseCoordinator {
    
    private let disposeBag = DisposeBag()
    
    override func start() {
        let securityViewModel = SecurityViewModel()
        let viewController = SecurityViewController()
        viewController.vm = securityViewModel
        viewController.title = "Настройки входа"
        // Coordinator subscribes to events and decides when and how to navigate
        securityViewModel.goToChangePincode
            .subscribe(onNext: {[weak self] in
                self?.openChangePincode()
            })
            .disposed(by: self.disposeBag)
        
        securityViewModel.goBack
            .subscribe(onNext: {[weak self] in
                guard let strongSelf = self else { return }
                strongSelf.navigationController.popViewController(animated: true)
            })
            .disposed(by: self.disposeBag)
        
        self.navigationController.navigationBar.isHidden = false
        self.navigationController.pushViewController(viewController,animated: true)
    }
    
    func openChangePincode() {
        self.navigationController.navigationBar.isHidden = true
        
        // TODO: here you could check if user is signed in and show appropriate screen
        let coordinator = CreateChangePincodeCoordinator()
        coordinator.navigationController = self.navigationController
        self.start(coordinator: coordinator)
    }
}
