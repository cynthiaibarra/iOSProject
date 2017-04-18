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
import UserNotifications

class HomeViewController: UIViewController, UNUserNotificationCenterDelegate {

    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var quoteTextView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"      
        // Do any additional setup after loading the view.
        let quotes:DrinkQuotes = DrinkQuotes()
        let quote:[String:String] = quotes.returnQuote()
        let q:String = quote["quote"]!
        let author:String = quote["author"]!
        nameLabel.text = author
        quoteTextView.text = "\"\(q)\""
        LocationTracker.getInstance().requestLocation()
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
