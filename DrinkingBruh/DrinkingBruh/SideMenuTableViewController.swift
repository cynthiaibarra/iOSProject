//
//  SideMenuTableViewController.swift
//  DrinkingBruh
//
//  Created by Vineeth on 3/24/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseStorageUI

class SideMenuTableViewController: UITableViewController {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    private var themeDict:[String:UIColor] = Theme.getTheme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = themeDict["viewColor"]
        //Disable tableView cell selection
        self.tableView.allowsSelection = false
        let radius = userImageView.frame.width / 2
        userImageView.layer.cornerRadius = radius
        userImageView.layer.masksToBounds = true
        DBHandler.getUserInfo(userEmail: DBHandler.getUserEmail()) { (user) -> () in
            self.nameLabel.text = user["fullName"] as? String
            let imageID:String = user["image"] as! String
            let reference = FIRStorage.storage().reference().child(imageID)
            self.userImageView.sd_setImage(with: reference, placeholderImage: UIImage(named: "genericUser"))
        }
        
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
