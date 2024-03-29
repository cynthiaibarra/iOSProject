//
//  EditProfileTableViewController.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 4/27/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit

class EditProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var sexSegmentedControl: UISegmentedControl!
    private var themeDict:[String:UIColor] = Theme.getTheme()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Profile"
        
        //Set Theme
        self.view.backgroundColor = themeDict["viewColor"]
        
        //Disable tableView Cell Selection
        self.tableView.allowsSelection = false

        DBHandler.getUserInfo(userEmail: DBHandler.getUserEmail()){ (user) -> () in
            self.firstNameTextField.text = user["firstName"] as? String
            self.lastNameTextField.text = user["lastName"] as? String
            let weight:Int = (user["weight"] as? Int)!
            self.weightTextField.text = "\(weight)"
            if user["sex"] as? String == "F" {
                self.sexSegmentedControl.selectedSegmentIndex = 1
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func editProfileButton(_ sender: UIButton) {
        var valid:Bool = true
        if (firstNameTextField.text?.isEmpty)! {
            firstNameTextField.shake()
            valid = false
        }
        if (lastNameTextField.text?.isEmpty)! {
            lastNameTextField.shake()
            valid = false
        }
        if (weightTextField.text?.isEmpty)! {
            weightTextField.shake()
            valid = false
        }
        
        if valid {
            var sex:String = "M"
            if sexSegmentedControl.selectedSegmentIndex == 1 {
                sex = "F"
            }
            DBHandler.updateProfile(firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, weight: Int(weightTextField.text!)!, sex: sex)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //cell.backgroundColor = UIColor.clear
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = themeDict["viewColor"]?.cgColor
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.textColor = themeDict["textColor"]
        let font = UIFont(name: "Avenir", size: 18.0)
        headerView.textLabel?.font = font!
        
        
    }

}
