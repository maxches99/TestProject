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
	
	private var imgLogo: UIImageView = {
		let img = UIImageView()
		
		img.image("appleLogo")
		img.tintColor = .label
		
		return img
	}()
	
	private var lblName: UILabel = {
		let lbl = UILabel()
		
		lbl.text("Максим Чесников")
		lbl.font = .systemFont(ofSize: 20, weight: .medium)
		lbl.textColor = .label
		lbl.numberOfLines = 2
		lbl.textAlignment = .center
		
		return lbl
	}()
	
	private var lblEmail: UILabel = {
		let lbl = UILabel()
		
		lbl.text("maxches99@icloud.com")
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
		
		let separator1 = UIView()
		separator1.backgroundColor = .placeholderText
		separator1.height(1)
		
		let separator2 = UIView()
		separator2.backgroundColor = .placeholderText
		separator2.height(1)
		
		
		
		view.sv(imgLogo,
				lblName,
				lblEmail,
				separator2,
				btnAuthChange,
				btnLogout)
		imgLogo.centerHorizontally().height(50).width(40).top(32 * UIScreen.main.nativeScale)
		lblName.left(16).right(16).Top == imgLogo.Bottom + 16 * UIScreen.main.nativeScale / 2
		lblEmail.left(16).right(16).Top == lblName.Bottom + 8 * UIScreen.main.nativeScale / 2
		separator2.left(48).right(48).Top == lblEmail.Bottom + 8 * UIScreen.main.nativeScale / 2
		btnAuthChange.left(48).Top == separator2.Bottom + 8 * UIScreen.main.nativeScale / 2
		btnLogout.left(48).Top == btnAuthChange.Bottom + 8 * UIScreen.main.nativeScale / 2
		
		
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
struct ProfileViewController_Previews: PreviewProvider {
  static var previews: some View {
	Group {
		ContainerView().preferredColorScheme(.light).edgesIgnoringSafeArea(.all)
		ContainerView().previewDevice("iPhone SE (1st generation)").preferredColorScheme(.light).edgesIgnoringSafeArea(.all)
	}
  }
  
  struct ContainerView: UIViewControllerRepresentable {
	
	
	let tabBarVC = ProfileViewController()
	
	func makeUIViewController(context: UIViewControllerRepresentableContext<ProfileViewController_Previews.ContainerView>) -> ProfileViewController {
	  return tabBarVC
	}
	
	func updateUIViewController(_ uiViewController: ProfileViewController_Previews.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ProfileViewController_Previews.ContainerView>) {
	  
	}
  }
}
