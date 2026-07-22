//
//  UserDefaultsManager.swift
//  EduVerse360
//
//  Created by Ekta Rai on 12/07/2026.
//
import Foundation

struct UserDefaultsManager{
    static let shared = UserDefaultsManager()
    private init(){}
    
    private let standard = UserDefaults.standard
    
    enum UserDefaultKeys : String{
        case token = "token"
        case refreshToken = "refresh_token"
        case email = "email"
        case firstName = "first_name"
        case lastName = "last_name"
        
    }
    
    // Save Function
    func save (data: String, key:UserDefaultKeys){
        standard.set(data, forKey: key.rawValue)
    }
    
    func save(data:Int, key:UserDefaultKeys){
        standard.set(data, forKey: key.rawValue)
    }
    
    func save(data:Bool, key:UserDefaultKeys){
        standard.set(data, forKey: key.rawValue)
    }
    
    // Read Function
    func read(key:UserDefaultKeys) -> String?{
        return standard.string(forKey: key.rawValue)
        }
    
    func read(key:UserDefaultKeys) -> Int{
        return standard.integer(forKey: key.rawValue)
    }

    func read(key:UserDefaultKeys) -> Bool{
        return standard.bool(forKey: key.rawValue)
    }
    
    
    // Remove Function

    func remove(key:UserDefaultKeys){
        standard.removeObject(forKey: key.rawValue)
    }
}


