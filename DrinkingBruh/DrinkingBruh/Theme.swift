//
//  Theme.swift
//  DrinkingBruh
//
//  Created by Vineeth on 3/23/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit

class Theme {
    
    class func getTheme() -> [String:UIColor] {
        
        var dict = [String:UIColor]()
        
        //Get Theme value from UserDefaults
        let theme:String = Config.theme()
        
        if theme == "light" {
            dict["viewColor"] = UIColor.white
            dict["textColor"] = UIColor.black
        }
        else {
            dict["viewColor"] = UIColor.brown
            dict["textColor"] = UIColor.white
        }
        
        return dict
    }
}
