//
//  ProfileCoordinator.swift
//  FKStest
//
//  Created by Администратор on 12.10.2020.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileCoordinator: BaseCoordinator {
    
    private let disposeBag = DisposeBag()
    
    override func start() {
        let profileViewModel = ProfileViewModel()
        let viewController = ProfileViewController()
        viewController.vm = profileViewModel
        viewController.title = "Профиль"
        
        profileViewModel.goToSecurityScreen
            .subscribe(onNext: {[weak self] in
                // Navigate to dashboard
                guard let strongSelf = self else { return }
                strongSelf.openSecurity()
            })
            .disposed(by: self.disposeBag)
        
        profileViewModel.logOut
            .subscribe(onNext: {[weak self] in
                // Navigate to dashboard
                self?.logOut()
            })
            .disposed(by: self.disposeBag)

        self.navigationController.navigationBar.isHidden = false
        
        self.navigationController.pushViewController(viewController, animated: true)
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
    
    func openSecurity() {
        self.navigationController.navigationBar.isHidden = true
        
        let coordinator = SecurityCoordinator()
        coordinator.navigationController = self.navigationController
        self.start(coordinator: coordinator)
    }
}

