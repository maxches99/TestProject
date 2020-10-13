//
//  LoginWithPinCode.swift
//  FKStest
//
//  Created by Администратор on 12.10.2020.
//

import UIKit
import RxSwift
import RxCocoa

class LoginWithPinCodeCoordinator: BaseCoordinator {
    
    private let disposeBag = DisposeBag()
    
    override func start() {
        let loginWithPinCodeViewModel = LoginWithPinCodeViewModel()
        let viewController = LoginWithPinCodeViewController(viewModel: loginWithPinCodeViewModel)
        
        // Coordinator subscribes to events and decides when and how to navigate
        loginWithPinCodeViewModel.goToNextScreen
            .take(1)
            .subscribe(onNext: {[weak self] in
                // Navigate to dashboard
                guard let strongSelf = self else { return }
                strongSelf.openProfile()
                strongSelf.parentCoordinator?.didFinish(coordinator: strongSelf)
                
            })
            .disposed(by: self.disposeBag)
        
        loginWithPinCodeViewModel.logOut
            .subscribe(onNext: {[weak self] in
                // Navigate to dashboard
                self?.logOut()
            })
            .disposed(by: self.disposeBag)
        
        self.navigationController.viewControllers = [viewController]
    }
    
    func openProfile() {
        self.navigationController.navigationBar.isHidden = true
        
        // TODO: here you could check if user is signed in and show appropriate screen
        let coordinator = ProfileCoordinator()
        coordinator.navigationController = self.navigationController
        self.start(coordinator: coordinator)
    }
    
    func logOut() {
        self.navigationController.navigationBar.isHidden = true
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                parentCoordinator?.didFinish(coordinator: self)
                sd.appCoordinator.isLogout = true
                sd.appCoordinator.start()
            }
        } else {
            parentCoordinator?.didFinish(coordinator: self)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.appCoordinator.isLogout = true
            appDelegate.appCoordinator.start()
        }
    }
    
}

