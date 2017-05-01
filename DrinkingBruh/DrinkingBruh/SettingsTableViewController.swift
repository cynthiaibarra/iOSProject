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
    
    private var themeDict:[String:UIColor]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings"

        //disable cell selection
        self.tableView.allowsSelection = false

        //Get current theme and set theme for the view
        //and sub views and set state for themeSegControl
        
        self.themeDict = Theme.getTheme()
        //drunkModeLabel.textColor = themeDict?["textColor"]
        //themeLabel.textColor = themeDict?["textColor"]
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
                self.navigationController?.navigationBar.barStyle = UIBarStyle.default
                self.navigationController?.navigationBar.tintColor = UIColor.black

            }
            else {
                Config.setTheme("dark")
                self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
                self.navigationController?.navigationBar.tintColor = UIColor.white

            }
        }
        
        self.themeDict = Theme.getTheme()
        //drunkModeLabel.textColor = themeDict?["textColor"]
        //themeLabel.textColor = themeDict?["textColor"]
        self.view.backgroundColor = themeDict?["viewColor"]
        self.tableView.reloadData()
        
        //change the background of Home screen
        self.navigationController?.previousViewController()?.view.backgroundColor = themeDict?["viewColor"]
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //cell.backgroundColor = UIColor.clear
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = themeDict?["viewColor"]?.cgColor
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.textColor = themeDict?["textColor"]
        let font = UIFont(name: "Avenir", size: 18.0)
        headerView.textLabel?.font = font!
        
        
    }
    
}

extension UINavigationController {
    
    //Get previous view controller of the navigation stack
    func previousViewController() -> UIViewController?{
        
        let length = self.viewControllers.count
        
        let previousViewController: UIViewController? = length >= 2 ? self.viewControllers[length-2] : nil
        
        return previousViewController
    }
    
}
