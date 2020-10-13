//
//  CreateChangePincodeCoordinator.swift
//  FKStest
//
//  Created by Администратор on 12.10.2020.
//

import Foundation
import RxSwift
import RxCocoa

class CreateChangePincodeCoordinator: BaseCoordinator {
    
    private let disposeBag = DisposeBag()
    
    override func start() {
        let pincodeViewModel = CreateChangePincodeViewModel()
        let viewController = CreateChangePincodeViewController()
        viewController.vm = pincodeViewModel
        // Coordinator subscribes to events and decides when and how to navigate
        pincodeViewModel.goToNextScreen
            .take(1)
            .subscribe(onNext: {[weak self] isSign in
                // Navigate to dashboard
                guard let strongSelf = self else { return }
                strongSelf.openProfile()
                strongSelf.parentCoordinator?.didFinish(coordinator: strongSelf)
            })
            .disposed(by: self.disposeBag)
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func openProfile() {
        self.navigationController.navigationBar.isHidden = true
        
        // TODO: here you could check if user is signed in and show appropriate screen
        let coordinator = ProfileCoordinator()
        coordinator.navigationController = self.navigationController
        self.start(coordinator: coordinator)
    }
}
