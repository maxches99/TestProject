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
    
    private var lblSetPincode: UILabel = {
        let lbl = UILabel()
        
        lbl.text("Введитe пинкод")
        lbl.font = .systemFont(ofSize: 20, weight: .medium)
        lbl.textColor = .label
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        
        return lbl
    }()
    
    private lazy var dots: [UIView] = {
        var arrDots: [UIView] = []
        
        for _ in 0..<5 {
            let dot = UIView()
            dot.backgroundColor = .systemGray4
            dot.size(20)
            dot.layer.cornerRadius = 10
            arrDots.append(dot)
        }
        
        return arrDots
    }()
    
    override func loadView() {
        let view = UIView()
        
        let hStackDots = UIStackView()
        hStackDots.axis = .horizontal
        hStackDots.spacing = 16
        for dot in dots {
            hStackDots.addArrangedSubview(dot)
        }
        
        view.sv(
            lblSetPincode,
            hStackDots
        )
        
        lblSetPincode.centerHorizontally().top(40)
        hStackDots.centerHorizontally().Top == lblSetPincode.Bottom + 32
        
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
struct CreateChangePincodeViewController_Previews: PreviewProvider {
  static var previews: some View {
    Group {
        ContainerView().preferredColorScheme(.light).edgesIgnoringSafeArea(.all)
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
