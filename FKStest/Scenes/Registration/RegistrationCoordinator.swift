//
//  RegistrationCoordinator.swift
//  FKStest
//
//  Created by Администратор on 12.10.2020.
//

import UIKit
import RxSwift
import RxCocoa
import CoreData

class RegistrationCoordinator: BaseCoordinator {
    
    private let disposeBag = DisposeBag()
    
    override func start() {
        self.navigationController.viewControllers.removeAll()
        let registrationViewController = RegistrationViewController()
        let registrationViewModel = RegistrationViewModel()
        registrationViewController.vm = registrationViewModel
        registrationViewController.hidesBottomBarWhenPushed = true
		
        
        // Coordinator subscribes to events and decides when and how to navigate
        registrationViewModel.isSignIn
            .subscribe(onNext: {[weak self] isSign in
                // Navigate to dashboard
                guard let strongSelf = self else { return }
                if isSign {
                    strongSelf.openCreatePincode()
                    strongSelf.parentCoordinator?.didFinish(coordinator: strongSelf)
                }
                
            })
            .disposed(by: self.disposeBag)
        
        registrationViewModel.goToAuth
            .subscribe(onNext: {[weak self] in
                // Navigate to dashboard
                guard let strongSelf = self else { return }
                strongSelf.openAuthAccount()
            })
            .disposed(by: self.disposeBag)
        
        navigationController.viewControllers = [registrationViewController]
    }
    
    func openAuthAccount() {
        self.navigationController.navigationBar.isHidden = true
        
        // TODO: here you could check if user is signed in and show appropriate screen
        let coordinator = AuthAccountCoordinator()
        coordinator.navigationController = self.navigationController
        self.start(coordinator: coordinator)
    }
    
    func openCreatePincode() {
        self.navigationController.navigationBar.isHidden = true
        
        // TODO: here you could check if user is signed in and show appropriate screen
        let coordinator = CreateChangePincodeCoordinator()
        coordinator.navigationController = self.navigationController
        self.start(coordinator: coordinator)
    }
}
