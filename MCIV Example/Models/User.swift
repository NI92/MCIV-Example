//
//  User.swift
//  MCIV Example
//
//  Created by Nick Ignatenko on 2019-11-22.
//  Copyright © 2019 Nick Ignatenko. All rights reserved.
//
//  Represents the actual user of the application. Doesn't exactly follow the rules of standard models. Thus, the exclusion of the 'Model' protocol.

import UIKit
import KeychainSwift

class User: MCodable {
    enum Constant {
        static let kUserUserDefaults        = "kUserUserDefaults"
        static let kAccessToken             = "accessToken"
        static let kRefreshToken            = "refreshToken"
        static let kAccessTokenExpiresIn    = "accessTokenExpiresIn"
    }
    //@objc var email: String? = nil
    
    static var current: User {
        set {
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
            UserDefaults.standard.setValue(data, forKey: Constant.kUserUserDefaults)
            UserDefaults.standard.synchronize()
        }
        get {
            if let userData = UserDefaults.standard.value(forKey: Constant.kUserUserDefaults) as? Data,
                let user = NSKeyedUnarchiver.unarchiveObject(with: userData) as? User {
                return user
            }
            return User.clean
        }
    }
    
    static var clean: User {
        return User()
    }
    
    var accessToken: String? {
        get {
            let keychain = KeychainSwift()
            keychain.synchronizable = false
            return keychain.get(Constant.kAccessToken)
        }
        set {
            let keychain = KeychainSwift()
            if let newValue = newValue {
                keychain.set(newValue, forKey: Constant.kAccessToken)
            } else {
                KeychainSwift().delete(Constant.kAccessToken)
            }
        }
    }
    
    var refreshToken: String? {
        get {
            let keychain = KeychainSwift()
            keychain.synchronizable = false
            return keychain.get(Constant.kRefreshToken)
        }
        set {
            let keychain = KeychainSwift()
            if let newValue = newValue {
                keychain.set(newValue, forKey: Constant.kRefreshToken)
            } else {
                KeychainSwift().delete(Constant.kRefreshToken)
            }
        }
    }
    
    var accessTokenExpiresIn: String? {
        get {
            let keychain = KeychainSwift()
            keychain.synchronizable = false
            return keychain.get(Constant.kAccessTokenExpiresIn)
        }
        set {
            let keychain = KeychainSwift()
            if let newValue = newValue {
                keychain.set(newValue, forKey: Constant.kAccessTokenExpiresIn)
            } else {
                KeychainSwift().delete(Constant.kAccessTokenExpiresIn)
            }
        }
    }
    
    func synchronize(inBackground: Bool = true) {
        if inBackground {
            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
                User.current = self
            }
        } else {
            User.current = self
        }
    }
    
    static var isAuthorized: Bool {
        return KeychainSwift().get(Constant.kAccessToken) != nil
    }
}

// MARK: - Actions
extension User {
    func logout() {
        let user = User.clean
        user.synchronize(inBackground: false)
        KeychainSwift().delete(Constant.kAccessToken)
        KeychainSwift().delete(Constant.kRefreshToken)
        KeychainSwift().delete(Constant.kAccessTokenExpiresIn)
    }
}
