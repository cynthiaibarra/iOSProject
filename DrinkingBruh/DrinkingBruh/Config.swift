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
        return UserDefaults.standard.object(forKey: themeKey) as! String
    }
    class func drunkMode() -> String {
        return UserDefaults.standard.object(forKey: dModeKey) as! String
    }
}
