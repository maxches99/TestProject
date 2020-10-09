//
//  ViewController.swift
//  FKStest
//
//  Created by Студия on 07.10.2020.
//

import UIKit
import Stevia
import RxSwift
import RxCocoa

class LoginWithPinCodeViewController: UIViewController {
	
	let sizeOfButton = CGFloat(80)
	let vm = LoginWithPinCodeViewModel(accessTypesOfBiometry: [.faceID])
	
	private let bag = DisposeBag()
	
	private lazy var lblNameAccount: UILabel = {
		let lbl = UILabel()
		
		lbl.text("Максим Чесников")
		lbl.font = .systemFont(ofSize: 14, weight: .medium)
		
		return lbl
	}()
	
	private lazy var lblNameAccountSubTitle: UILabel = {
		let lbl = UILabel()
		
		lbl.text("2 часа назад")
		lbl.font = .systemFont(ofSize: 12, weight: .regular)
		lbl.textColor = .systemGray
		
		return lbl
	}()
	
	private lazy var imgAccount: UIImageView = {
		let img = UIImageView()
		
		img.image("appleLogo")
		img.tintColor = .label
		img.setContentHuggingPriority(.required, for: .horizontal)
		
		return img
	}()
	
	private var btnLogout: UIButton = {
		let btn = UIButton()
		
		btn.text("Выйти")
		btn.backgroundColor = .clear
		btn.tintColor = .systemBlue
		btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
		btn.setTitleColor(.systemBlue, for: .normal)
		
		return btn
	}()
	
	private lazy var lblPassword: UILabel = {
		let lbl = UILabel()
		
		lbl.text("Введите пароль")
		
		return lbl
	}()

	private lazy var btnAuth: UIButton = {
		let btn = UIButton()
		
		btn.layer.cornerRadius = sizeOfButton / 2
		
		switch vm.typeOfLA {
			case .faceID:
				btn.setImage(UIImage(named: "faceId_icon"), for: .normal)
				btn.imageView?.tintColor = .systemGray4
				btn.imageView?.size(sizeOfButton * 0.8)
			case .touchID:
				btn.setImage(UIImage(named: "touchId_icon"), for: .normal)
				btn.imageView?.tintColor = .systemGray4
				btn.imageView?.size(sizeOfButton * 0.8)
			case .none:
				btn.isEnabled = false
				btn.backgroundColor = .clear
		}
		
		return btn
	}()
	
	private lazy var dots: [UIView] = {
		var arrDots: [UIView] = []
		
		for _ in 0..<5 {
			let dot = UIView()
			dot.backgroundColor = .systemGray4
			dot.size(10)
			dot.layer.cornerRadius = 5
			arrDots.append(dot)
		}
		
		return arrDots
	}()
	
	private lazy var btns: [UIButton] = {
		
		let arr = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
		
		var arrBtns: [UIButton] = []
		
		arr.map { str in
			let btn = UIButton()
			btn.text(str)
			btn.titleLabel?.font = .systemFont(ofSize: 36)
			btn.titleLabel?.tintColor = .label
			btn.titleLabel?.textColor = .label
			btn.backgroundColor = .systemGray4
			btn.layer.cornerRadius = sizeOfButton / 2
			btn.size(sizeOfButton)
			
			btn.tag = Int(str) ?? 0
			arrBtns.append(btn)
			return
		}
		
		return arrBtns
	}()
	
	private lazy var btnDelete: UIButton = {
		let btn = UIButton()
		
		btn.layer.cornerRadius = sizeOfButton / 2
		btn.setImage(UIImage(named: "delete"), for: .normal)
		btn.imageView?.tintColor = .systemGray4
		btn.imageView?.size(sizeOfButton * 0.8)
		
		return btn
	}()
	
	override func loadView() {
		let view = UIView()
		
		view.backgroundColor = .systemBackground
		
		let vStackAccount = UIStackView()
		vStackAccount.axis = .vertical
		vStackAccount.spacing = 4
		vStackAccount.addArrangedSubview(lblNameAccount)
		vStackAccount.addArrangedSubview(lblNameAccountSubTitle)
		
		let hStackAccount = UIView()
		hStackAccount.sv(imgAccount, vStackAccount, btnLogout)
		hStackAccount.layout(
			|imgAccount.height(30).width(20)-16-vStackAccount-(>=16)-btnLogout|
		)
		
		let hStack1 = UIStackView()
		hStack1.axis = .horizontal
		hStack1.spacing = 16
		hStack1.addArrangedSubview(btns[0])
		hStack1.addArrangedSubview(btns[1])
		hStack1.addArrangedSubview(btns[2])
		
		let hStack2 = UIStackView()
		hStack2.axis = .horizontal
		hStack2.spacing = 16
		hStack2.addArrangedSubview(btns[3])
		hStack2.addArrangedSubview(btns[4])
		hStack2.addArrangedSubview(btns[5])
		
		let hStack3 = UIStackView()
		hStack3.axis = .horizontal
		hStack3.spacing = 16
		hStack3.addArrangedSubview(btns[6])
		hStack3.addArrangedSubview(btns[7])
		hStack3.addArrangedSubview(btns[8])
		
		let hStack4 = UIStackView()
		hStack4.axis = .horizontal
		hStack4.spacing = 16
		hStack4.addArrangedSubview(btnAuth.size(sizeOfButton))
		hStack4.addArrangedSubview(btns[9])
		hStack4.addArrangedSubview(btnDelete.size(sizeOfButton))
		
		let vStack = UIStackView()
		vStack.axis = .vertical
		vStack.spacing = 16
		vStack.addArrangedSubview(hStack1)
		vStack.addArrangedSubview(hStack2)
		vStack.addArrangedSubview(hStack3)
		vStack.addArrangedSubview(hStack4)
		
		let hStackDots = UIStackView()
		hStackDots.axis = .horizontal
		hStackDots.spacing = 16
		for dot in dots {
			hStackDots.addArrangedSubview(dot)
		}
		
		view.sv(hStackAccount, vStack, lblPassword, hStackDots)
		if UIDevice.current.screenType == .iPhones_4_4S || UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
			hStackAccount.left(16).right(16).bottom(50)
		} else {
			hStackAccount.left(16).right(16).top(50)
		}
		vStack.centerVertically().centerHorizontally()
		hStackDots.centerHorizontally().Bottom == vStack.Top - 32
		lblPassword.centerHorizontally().Bottom == hStackDots.Top - 16
		
		
		self.view = view
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupBindings()
	}
	
	private func setupBindings() {
		vm.loggedIn
			.asDriver(onErrorJustReturn: (false, false))
			.drive(onNext: { [weak self] flag, isBiometry in
				guard let strongSelf = self else { return }
				if !flag && !isBiometry {
					strongSelf.showAlert(message: "Введен некорректный пинкод!")
				} else if flag {
					strongSelf.dots.map { dot in
						dot.backgroundColor = .systemBlue
						UIView.animate(withDuration: 0.5, animations: { [weak self] in
							dot.transform = CGAffineTransform(scaleX: 2, y: 2)
						}, completion: {_ in
							UIView.animate(withDuration: 0.5, animations: { [weak self] in
								dot.transform = CGAffineTransform.identity
							})
						})
					}
				}
				})
			.disposed(by: bag)
		
		vm.currentDotIndex
			.asDriver(onErrorJustReturn: (0, false))
			.drive(onNext: { [weak self] index, isChoose in
				UIView.animate(withDuration: 0.3, animations: { [weak self] in
					self?.dots[index].backgroundColor = isChoose ? .systemBlue : .systemGray4
				})
				})
			.disposed(by: bag)
		
		btns.map { button in
			button.rx.tap
				.subscribe(onNext: { [weak self] in
					guard let strongSelf = self else { return }
					strongSelf.vm.addToCurrentString(string: String(button.tag))
				})
				.disposed(by: bag)
		}
		
		btnAuth.rx.tap
			.subscribe(onNext: { [weak self] in
				guard let strongSelf = self else { return }
				strongSelf.vm.auth()
			})
			.disposed(by: bag)
		
		btnDelete.rx.tap
			.subscribe(onNext: { [weak self] in
				guard let strongSelf = self else { return }
				strongSelf.vm.deleteCharacterInToCurrentString()
			})
			.disposed(by: bag)
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


import SwiftUI
@available(iOS 13.0.0, *)
struct ViewController_Previews: PreviewProvider {
  static var previews: some View {
	Group {
		ContainerView().preferredColorScheme(.light).edgesIgnoringSafeArea(.all)
		ContainerView().previewDevice("iPhone SE (1st generation)").preferredColorScheme(.light).edgesIgnoringSafeArea(.all)
	}
  }
  
  struct ContainerView: UIViewControllerRepresentable {
	
	
	let tabBarVC = LoginWithPinCodeViewController()
	
	func makeUIViewController(context: UIViewControllerRepresentableContext<ViewController_Previews.ContainerView>) -> LoginWithPinCodeViewController {
	  return tabBarVC
	}
	
	func updateUIViewController(_ uiViewController: ViewController_Previews.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ViewController_Previews.ContainerView>) {
	  
	}
  }
}

func performInMainThread(block: @escaping () -> ()) {
	if Thread.isMainThread {
		block()
	} else {
		DispatchQueue.main.async {
			block()
		}
	}
}
extension UIDevice {
	var iPhoneX: Bool { UIScreen.main.nativeBounds.height == 2436 }
	var iPhone: Bool { UIDevice.current.userInterfaceIdiom == .phone }
	var iPad: Bool { UIDevice().userInterfaceIdiom == .pad }
	enum ScreenType: String {
		case iPhones_4_4S = "iPhone 4 or iPhone 4S"
		case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
		case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
		case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
		case iPhones_X_XS = "iPhone X or iPhone XS"
		case iPhone_XR_11 = "iPhone XR or iPhone 11"
		case iPhone_XSMax_ProMax = "iPhone XS Max or iPhone Pro Max"
		case iPhone_11Pro = "iPhone 11 Pro"
		case unknown
	}
	var screenType: ScreenType {
		switch UIScreen.main.nativeBounds.height {
		case 1136:
			return .iPhones_5_5s_5c_SE
		case 1334:
			return .iPhones_6_6s_7_8
		case 1792:
			return .iPhone_XR_11
		case 1920, 2208:
			return .iPhones_6Plus_6sPlus_7Plus_8Plus
		case 2426:
			return .iPhone_11Pro
		case 2436:
			return .iPhones_X_XS
		case 2688:
			return .iPhone_XSMax_ProMax
		default:
			return .unknown
		}
	}

}
