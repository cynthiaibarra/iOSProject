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
import FirebaseStorageUI
import UserNotifications

class HomeViewController: UIViewController, UNUserNotificationCenterDelegate {


    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    private var themeDict:[String:UIColor] = Theme.getTheme()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"      
        // Do any additional setup after loading the view.
        setupQuote()
        setupDrinkOfTheDay()
        LocationTracker.getInstance().requestLocation()

        //Set Navigation Bar Font and Style
        let navBarTitleFont = UIFont(name: "Avenir", size: 20)!
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: navBarTitleFont]
        
        let theme:String = Config.theme()
        
        if theme == "light" {
            self.navigationController?.navigationBar.barStyle = UIBarStyle.default
            self.navigationController?.navigationBar.tintColor = UIColor.black
            
        }
        else {
            self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
            self.navigationController?.navigationBar.tintColor = UIColor.white
            
        }
        
        //Set Background Color
        self.view.backgroundColor = themeDict["viewColor"]

        UNUserNotificationCenter.current().getDeliveredNotifications(completionHandler: { (deliveredNotifications) -> () in
            print(deliveredNotifications.count)
        })
        
        UNUserNotificationCenter.current().getDeliveredNotifications(completionHandler: { deliveredNotifications -> () in
            if deliveredNotifications.count > 0 {
                for notification in deliveredNotifications {
                    let eventID:String = notification.request.identifier
                    DBHandler.addEventToTimeline(eventID: eventID)
                    UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [eventID])
                }
                
            }
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupQuote() {
        let quotes:DrinkQuotes = DrinkQuotes()
        let quote:[String:String] = quotes.returnQuote()
        let q:String = quote["quote"]!
        let author:String = quote["author"]!
        nameLabel.text = author
        quoteLabel.text = "\"\(q)\""
    }
    
    private func setupDrinkOfTheDay() {
        DBHandler.getDrinkOfTheDay() { (drink) -> () in
            let ingredients:[String:Any] = drink["ingredients"] as! [String:Any]
            let instructions:String = drink["instructions"] as! String
            let name:String = drink["name"] as! String
            let imageURL:String = drink["image"] as! String
            print(imageURL)
            self.drinkNameLabel.text = name
            self.instructionsLabel.text = instructions
            var ingredientList:String = ""
            for ingredient in ingredients {
                ingredientList += "-"
                ingredientList += ingredient.key
                if ingredient.value as! String != "nil" {
                    ingredientList += "\t\t\t\t"
                    ingredientList += ingredient.value as! String
                }
                ingredientList += "\n"
            }
            let url:URL = URL(string: imageURL)!
            self.ingredientsLabel.text = ingredientList
            self.drinkImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "genericUser"))
        }
    }

}
