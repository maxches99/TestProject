//
//  RegistrationViewController.swift
//  FKStest
//
//  Created by Студия on 09.10.2020.
//

import UIKit
import Stevia
import RxSwift
import RxCocoa

class RegistrationViewController: UIViewController {
	
	private var imgLogo: UIImageView = {
		let img = UIImageView()
		
		img.image("appleLogo")
		img.tintColor = .label
		
		return img
	}()
	
	private var lblTitle: UILabel = {
		let lbl = UILabel()
		
		lbl.text("Регистрация")
		lbl.font = .boldSystemFont(ofSize: 24)
		
		return lbl
	}()
	
	private var lblSubtitle: UILabel = {
		let lbl = UILabel()
		
		lbl.text("Начните пользоваться всеми возможностями сервиса уже сейчас")
		lbl.font = .systemFont(ofSize: 16, weight: .medium)
		lbl.textColor = .systemGray
		lbl.numberOfLines = 2
		lbl.textAlignment = .center
		
		return lbl
	}()
	
	private var textFieldName: UITextField = {
		let textField = UITextField()
		
		textField.placeholder("Имя")
		textField.textAlignment = .left
		
		return textField
	}()
	
	private var textFieldEmail: UITextField = {
		let textField = UITextField()
		
		textField.placeholder("Email")
		textField.textAlignment = .left
		
		return textField
	}()
	
	private var textFieldPassword: UITextField = {
		let textField = UITextField()
		
		textField.placeholder("Пароль")
		textField.textAlignment = .left
		
		return textField
	}()
	
	private var btnCreateAccount: UIButton = {
		let btn = UIButton()
		
		btn.text("Создать аккаунт")
		btn.backgroundColor = .systemBlue
		btn.layer.cornerRadius = 15
		
		return btn
	}()
	
	private var lblLogin: UILabel = {
		let lbl = UILabel()
		
		lbl.text("Уже есть аккаунт?")
		lbl.font = .systemFont(ofSize: 14, weight: .regular)
		lbl.textColor = .systemGray
		lbl.textAlignment = .center
		
		return lbl
	}()
	
	private var btnLogin: UIButton = {
		let btn = UIButton()
		
		btn.text("Войти")
		btn.backgroundColor = .clear
		btn.tintColor = .systemBlue
		btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
		btn.setTitleColor(.systemBlue, for: .normal)
		
		return btn
	}()
	
	override func loadView() {
		let view = UIView()
		
		let separator1 = UIView()
		separator1.backgroundColor = .placeholderText
		separator1.height(1)
		
		let separator2 = UIView()
		separator2.backgroundColor = .placeholderText
		separator2.height(1)
		
		let separator3 = UIView()
		separator3.backgroundColor = .placeholderText
		separator3.height(1)
		
		let hStackLogin = UIStackView()
		hStackLogin.axis = .horizontal
		hStackLogin.alignment = .fill
		hStackLogin.spacing = 4
		hStackLogin.addArrangedSubview(lblLogin)
		hStackLogin.addArrangedSubview(btnLogin)
		
		let VStack = UIStackView()
		VStack.axis = .vertical
		VStack.alignment = .fill
		VStack.spacing = 24
		VStack.addArrangedSubview(textFieldName)
		VStack.addArrangedSubview(separator1)
		VStack.addArrangedSubview(textFieldEmail)
		VStack.addArrangedSubview(separator2)
		VStack.addArrangedSubview(textFieldPassword)
		VStack.addArrangedSubview(separator3)
		
		
		
		view.sv(imgLogo,
				lblTitle,
				lblSubtitle,
				VStack,
				btnCreateAccount,
				hStackLogin)
		VStack.left(16).right(16).centerVertically()
		lblSubtitle.left(16).right(16).Bottom == VStack.Top - 32 * UIScreen.main.nativeScale / 2
		lblTitle.centerHorizontally().Bottom == lblSubtitle.Top - 16
		imgLogo.centerHorizontally().height(50).width(40).Bottom == lblTitle.Top - 16
		hStackLogin.centerHorizontally().bottom(16)
		btnCreateAccount.left(16).right(16).height(60).Bottom == hStackLogin.Top - 8
		
		
		self.view = view
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

import SwiftUI
@available(iOS 13.0.0, *)
struct RegistrationViewController_Previews: PreviewProvider {
  static var previews: some View {
	ContainerView().preferredColorScheme(.light).edgesIgnoringSafeArea(.all)
  }
  
  struct ContainerView: UIViewControllerRepresentable {
	
	
	let tabBarVC = RegistrationViewController()
	
	func makeUIViewController(context: UIViewControllerRepresentableContext<RegistrationViewController_Previews.ContainerView>) -> RegistrationViewController {
	  return tabBarVC
	}
	
	func updateUIViewController(_ uiViewController: RegistrationViewController_Previews.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<RegistrationViewController_Previews.ContainerView>) {
	  
	}
  }
}
