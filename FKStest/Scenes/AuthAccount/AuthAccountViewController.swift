//
//  AuthAccountViewController.swift
//  FKStest
//
//  Created by Студия on 09.10.2020.
//

import UIKit
import Stevia
import RxSwift
import RxCocoa

class AuthAccountViewController: UIViewController {
    
    private let bag = DisposeBag()
    
    var vm: AuthAccountViewModel?
	
	private var imgLogo: UIImageView = {
		let img = UIImageView()
		
		img.image("appleLogo")
        if #available(iOS 13.0, *) {
            img.tintColor = .label
        } else {
            img.tintColor = .black
        }
		
		return img
	}()
	
	private var lblTitle: UILabel = {
		let lbl = UILabel()
		
		lbl.text("Авторизация")
		lbl.font = .boldSystemFont(ofSize: 24)
		
		return lbl
	}()
	
	private var lblSubtitle: UILabel = {
		let lbl = UILabel()
		
		lbl.text("С возвращением! Авторизуйтесь чтобы начать использовать приложение.")
		lbl.font = .systemFont(ofSize: 16, weight: .medium)
		lbl.textColor = .systemGray
		lbl.numberOfLines = 0
		lbl.textAlignment = .center
		
		return lbl
	}()
	
	private var textFieldEmail: UITextField = {
		let textField = UITextField()
		
		textField.placeholder("Email")
		textField.textAlignment = .left
        textField.textContentType = .emailAddress
		
		return textField
	}()
    
    private var lblErrorEmail: UILabel = {
        let lbl = UILabel()
        
        lbl.text("Корректно заполните поле Email")
        lbl.font = .systemFont(ofSize: 12, weight: .medium)
        lbl.textColor = .systemRed
        lbl.numberOfLines = 2
        lbl.textAlignment = .left
        lbl.alpha = 0
        
        return lbl
    }()
	
	private var textFieldPassword: UITextField = {
		let textField = UITextField()
		
		textField.placeholder("Пароль")
		textField.textAlignment = .left
        textField.textContentType = .password
        textField.isSecureTextEntry = true
		
		return textField
	}()
    
    private var lblErrorPassword: UILabel = {
        let lbl = UILabel()
        
        lbl.text("Пароль должен содержать от 8-ми символов")
        lbl.font = .systemFont(ofSize: 12, weight: .medium)
        lbl.textColor = .systemRed
        lbl.numberOfLines = 2
        lbl.textAlignment = .left
        lbl.alpha = 0
        
        return lbl
    }()
	
	private var btnLogin: UIButton = {
		let btn = UIButton()
		
		btn.text("Войти")
		btn.backgroundColor = .systemBlue
		btn.layer.cornerRadius = 15
		
		return btn
	}()
	
	private var lblLogin: UILabel = {
		let lbl = UILabel()
		
		lbl.text("Еще нет аккаунта?")
		lbl.font = .systemFont(ofSize: 14, weight: .regular)
		lbl.textColor = .systemGray
		lbl.textAlignment = .center
		
		return lbl
	}()
	
	private var btnCreateAccount: UIButton = {
		let btn = UIButton()
		
		btn.text("Создать")
		btn.backgroundColor = .clear
		btn.tintColor = .systemBlue
		btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
		btn.setTitleColor(.systemBlue, for: .normal)
		
		return btn
	}()
	
	private var btnForgotPassword: UIButton = {
		let btn = UIButton()
		
		btn.text("Забыли пароль?")
		btn.backgroundColor = .clear
		btn.tintColor = .systemBlue
		btn.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
		btn.setTitleColor(.systemBlue, for: .normal)
		btn.setContentCompressionResistancePriority(.required, for: .horizontal)
		btn.setContentHuggingPriority(.required, for: .horizontal)
		
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
		
		let separator3 = UIView()
        if #available(iOS 13.0, *) {
            separator3.backgroundColor = .placeholderText
        } else {
            separator3.backgroundColor = .gray
        }
		separator3.height(1)
		
		let hStackLogin = UIStackView()
		hStackLogin.axis = .horizontal
		hStackLogin.alignment = .fill
		hStackLogin.spacing = 4
		hStackLogin.addArrangedSubview(lblLogin)
		hStackLogin.addArrangedSubview(btnCreateAccount)
		
		let hStackPassword = UIStackView()
		hStackPassword.axis = .horizontal
		hStackPassword.alignment = .fill
		hStackPassword.spacing = 4
		hStackPassword.addArrangedSubview(textFieldPassword)
		hStackPassword.addArrangedSubview(btnForgotPassword)
		
		let VStack = UIStackView()
		VStack.axis = .vertical
		VStack.alignment = .fill
		VStack.spacing = 24
		VStack.addArrangedSubview(textFieldEmail)
		VStack.addArrangedSubview(separator2)
		VStack.addArrangedSubview(hStackPassword)
		VStack.addArrangedSubview(separator3)
		
		view.sv(imgLogo,
				lblTitle,
				lblSubtitle,
				VStack,
				btnLogin,
				hStackLogin,
                lblErrorEmail,
                lblErrorPassword)
		VStack.left(16).right(16).centerVertically()
		lblSubtitle.left(16).right(16).Bottom == VStack.Top - 32 * UIScreen.main.nativeScale / 2
		lblTitle.centerHorizontally().Bottom == lblSubtitle.Top - 16
		imgLogo.centerHorizontally().height(50).width(40).Bottom == lblTitle.Top - 16
		hStackLogin.centerHorizontally().bottom(16)
        lblErrorEmail.left(16).Top == textFieldEmail.Bottom + 8
        lblErrorPassword.left(16).Top == textFieldPassword.Bottom + 8
		btnLogin.left(16).right(16).height(60).Bottom == hStackLogin.Top - 8
		
		
		self.view = view
	}

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    

    private func setupBindings() {
        
        textFieldEmail.delegate = self
        textFieldPassword.delegate = self
        
        btnLogin.rx.tap
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                guard let email = strongSelf.textFieldEmail.text, strongSelf.vm?.isValidEmail(email) == true else {
                    strongSelf.lblErrorEmail.alpha = 1
                    return
                }
                strongSelf.lblErrorEmail.alpha = 0
                guard let password = strongSelf.textFieldPassword.text, password.count > 7 else {
                    strongSelf.lblErrorPassword.alpha = 1
                    return
                }
                strongSelf.lblErrorPassword.alpha = 0
                strongSelf.vm?.signIn(email, password: password)
            })
            .disposed(by: bag)
        
        btnCreateAccount.rx.tap
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.vm?.goToRegistration.onNext(())
            })
            .disposed(by: bag)
        
        vm?.isSignIn
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] flag in
                guard let strongSelf = self else { return }
                if !flag {
                    strongSelf.showAlert(title: "Введен некорректный email/password!")
                }
                })
            .disposed(by: bag)
    }

}

extension AuthAccountViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.endEditing(true)
        if textField.placeholder == "Email" {
            if let email = textFieldEmail.text, vm?.isValidEmail(email) == true {
                lblErrorEmail.alpha = 0
            } else {
                lblErrorEmail.alpha = 1
            }
        }
        if textField.placeholder == "Пароль" {
            if let password = textFieldPassword.text, password.count > 7 {
                lblErrorPassword.alpha = 0
            } else {
                lblErrorPassword.alpha = 1
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

import SwiftUI
@available(iOS 13.0.0, *)
struct AuthAccountViewController_Previews: PreviewProvider {
  static var previews: some View {
	Group {
		ContainerView().preferredColorScheme(.light).edgesIgnoringSafeArea(.all)
		ContainerView().preferredColorScheme(.dark).edgesIgnoringSafeArea(.all)
		ContainerView().previewDevice("iPhone SE (1st generation)").preferredColorScheme(.light).edgesIgnoringSafeArea(.all)
		ContainerView().previewDevice("iPhone SE (2nd generation)").preferredColorScheme(.light).edgesIgnoringSafeArea(.all)
	}
  }
  
  struct ContainerView: UIViewControllerRepresentable {
	
	
	let tabBarVC = AuthAccountViewController()
	
	func makeUIViewController(context: UIViewControllerRepresentableContext<AuthAccountViewController_Previews.ContainerView>) -> AuthAccountViewController {
	  return tabBarVC
	}
	
	func updateUIViewController(_ uiViewController: AuthAccountViewController_Previews.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<AuthAccountViewController_Previews.ContainerView>) {
	  
	}
  }
}
