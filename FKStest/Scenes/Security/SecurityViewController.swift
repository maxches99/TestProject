//
//  SecurityViewController.swift
//  FKStest
//
//  Created by Администратор on 11.10.2020.
//

import UIKit
import Stevia
import RxSwift

class SecurityViewController: UIViewController {
    
    private var lblTouchID: UILabel = {
        let lbl = UILabel()
        
        lbl.text("TouchID")
        lbl.font = .systemFont(ofSize: 20, weight: .medium)
        lbl.textColor = .label
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        
        return lbl
    }()
    
    private var lblFaceID: UILabel = {
        let lbl = UILabel()
        
        lbl.text("FaceID")
        lbl.font = .systemFont(ofSize: 20, weight: .medium)
        lbl.textColor = .label
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
    
    private var switchTouchID: UISwitch = {
        let btn = UISwitch()

        
        return btn
    }()
    
    private var switchFaceID: UISwitch = {
        let btn = UISwitch()

        
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
        
        lblTouchID.left(16).top(32)
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
