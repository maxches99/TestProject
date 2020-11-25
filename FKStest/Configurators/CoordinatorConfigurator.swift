//
//  CoordinatorConfigurator.swift
//  FKStest
//
//  Created by Администратор on 12.10.2020.
//

import UIKit
import RxSwift
import RxCocoa

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var parentCoordinator: Coordinator? { get set }
    
    func start()
    func start(coordinator: Coordinator)
    func didFinish(coordinator: Coordinator)
}

class BaseCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    var navigationController = UINavigationController()
    
    func start() {
        fatalError("Start method must be implemented")
    }
    
    func start(coordinator: Coordinator) {
        self.childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    func didFinish(coordinator: Coordinator) {
        if let index = self.childCoordinators.firstIndex(where: { $0 === coordinator }) {
            self.childCoordinators.remove(at: index)
        }
    }
}

class AppCoordinator: BaseCoordinator {
    
    var window = UIWindow(frame: UIScreen.main.bounds)
    var isLogout = false
    
    init(navC: UINavigationController) {
        super.init()
        
        navigationController = navC
    }
    
    override func start() {
        self.navigationController.navigationBar.isHidden = true
        self.childCoordinators.removeAll()
        self.window.rootViewController = self.navigationController
        self.window.makeKeyAndVisible()
        
        let user = UserConfigurator.shared
        user.refresh()
		if !user.pincode.isEmpty {
            if !isLogout {
                openPincode()
            } else {
                openRegistration()
            }
        } else {
            openRegistration()
        }
    }
    
    private func openRegistration() {
        isLogout = false
        let coordinator = RegistrationCoordinator()
        coordinator.navigationController = self.navigationController
        self.start(coordinator: coordinator)
    }
    
    private func openPincode() {
        isLogout = false
        let coordinator = LoginWithPinCodeCoordinator()
        coordinator.navigationController = self.navigationController
        self.start(coordinator: coordinator)
    }
}
