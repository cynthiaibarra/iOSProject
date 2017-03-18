//
//  SignInViewController.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 3/2/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var handler:FIRAuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        handler = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
            print("=================================")
            if user != nil {
                print("Authenticated.")
                print(user?.email ?? "err")
                self.performSegue(withIdentifier: "segueToHome", sender: nil)
           } else {
                print("Not authenticated.")
           }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
        // Dispose of any resources that can be recreated.
    }
    
    
    // Follow methods viewWillAppear and viewWillDisappear make sure that the navigation bar
    // does not appear on the SignInViewController screen but does appear for the rest
    @IBAction func signInButton(_ sender: Any) {
        messageLabel.text = ""
        let email:String = emailTextField.text!
        let password:String = passwordTextField.text!
        
        if email.isEmpty || password.isEmpty {
            messageLabel.text = "Must fill in all entries."
        } else {
            FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
                if error != nil {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
