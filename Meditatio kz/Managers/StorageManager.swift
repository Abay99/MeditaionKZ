//
//  StorageManager.swift
//  Jiber
//
//  Created by I on 9/5/19.
//  Copyright © 2019 Shyngys. All rights reserved.
//

import Alamofire

final class StorageManager {
    private init() {}
    
    public static var shared = StorageManager()
    
    func removeSavedData() {
        StorageManager.shared.token = nil
        StorageManager.shared.userData = nil
        StorageManager.shared.email = nil
    }
    
    var token: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "token")
        } get {
            return UserDefaults.standard.value(forKey: "token") as? String
        }
    }
    
    var email: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "email")
        } get {
            return UserDefaults.standard.value(forKey: "email") as? String
        }
    }
    
    var subscribed: Bool? {
        set {
            UserDefaults.standard.set(newValue, forKey: "subscribed")
        } get {
            return UserDefaults.standard.value(forKey: "subscribed") as? Bool
        }
    }
    
    static func isUserLoggedIn() -> Bool {
        return StorageManager.shared.token != nil
    }
    
//    var phone: String? {
//        set {
//            UserDefaults.standard.set(newValue, forKey: "phone")
//        } get {
//            return UserDefaults.standard.value(forKey: "phone") as? String
//        }
//    }
    
    var language: Bool? {
        set {
            UserDefaults.standard.set(newValue, forKey: "lang")
        } get {
            return UserDefaults.standard.value(forKey: "lang") as? Bool
        }
    }
    
    var userData: [String : String]? {
        set {
            UserDefaults.standard.set(newValue, forKey: "userData")
        } get {
            return UserDefaults.standard.value(forKey: "userData") as? [String : String]
        }
    }
//
//    var filter: FilterViewModul? {
//        set {
//            guard newValue != nil else {
//                UserDefaults.standard.removeObject(forKey: "filter");
//                return;
//            }
//            let encodedData = try? PropertyListEncoder().encode(newValue)
//            UserDefaults.standard.set(encodedData, forKey:"filter")
//            UserDefaults.standard.synchronize();
//        }
//        get {
//            if let data = UserDefaults.standard.value(forKey: "filter") as? Data {
//                return try? PropertyListDecoder().decode(FilterViewModul.self, from:data)
//            }
//            return nil
//        }
//
//
//    }
}
