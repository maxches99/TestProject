//
//  SecurityViewController.swift
//  FKStest
//
//  Created by Администратор on 11.10.2020.
//

import UIKit
import Stevia
import RxSwift
import RxCocoa

class SecurityViewController: UIViewController {
    
    var vm: SecurityViewModel?
    
    private let bag = DisposeBag()
    
    private var lblTouchID: UILabel = {
        let lbl = UILabel()
        
        lbl.text("TouchID")
        lbl.font = .systemFont(ofSize: 20, weight: .medium)
        if #available(iOS 13.0, *) {
            lbl.textColor = .label
        } else {
            lbl.textColor = .black
        }
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        
        return lbl
    }()
    
    private var lblFaceID: UILabel = {
        let lbl = UILabel()
        
        lbl.text("FaceID")
        lbl.font = .systemFont(ofSize: 20, weight: .medium)
        if #available(iOS 13.0, *) {
            lbl.textColor = .label
        } else {
            lbl.textColor = .black
        }
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        
        return lbl
    }()
    
    private var lblSubTouchID: UILabel = {
        let lbl = UILabel()
        
        lbl.text("Разрешить или запретить авторизацию по TouchID")
        lbl.font = .systemFont(ofSize: 14, weight: .medium)
        lbl.textColor = .systemGray
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        
        return lbl
    }()
    
    private var lblSubFaceID: UILabel = {
        let lbl = UILabel()
        
        lbl.text("Разрешить или запретить авторизацию по FaceID")
        lbl.font = .systemFont(ofSize: 20, weight: .medium)
        lbl.font = .systemFont(ofSize: 14, weight: .medium)
        lbl.textColor = .systemGray
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        
        return lbl
    }()
    
    private var btnChangePincode: UIButton = {
        let btn = UIButton()

        btn.text("Задать/сменить пинкод")
        btn.backgroundColor = .clear
        btn.tintColor = .systemBlue
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        btn.setTitleColor(.systemBlue, for: .normal)
        
        return btn
    }()
    
    private lazy var switchTouchID: UISwitch = {
        let swtch = UISwitch()

        swtch.isOn = vm?.isTouchID ?? false
        
        return swtch
    }()
    
    private lazy var switchFaceID: UISwitch = {
        let swtch = UISwitch()

        swtch.isOn = vm?.isFaceID ?? false
        
        return swtch
    }()
    
    override func loadView() {
        let view = UIView()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        let separator1 = UIView()
        if #available(iOS 13.0, *) {
            separator1.backgroundColor = .placeholderText
        } else {
            separator1.backgroundColor = .gray
        }
        separator1.height(1)
        
        let separator2 = UIView()
        if #available(iOS 13.0, *) {
            separator2.backgroundColor = .placeholderText
        } else {
            separator2.backgroundColor = .gray
        }
        separator2.height(1)
        
        view.sv(
            lblTouchID,
            lblFaceID,
            lblSubFaceID,
            lblSubTouchID,
            btnChangePincode,
            switchFaceID,
            switchTouchID,
            separator1,
            separator2)
        
        lblTouchID.left(16).top(32 + topbarHeight)
        separator1.left(16).right(16).Top == lblTouchID.Bottom + 8
        switchTouchID.right(16).Bottom == lblTouchID.Bottom
        lblSubTouchID.left(16).right(16).Top == separator1.Bottom + 8
        
        lblFaceID.left(16).Top == lblSubTouchID.Bottom + 32
        separator2.left(16).right(16).Top == lblFaceID.Bottom + 8
        switchFaceID.right(16).Bottom == lblFaceID.Bottom
        lblSubFaceID.left(16).right(16).Top == separator2.Bottom + 8
        
        btnChangePincode.left(16).Top == lblSubFaceID.Bottom + 16
        
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.hidesBackButton = true
        let newBackButton: UIBarButtonItem
        if #available(iOS 14.0, *) {
            newBackButton = UIBarButtonItem(title: "Назад")
        } else {
            newBackButton = UIBarButtonItem()
            newBackButton.title = "Назад"
        }
        newBackButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] in
                self?.vm?.goBack.onNext(())
            })
            .disposed(by: bag)
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    private func setupBindings() {
        switchFaceID.rx.isOn
            .asDriver()
            .drive(onNext: {[weak self] isOn in
                self?.vm?.toggleFaceID.onNext(())
                self?.switchFaceID.isOn = self?.vm?.isFaceID ?? false
            })
            .disposed(by: bag)
        
        switchTouchID.rx.isOn
            .asDriver()
            .drive(onNext: {[weak self] isOn in
                self?.vm?.toggleTouchID.onNext(())
                self?.switchTouchID.isOn = self?.vm?.isTouchID ?? false
            })
            .disposed(by: bag)
        
        btnChangePincode.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] in
                self?.vm?.goToChangePincode.onNext(())
            })
            .disposed(by: bag)
        
    }

}

import SwiftUI
@available(iOS 13.0.0, *)
struct SecurityViewController_Previews: PreviewProvider {
  static var previews: some View {
    Group {
        ContainerView().preferredColorScheme(.light).edgesIgnoringSafeArea(.all)
    }
  }
  
  struct ContainerView: UIViewControllerRepresentable {
    
    
    let tabBarVC = SecurityViewController()
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SecurityViewController_Previews.ContainerView>) -> SecurityViewController {
      return tabBarVC
    }
    
    func updateUIViewController(_ uiViewController: SecurityViewController_Previews.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<SecurityViewController_Previews.ContainerView>) {
      
    }
  }
}
