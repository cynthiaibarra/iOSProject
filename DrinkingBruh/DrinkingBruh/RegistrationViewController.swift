//
//  RegistrationViewController.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 3/2/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SkyFloatingLabelTextField

class RegistrationViewController: UIViewController, UITextFieldDelegate {
    
    private var emailValidated:Bool = false
    private let databaseRef:FIRDatabaseReference! = FIRDatabase.database().reference()
    
    @IBOutlet weak var firstNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var lastNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var confirmPasswordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var heightTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var weightTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var sexSegmentControl: UISegmentedControl!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Registration"
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setUpTextFields()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func registerButton(_ sender: Any) {
        messageLabel.text = ""
        
        let firstName:String = firstNameTextField.text!.trim()
        let lastName:String = lastNameTextField.text!.trim()
        let email:String = emailTextField.text!.trim()
        let emailDBEntry = email.replacingOccurrences(of: "@", with: "_")
        let password:String = passwordTextField.text!.trim()
        let confirmPassword:String = confirmPasswordTextField.text!.trim()
        let height:Int? = Int(heightTextField.text!)
        let weight:Int? = Int(weightTextField.text!)
        var sex:String = "M"
        if sexSegmentControl.selectedSegmentIndex == 1 {
            sex = "F"
        }
        
        // Check to see if there are any empty text fields.
        let areEmptyTextFields:Bool = firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty || heightTextField.text!.isEmpty || weightTextField.text!.isEmpty
        
        // Check that the necessary conditions are met before creating a user
        if areEmptyTextFields {
            shakeEmptyTextFields(firstName: firstName.isEmpty, lastName: lastName.isEmpty, email: email.isEmpty, password: password.isEmpty, confirmPassword: confirmPassword.isEmpty, height: heightTextField.text!.isEmpty, weight: weightTextField.text!.isEmpty)
            messageLabel.text = "Must fill in all entries."
        } else if password != confirmPassword{
            messageLabel.text = "Passwords do not match."
            
        } else if !emailValidated {
            messageLabel.text = "Must use a valid email."
        } else {
            // If created user successfully, save registration data in database. Otherwise show error to user.
            FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    self.messageLabel.text = ("\(error.localizedDescription)")
                    print(error)
                } else {
                    print("Added user \(email)")
                    self.messageLabel.text = "Successfully Registered!"
                    self.databaseRef.child("users").child((user?.uid)!).setValue(["firstName": firstName, "lastName": lastName, "email": emailDBEntry, "height" : height!, "weight": weight!, "sex": sex])
                }
            }
            
        }
    }
    
    private func setUpTextFields() {
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        heightTextField.delegate = self
        weightTextField.delegate = self
        emailTextField.errorColor = UIColor.red
        confirmPasswordTextField.delegate = self
        confirmPasswordTextField.errorColor = UIColor.red
    }
    
    // If the email text field does not contain an "@" or is shorter than 3 characters, show error sign to user. 
    // Does not replace actual email validation. Must verify email.
    // If the confirm password entry does not match the password, show an error to the user
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == emailTextField {
            if let text = textField.text {
                if let emailTextField = textField as? SkyFloatingLabelTextField {
                    if (text.characters.count < 3 || !text.contains("@")) && !text.isEmpty {
                        emailTextField.errorMessage = "Invalid email"
                        self.emailValidated = false
                    } else {
                        emailTextField.errorMessage = ""
                        self.emailValidated = true
                    }
                }
            }
        } else if textField == confirmPasswordTextField {
            let confirmPassword = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
            if let password = passwordTextField.text  {
                if let confirmPasswordTextField = textField as? SkyFloatingLabelTextField {
                    if confirmPassword != password && !confirmPassword.isEmpty {
                        confirmPasswordTextField.errorMessage = "Passwords do not match"
                    } else {
                        confirmPasswordTextField.errorMessage = ""
                    }
                }
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    private func shakeEmptyTextFields(firstName: Bool, lastName: Bool, email: Bool, password: Bool, confirmPassword: Bool, height: Bool, weight: Bool) {
        if firstName {
            firstNameTextField.shake()
        }
        if lastName {
            lastNameTextField.shake()
        }
        if email {
            emailTextField.shake()
        }
        if password {
            passwordTextField.shake()
        }
        if confirmPassword {
            confirmPasswordTextField.shake()
        }
        if height {
            heightTextField.shake()
        }
        if weight {
            weightTextField.shake()
        }
    }
}

public extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
