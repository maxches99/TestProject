//
//  AuthAccountCoordinator.swift
//  FKStest
//
//  Created by Администратор on 12.10.2020.
//

import UIKit
import RxSwift
import RxCocoa

class AuthAccountCoordinator: BaseCoordinator {
    
    private let disposeBag = DisposeBag()
    
    override func start() {
        let authAccountViewModel = AuthAccountViewModel()
        let viewController = AuthAccountViewController()
        viewController.vm = authAccountViewModel
        
        authAccountViewModel.isSignIn
            .subscribe(onNext: {[weak self] isSign in
                guard let strongSelf = self else { return }
                if isSign {
                    strongSelf.openCreatePincode()
                    strongSelf.parentCoordinator?.didFinish(coordinator: strongSelf)
                }
            })
            .disposed(by: self.disposeBag)
        
        authAccountViewModel.goToRegistration
            .subscribe(onNext: {[weak self] in
                guard let strongSelf = self else { return }
                strongSelf.navigationController.popToRootViewController(animated: true)
                strongSelf.parentCoordinator?.didFinish(coordinator: strongSelf)
            })
            .disposed(by: self.disposeBag)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func openCreatePincode() {
        self.navigationController.navigationBar.isHidden = true
        
        // TODO: here you could check if user is signed in and show appropriate screen
        let coordinator = CreateChangePincodeCoordinator()
        coordinator.navigationController = self.navigationController
        self.start(coordinator: coordinator)
    }
}
