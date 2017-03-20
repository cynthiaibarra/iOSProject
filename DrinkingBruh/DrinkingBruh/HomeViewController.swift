//
//  HomeViewController.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 3/17/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signOutButton(_ sender: Any) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        self.performSegue(withIdentifier: "segueToSignIn", sender: nil)
    }

}
