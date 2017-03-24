//
//  SettingsTableViewController.swift
//  DrinkingBruh
//
//  Created by Vineeth on 3/23/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    //MARK: Properties
    @IBOutlet weak var drunkModeLabel: UILabel!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var drunkModeSwitch: UISwitch!
    @IBOutlet weak var themeSegControl: UISegmentedControl!
    
    var themeDict:[String:UIColor]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings"
        
        //Get current theme and set theme for the view
        //and sub views and set state for themeSegControl
        
        self.themeDict = Theme.getTheme()
        drunkModeLabel.textColor = themeDict?["textColor"]
        themeLabel.textColor = themeDict?["textColor"]
        self.view.backgroundColor = themeDict?["viewColor"]
        
        let theme:String = Config.theme()
        
        if theme == "light" {
            themeSegControl.selectedSegmentIndex = 0
        }
        else {
            themeSegControl.selectedSegmentIndex = 1
        }
        
        //Get drunk mode state and set drunkModeSwitch
        
        let dMode:String = Config.drunkMode()
        
        if dMode == "on" {
            drunkModeSwitch.setOn(true, animated: true)
        }
        else {
            drunkModeSwitch.setOn(false, animated: true)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    
    @IBAction func editProfileButton(_ sender: Any) {
    }
    
    @IBAction func drunkModeAction(_ sender: Any) {
        
        if let dMode = sender as? UISwitch {
            
            if dMode.isOn {
                Config.setDrunkMode("on")
            }
            else {
                Config.setDrunkMode("off")
            }
        }
    }
    
    @IBAction func themeSegControlAction(_ sender: Any) {
        
        //Set theme to light or dark in UserDefaults and update view colors
        
        if let theme = sender as? UISegmentedControl {
            
            if theme.selectedSegmentIndex == 0 {
                Config.setTheme("light")
            }
            else {
                Config.setTheme("dark")
            }
        }
        
        self.themeDict = Theme.getTheme()
        drunkModeLabel.textColor = themeDict?["textColor"]
        themeLabel.textColor = themeDict?["textColor"]
        self.view.backgroundColor = themeDict?["viewColor"]

    }
    
}
