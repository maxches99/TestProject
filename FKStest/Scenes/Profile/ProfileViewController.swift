//
//  ProfileViewController.swift
//  FKStest
//
//  Created by Студия on 09.10.2020.
//


import UIKit
import Stevia
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController {
    
    var vm: ProfileViewModel?
    
    private let bag = DisposeBag()
	
	private lazy var imgLogo: UIImageView = {
		let img = UIImageView()
		
		img.image("avatar")
        if #available(iOS 13.0, *) {
            img.tintColor = .label
        } else {
            img.tintColor = .black
        }
        img.contentMode = .center
        img.layer.masksToBounds = true
		return img
	}()
	
	private lazy var lblName: UILabel = {
		let lbl = UILabel()
		
        lbl.text(vm?.name ?? "")
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
	
	private lazy var lblEmail: UILabel = {
		let lbl = UILabel()
		
        lbl.text(vm?.email ?? "")
		lbl.font = .systemFont(ofSize: 16, weight: .medium)
		lbl.textColor = .systemGray
		lbl.numberOfLines = 2
		lbl.textAlignment = .center
		
		return lbl
	}()
	
	private var btnAuthChange: UIButton = {
		let btn = UIButton()
		
		btn.text("Способы авторизации")
		btn.backgroundColor = .clear
		btn.tintColor = .systemBlue
		btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
		btn.setTitleColor(.systemBlue, for: .normal)
		
		return btn
	}()
	
	private var btnPhotoChange: UIButton = {
		let btn = UIButton()
		
		btn.text("Сменить фото профиля")
		btn.backgroundColor = .clear
		btn.tintColor = .systemBlue
		btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
		btn.setTitleColor(.systemBlue, for: .normal)
		
		return btn
	}()
	
	private var btnLogout: UIButton = {
		let btn = UIButton()
		
		btn.text("Выйти")
		btn.backgroundColor = .clear
		btn.tintColor = .systemRed
		btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
		btn.setTitleColor(.systemRed, for: .normal)
		
		return btn
	}()
    
	override func loadView() {
		let view = UIView()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = . white
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
		
		view.sv(imgLogo,
				lblName,
				lblEmail,
				separator2,
				btnPhotoChange,
				btnAuthChange,
				btnLogout)
        imgLogo.centerHorizontally().size(100).top(32 + topbarHeight)
		lblName.left(16).right(16).Top == imgLogo.Bottom + 16 * UIScreen.main.nativeScale / 2
		lblEmail.left(16).right(16).Top == lblName.Bottom + 8 * UIScreen.main.nativeScale / 2
		separator2.left(48).right(48).Top == lblEmail.Bottom + 8 * UIScreen.main.nativeScale / 2
		btnPhotoChange.left(48).Top == separator2.Bottom + 8 * UIScreen.main.nativeScale / 2
		btnAuthChange.left(48).Top == btnPhotoChange.Bottom + 8 * UIScreen.main.nativeScale / 2
		btnLogout.left(48).Top == btnAuthChange.Bottom + 8 * UIScreen.main.nativeScale / 2
        
        imgLogo.layer.cornerRadius = 50
        imgLogo.clipsToBounds = true
		
		
		self.view = view
	}

	override func viewDidLoad() {
		super.viewDidLoad()
        
        setupBindings()

	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItems = []
        self.navigationItem.hidesBackButton = true
    }
    
    private func setupBindings() {
        
        lblName.text(vm?.name ?? "")
        lblEmail.text(vm?.email ?? "")
		
		btnPhotoChange.rx.tap
			.asDriver()
			.drive(onNext: { [weak self] in
				self?.vm?.changePhoto.onNext(())
			})
			.disposed(by: bag)
        
        btnAuthChange.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.vm?.goToSecurityScreen.onNext(())
            })
            .disposed(by: bag)
        
        btnLogout.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.vm?.logout()
            })
            .disposed(by: bag)
        
    }
    

}

import SwiftUI
@available(iOS 13.0.0, *)
struct ProfileViewController_Previews: PreviewProvider {
  static var previews: some View {
	Group {
		ContainerView().preferredColorScheme(.light).edgesIgnoringSafeArea(.all)
	}
  }
  
  struct ContainerView: UIViewControllerRepresentable {
	
	func makeUIViewController(context: UIViewControllerRepresentableContext<ProfileViewController_Previews.ContainerView>) -> ProfileViewController {
        let vm = ProfileViewModel()
        
        let tabBarVC = ProfileViewController()
        tabBarVC.vm = vm
        
	  return tabBarVC
	}
	
	func updateUIViewController(_ uiViewController: ProfileViewController_Previews.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ProfileViewController_Previews.ContainerView>) {
	  
	}
  }
}
