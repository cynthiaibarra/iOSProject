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


class SignInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var handler:FIRAuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        handler = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
            print("=================================")
            if user != nil {
                self.performSegue(withIdentifier: "segueToHome", sender: nil)
                print("Authenticated.")
                print(user?.email ?? "err")
           } else {
                print("Not authenticated.")
           }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signInButton(_ sender: Any) {
        messageLabel.text = ""
        let email:String = emailTextField.text!.trim()
        let password:String = passwordTextField.text!.trim()
        
        if email.isEmpty || password.isEmpty {
            if email.isEmpty{
                emailTextField.shake()
            }
            if password.isEmpty{
                passwordTextField.shake()
            }
            messageLabel.text = "Must fill in all entries."
        } else {
            FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
                if error != nil {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    print(error)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

public extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
