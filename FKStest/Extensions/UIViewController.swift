//
//  UIViewController.swift
//  FKStest
//
//  Created by Администратор on 13.10.2020.
//

import UIKit

extension UIViewController {
    
    var topbarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    func showAlert(title: String? = nil, message: String? = nil, buttonName: String? = nil, handler: (() -> Void)? = nil) {
        performInMainThread { [weak self] in
            guard let strongSelf = self else { return }
            
            let alert = UIAlertController(title: title ?? "", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: buttonName ?? "Oк", style: .default, handler: { _ in handler?() })
            alert.addAction(okAction)
            strongSelf.present(alert, animated: true, completion: nil)
        }
    }
}
