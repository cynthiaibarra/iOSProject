//
//  Config.swift
//  DrinkingBruh
//
//  Created by Vineeth on 3/23/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import Foundation

class Config: NSObject {

    fileprivate static let themeKey = "theme"
    fileprivate static let dModeKey = "drunkMode"
    fileprivate static let drinksKey = "drinks"

    
    class func setTheme(_ theme:String) {
        UserDefaults.standard.set(theme, forKey: themeKey)
        UserDefaults.standard.synchronize()
    }
    class func setDrunkMode(_ dMode:String) {
        UserDefaults.standard.set(dMode, forKey: dModeKey)
        UserDefaults.standard.synchronize()
    }
    
    class func theme() -> String {
        if let s = UserDefaults.standard.object(forKey: themeKey) as? String {
            return s
        }
        else {
            self.setTheme("dark")
            return "dark"
        }
    }
    class func drunkMode() -> String {
        if let s = UserDefaults.standard.object(forKey: dModeKey) as? String {
            return s
        }
        else {
            self.setDrunkMode("off")
            return "off"
        }
    }
    class func setDrinks(_ drinks:[String: Any]) {
        UserDefaults.standard.set(drinks, forKey: drinksKey)
        UserDefaults.standard.synchronize()
    }
    class func getDrinks() -> [String: Any] {
        if let d = UserDefaults.standard.object(forKey: drinksKey) as? [String: Any] {
            return d
        }
        else {
            return [String:Any]()
        }
    }
    
}
