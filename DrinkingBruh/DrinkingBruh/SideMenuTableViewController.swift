//
//  SideMenuTableViewController.swift
//  DrinkingBruh
//
//  Created by Vineeth on 3/24/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit
import FirebaseAuth

class SideMenuTableViewController: UITableViewController {

    private var themeDict:[String:UIColor] = Theme.getTheme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = themeDict["viewColor"]
        //Disable tableView cell selection
        self.tableView.allowsSelection = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    @IBAction func signOutButton(_ sender: UIButton) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        //Change to Dark Theme on Sign Out
        Config.setTheme("dark")
        
        self.performSegue(withIdentifier: "segueToSignIn", sender: nil)
    }

    @IBAction func settingsButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "settings") as UIViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
