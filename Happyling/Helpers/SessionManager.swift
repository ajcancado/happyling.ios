//
//  SessionManager.swift
//  ValueGaia
//
//  Created by Arthur Cançado on 24/06/16.
//  Copyright © 2016 I-Value. All rights reserved.
//

import UIKit

class SessionManager {
    
    static func setObject(object: AnyObject?, forKey key: String){
        
        UserDefaults.standard.set(object, forKey: key)
    }
    
    static func getObjectForKey(key :String) -> AnyObject?{
        return UserDefaults.standard.value(forKey: key) as AnyObject?
    }
    
    static func getIntegerForKey(key :String) -> Int{
        return UserDefaults.standard.integer(forKey: key)
    }
    
    static func setInteger(int: Int, forKey key :String){
        UserDefaults.standard.set(int, forKey: key)
    }
    
    static func setBool(bool: Bool, forKey key: String){
        UserDefaults.standard.set(bool, forKey: key)
    }
    
    static func getBoolForKey(key: String) -> Bool{
        return UserDefaults.standard.bool(forKey: key)
    }
    
    static func containsObjectForKey(key :String) -> Bool{
        
        if UserDefaults.standard.object(forKey: key) != nil {
            return true;
        }
        
        return false;
    }
    
    static func removeObjectForKey(key :String){
        
        UserDefaults.standard.removeObject(forKey: key);
    }

}
