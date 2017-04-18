//
//  PasswordResetViewController.swift
//  DrinkingBruh
//
//  Created by Juan Villegas on 4/17/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit
import Firebase

class PasswordResetViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func resetPassword(_ sender: Any) {
        if (self.emailField.text?.isEmpty)!{
            let alertView = UIAlertController(title: "Invalid", message:"Please enter a valid email address", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alertView, animated: true, completion: nil)
        }
        else{
            FIRAuth.auth()?.sendPasswordReset(withEmail: self.emailField.text!, completion: { (error) in
                if(error != nil){
                    let alertView = UIAlertController(title: "Invalid", message:"Error occurred", preferredStyle: .alert)
                    alertView.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))

                    self.present(alertView, animated: true, completion: nil)
                }
                else{
                    let alertView = UIAlertController(title: "Reset Sent", message:"A reset link has been sent to your email address", preferredStyle: .alert)
                    alertView.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alertView, animated: true, completion: nil)
                }
            })

            
        }
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
