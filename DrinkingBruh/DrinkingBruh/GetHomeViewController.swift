//
//  GetHomeViewController.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 4/10/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit

class GetHomeViewController: UIViewController {

    @IBOutlet weak var phoneButton1: UIButton!
    @IBOutlet weak var phoneButton2: UIButton!
    @IBOutlet weak var phoneButton3: UIButton!
    @IBOutlet weak var phoneButton4: UIButton!
    @IBOutlet weak var phoneButton5: UIButton!
    @IBOutlet weak var routeButton1: UIButton!
    @IBOutlet weak var routeButton2: UIButton!
    @IBOutlet weak var routeButton3: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneButton1.addTarget(self, action: #selector(GetHomeViewController.callPhoneNumber(sender:)), for: .touchUpInside)
        phoneButton2.addTarget(self, action: #selector(GetHomeViewController.callPhoneNumber(sender:)), for: .touchUpInside)
        phoneButton3.addTarget(self, action: #selector(GetHomeViewController.callPhoneNumber(sender:)), for: .touchUpInside)
        phoneButton4.addTarget(self, action: #selector(GetHomeViewController.callPhoneNumber(sender:)), for: .touchUpInside)
        phoneButton5.addTarget(self, action: #selector(GetHomeViewController.callPhoneNumber(sender:)), for: .touchUpInside)
        routeButton1.addTarget(self, action: #selector(GetHomeViewController.openURL(sender:)), for: .touchUpInside)
        routeButton2.addTarget(self, action: #selector(GetHomeViewController.openURL(sender:)), for: .touchUpInside)
        routeButton3.addTarget(self, action: #selector(GetHomeViewController.openURL(sender:)), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func callPhoneNumber(sender: UIButton!) {
        let phoneNumber:String = (sender.titleLabel?.text!)!
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @objc private func openURL(sender: UIButton!) {
        switch (sender.titleLabel?.text)! {
        case "Main Campus Route >":
            if let url = URL(string: "https://www.capmetro.org/schedmap/?svc=0&f1=412&s=1&d=0") {
                UIApplication.shared.open(url, options: [:])
            }
        case "West Campus Route >":
            if let url = URL(string: "https://www.capmetro.org/schedmap/?svc=0&f1=410&s=1&d=0") {
                UIApplication.shared.open(url, options: [:])
            }
        case "Riverside Route >" :
            if let url = URL(string: "https://www.capmetro.org/schedmap/?svc=0&f1=411&s=1&d=0") {
                UIApplication.shared.open(url, options: [:])
            }
        default:
            break
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
