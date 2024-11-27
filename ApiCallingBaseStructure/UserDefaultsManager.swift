//
//  UserDefaultsManager.swift
//  ApiCallingBaseStructure
//
//  Created by Sharandeep Singh on 21/09/24.
//

import Foundation

enum LocalDataType: String {
    
    case authToken = "authToken"
}

struct UserDefaultsManager {
    
    static var authToken: String? {
        get {
            return UserDefaults.standard.string(forKey: LocalDataType.authToken.rawValue)
        } set {
            UserDefaults.standard.set(newValue, forKey: LocalDataType.authToken.rawValue)
        }
    }
}
