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
import FBSDKLoginKit



class SignInViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var facebookLogin: UIButton!
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
        //Facebook button
        facebookLogin.addTarget(self, action: #selector(handleFBLogin), for: .touchUpInside)

    }
    
    func handleFBLogin(){
        FBSDKLoginManager().logIn(withReadPermissions: ["email","public_profile"], from: self) { (result, err) in
            if(err != nil) {
                return
            }
            let accessToken = FBSDKAccessToken.current()
            let credentials = FIRFacebookAuthProvider.credential(withAccessToken: (accessToken?.tokenString)!)
            
            FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
                if(err != nil){
                    
                }
                print("Logged in")
            })
            
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        FBSDKGraphRequest(graphPath:"/me", parameters: ["fields": "id, name, email"]).start{(connection, result, err) in
            print(123)
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
                    print(error ?? "error")
                    
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
