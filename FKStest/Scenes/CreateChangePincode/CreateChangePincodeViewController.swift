//
//  CreateChangePincodeViewController.swift
//  FKStest
//
//  Created by Администратор on 11.10.2020.
//

import UIKit
import Stevia
import RxSwift

class CreateChangePincodeViewController: UIViewController {
    
    var vm: CreateChangePincodeViewModel?
    
    private let bag = DisposeBag()
    
    private var lblSetPincode: UILabel = {
        let lbl = UILabel()
        
        lbl.text("Введитe пинкод")
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
    
    private lazy var dots: [UIView] = {
        var arrDots: [UIView] = []
        
        for _ in 0..<4 {
            let dot = UIView()
            if #available(iOS 13.0, *) {
                dot.backgroundColor = .systemGray4
            } else {
                dot.backgroundColor = .gray
            }
            dot.size(20)
            dot.layer.cornerRadius = 10
            arrDots.append(dot)
        }
        
        return arrDots
    }()
    
    private var textField: UITextField = {
        let textField = UITextField()
        
        textField.keyboardType = .numberPad
        
        return textField
    }()
    
    override func loadView() {
        let view = UIView()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = . white
        }
        
        let hStackDots = UIStackView()
        hStackDots.axis = .horizontal
        hStackDots.spacing = 16
        for dot in dots {
            hStackDots.addArrangedSubview(dot)
        }
        
        view.sv(
            lblSetPincode,
            hStackDots,
            textField
        )
        textField.alpha = 0
        lblSetPincode.centerHorizontally().top(40 + topbarHeight)
        hStackDots.centerHorizontally().Top == lblSetPincode.Bottom + 32
        
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textField.becomeFirstResponder()
    }
    
    private func setupBindings() {
        
        vm?.pincodeCompleted
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.dots.map { dot in
                    dot.backgroundColor = .systemBlue
                    UIView.animate(withDuration: 0.5, animations: {
                        dot.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                    }, completion: {_ in
                        UIView.animate(withDuration: 0.5, animations: {
                            dot.transform = CGAffineTransform.identity
                        }, completion: { [weak self]_ in
                            self?.vm?.goToNextScreen.onNext(())
                        })
                    })
                }
            })
            .disposed(by: bag)
        
        vm?.currentDotIndex
            .asDriver(onErrorJustReturn: (0, false))
            .drive(onNext: { [weak self] index, isChoose in
                UIView.animate(withDuration: 0.3, animations: { [weak self] in                    if #available(iOS 13.0, *) {
                    self?.dots[index].backgroundColor = isChoose ? .systemBlue : .systemGray4
                } else {
                    self?.dots[index].backgroundColor = isChoose ? .systemBlue : .gray
                }
                })
                })
            .disposed(by: bag)
        
        textField.rx.textInput.text
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [weak self] str in
                guard let str = str else { return }
                self?.vm?.addToCurrentString(string: str)
                if str.count == 5 {
                    self?.textField.isUserInteractionEnabled = false
                }
                })
            .disposed(by: bag)
    }

}

import SwiftUI
@available(iOS 13.0.0, *)
struct CreateChangePincodeViewController_Previews: PreviewProvider {
  static var previews: some View {
    Group {
        ContainerView().previewDevice("iPhone 11").preferredColorScheme(.light).edgesIgnoringSafeArea(.all)
    }
  }
  
  struct ContainerView: UIViewControllerRepresentable {
    
    
    let tabBarVC = CreateChangePincodeViewController()
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CreateChangePincodeViewController_Previews.ContainerView>) -> CreateChangePincodeViewController {
      return tabBarVC
    }
    
    func updateUIViewController(_ uiViewController: CreateChangePincodeViewController_Previews.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<CreateChangePincodeViewController_Previews.ContainerView>) {
      
    }
  }
}
