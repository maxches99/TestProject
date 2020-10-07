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

class ViewController: UIViewController {
	
	let sizeOfButton = CGFloat(80)
	let vm = ViewModel()
	
	private let bag = DisposeBag()
	
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
//				btn.isEnabled = false
//				btn.backgroundColor = .clear
				btn.setImage(UIImage(named: "faceId_icon"), for: .normal)
				btn.imageView?.tintColor = .systemGray4
				btn.imageView?.size(sizeOfButton * 0.8)
		}
		
		return btn
	}()
	
	private lazy var dots: [UIView] = {
		var arrDots: [UIView] = []
		
		for _ in 0..<4 {
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
		
		view.sv(vStack, lblPassword, hStackDots)
		
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
						dot.backgroundColor = .systemGreen
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
					self?.dots[index].backgroundColor = isChoose ? .systemGreen : .systemGray4
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
	ContainerView().preferredColorScheme(.light).edgesIgnoringSafeArea(.all)
  }
  
  struct ContainerView: UIViewControllerRepresentable {
	
	
	let tabBarVC = ViewController()
	
	func makeUIViewController(context: UIViewControllerRepresentableContext<ViewController_Previews.ContainerView>) -> ViewController {
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
