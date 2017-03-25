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
            self.setTheme("light")
            return "light"
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
}
