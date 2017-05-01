//
//  BacTableViewController.swift
//  DrinkingBruh
//
//  Created by Vineeth on 4/28/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit
import FirebaseAuth

class BacTableViewController: UITableViewController {
    
    //MARK: Properties
    @IBOutlet weak var BACLabel: UILabel!
    @IBOutlet weak var beerCountLabel: UILabel!
    @IBOutlet weak var vodkaCountLabel: UILabel!
    @IBOutlet weak var ginCountLabel: UILabel!
    @IBOutlet weak var whiskeyCountLabel: UILabel!
    @IBOutlet weak var tequilaCountLabel: UILabel!
    @IBOutlet weak var wineCountLabel: UILabel!
    @IBOutlet weak var drinkTotalLabel: UILabel!
    
    var currentEventID:String?
    var drinksDict:[String:Any]?
    var userWeight:Int = 0
    var userGender:String = "M"
    var drinkTotal:Int = 0
    var beer:Int = 0
    var vodka:Int = 0
    var gin:Int = 0
    var whiskey:Int = 0
    var tequila:Int = 0
    var wine:Int = 0
    var elapsedTime:Double = 0.0
    private var themeDict:[String:UIColor] = Theme.getTheme()
    
    //get this user's email
    let userEmail = FIRAuth.auth()?.currentUser?.email?.firebaseSanitize()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "BAC Calculator"
        
        //currentEventID = "869E96C8-BFE9-48EA-A54D-11E7C314696A"
        
        //Set Theme
        self.view.backgroundColor = themeDict["viewColor"]
        
        //Disable tableView Cell Selection
        self.tableView.allowsSelection = false
                
        DBHandler.getDrinks(eventID: currentEventID!) { (drinkLog) -> () in
            if(drinkLog != nil) {
                self.drinksDict = drinkLog
            }
            else {
                self.drinksDict = ["beer": 0, "vodka": 0, "gin": 0, "whiskey": 0, "tequila": 0, "wine": 0, "elapsedTime": 0.0]
            }
            
            self.initializeAndComputeBAC()
        }
        
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeAndComputeBAC() {
        
        DBHandler.getUserInfo(userEmail: self.userEmail!) { (user) -> () in
            self.userWeight = user["weight"] as! Int
            self.userGender = user["sex"] as! String
            //print(self.userWeight)
            
            self.beer = self.drinksDict?["beer"] as! Int
            self.vodka = self.drinksDict?["vodka"] as! Int
            self.gin = self.drinksDict?["gin"] as! Int
            self.whiskey = self.drinksDict?["whiskey"] as! Int
            self.tequila = self.drinksDict?["tequila"] as! Int
            self.wine = self.drinksDict?["wine"] as! Int
            self.elapsedTime = self.drinksDict?["elapsedTime"] as! Double
            
            self.drinkTotal = self.beer + self.vodka + self.gin + self.whiskey + self.tequila + self.wine
            
            self.beerCountLabel.text = String(self.beer)
            self.vodkaCountLabel.text = String(self.vodka)
            self.ginCountLabel.text = String(self.gin)
            self.whiskeyCountLabel.text = String(self.whiskey)
            self.tequilaCountLabel.text = String(self.tequila)
            self.wineCountLabel.text = String(self.wine)
            self.drinkTotalLabel.text = String(self.drinkTotal)
            
            //compute BAC
            var bac:Double = 0.0
            var bacRaw:Double = 0.0
            
            let gramsOfAlcohol:Int = self.drinkTotal * 14
            let bodyWeightInGrams:Int = self.userWeight * 454
            //print(bodyWeightInGrams)
            
            if(self.userGender == "M") {
                bacRaw = Double(gramsOfAlcohol)/(Double(bodyWeightInGrams) * 0.68)
            }
            else {
                bacRaw = Double(gramsOfAlcohol)/(Double(bodyWeightInGrams) * 0.55)
            }
            
            bac = (bacRaw * 100.0) - (self.elapsedTime * 0.015)
            
            if(bac < 0) {
                bac = 0
            }
            
            self.BACLabel.text = String(format: "%.3f", bac)
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //cell.backgroundColor = UIColor.clear
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = themeDict["viewColor"]?.cgColor
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.textColor = themeDict["textColor"]
        let font = UIFont(name: "Avenir", size: 18.0)
        headerView.textLabel?.font = font!
        
        
    }
    
}
