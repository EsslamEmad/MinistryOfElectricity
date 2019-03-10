//
//  Authentication.swift
//  MinistryOfElectricity
//
//  Created by Esslam Emad on 2/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation
import DefaultsKit
import PromiseKit


class Auth {
    
    static let auth = Auth()
    
    
    
    var user: User? {
        get {
            return Defaults().get(for: Key<User>("user"))
        }
        set {
            if let value = newValue {
                Defaults().set(value, for: Key<User>("user"))
            } else {
                UserDefaults.standard.set(nil, forKey: "user")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    private init() {
        
    }
    
}

