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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"      
        // Do any additional setup after loading the view.
        UNUserNotificationCenter.current().getDeliveredNotifications(completionHandler: { deliveredNotifications -> () in
            if deliveredNotifications.count > 0 {
                for notification in deliveredNotifications {
                    let eventID:String = notification.request.identifier
                    DBHandler.addEventToTimeline(eventID: eventID)
                    UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [eventID])
                    DBHandler.deleteEvent(eventID: eventID)
                }
                
            }
        })
        setupQuote()
        setupDrinkOfTheDay()
        LocationTracker.getInstance().requestLocation()
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
