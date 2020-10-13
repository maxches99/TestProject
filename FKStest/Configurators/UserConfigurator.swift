//
//  UserConfigurator.swift
//  FKStest
//
//  Created by Администратор on 12.10.2020.
//

import Foundation

class UserConfigurator {
    
    static let shared = UserConfigurator()
    
    var name = UserDefaults.standard.string(forKey: "name")
    
    var email = UserDefaults.standard.string(forKey: "email")
    
    private(set) var pincode = UserDefaults.standard.string(forKey: "pincode")
    
    private(set) var isTouchID = UserDefaults.standard.bool(forKey: "isTouchID")
    
    private(set) var isFaceID = UserDefaults.standard.bool(forKey: "isFaceID")
    
    func refresh() {
        pincode = UserDefaults.standard.string(forKey: "pincode")
        
        isTouchID = UserDefaults.standard.bool(forKey: "isTouchID")
        
        isFaceID = UserDefaults.standard.bool(forKey: "isFaceID")
    }
    
    func toggleTouchID() {
        UserDefaults.standard.setValue(!isTouchID, forKey: "isTouchID")
    }
    
    func toggleFaceID() {
        UserDefaults.standard.setValue(!isFaceID, forKey: "isFaceID")
    }
    
    func setPincode(pinCode: String) {
        UserDefaults.standard.setValue(pinCode, forKey: "pincode")
    }
    
    func logOut() {
        UserDefaults.standard.setValue(false, forKey: "isTouchID")
        UserDefaults.standard.setValue(false, forKey: "isFaceID")
        UserDefaults.standard.setValue(nil, forKey: "pincode")
        UserDefaults.standard.setValue(nil, forKey: "email")
        UserDefaults.standard.setValue(nil, forKey: "name")
    }
    
}
