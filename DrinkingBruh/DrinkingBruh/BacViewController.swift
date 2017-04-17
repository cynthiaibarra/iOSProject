//
//  BacViewController.swift
//  DrinkingBruh
//
//  Created by Vineeth on 4/16/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit
import FirebaseAuth

class BacViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var BACLabel: UILabel!
    @IBOutlet weak var beerCountLabel: UILabel!
    @IBOutlet weak var vodkaCountLabel: UILabel!
    @IBOutlet weak var ginCountLabel: UILabel!
    @IBOutlet weak var whiskeyCountLabel: UILabel!
    @IBOutlet weak var tequilaCountLabel: UILabel!
    @IBOutlet weak var wineCountLabel: UILabel!
    @IBOutlet weak var drinkTotalLabel: UILabel!
    
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
    
    //get this user's email
    let userEmail = FIRAuth.auth()?.currentUser?.email?.firebaseSanitize()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "BAC Calculator"
        // Do any additional setup after loading the view.
        
        if (Config.getDrinks().count != 0) {
            drinksDict = Config.getDrinks()
        }
        else {
            drinksDict = ["beer": 0, "vodka": 0, "gin": 0, "whiskey": 0, "tequila": 0, "wine": 0, "elapsedTime": 0.0]
        }
        
        DBHandler.getUserInfo(userEmail: self.userEmail!) { (user) -> () in
            self.userWeight = user["weight"] as! Int
            self.userGender = user["sex"] as! String
        }
        
        beer = drinksDict?["beer"] as! Int
        vodka = drinksDict?["vodka"] as! Int
        gin = drinksDict?["gin"] as! Int
        whiskey = drinksDict?["whiskey"] as! Int
        tequila = drinksDict?["tequila"] as! Int
        wine = drinksDict?["wine"] as! Int
        elapsedTime = drinksDict?["elapsedTime"] as! Double
        
        drinkTotal = beer + vodka + gin + whiskey + tequila + wine
        
        beerCountLabel.text = String(beer)
        vodkaCountLabel.text = String(vodka)
        ginCountLabel.text = String(gin)
        whiskeyCountLabel.text = String(whiskey)
        tequilaCountLabel.text = String(tequila)
        wineCountLabel.text = String(wine)
        drinkTotalLabel.text = String(drinkTotal)
        
        //compute BAC
        var bac:Double = 0.0
        var bacRaw:Double = 0.0
        
        let gramsOfAlcohol:Int = drinkTotal * 14
        let bodyWeightInGrams:Int = userWeight * 454
        
        if(userGender == "M") {
            bacRaw = Double(gramsOfAlcohol)/(Double(bodyWeightInGrams) * 0.68)
        }
        else {
            bacRaw = Double(gramsOfAlcohol)/(Double(bodyWeightInGrams) * 0.55)
        }
        
        bac = (bacRaw * 100.0) - (elapsedTime * 0.015)
        
        BACLabel.text = String(bac)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    @IBAction func clearButton(_ sender: UIButton) {
        
        beer = 0
        vodka = 0
        gin = 0
        whiskey = 0
        tequila = 0
        wine = 0
        drinkTotal = 0
        
        drinksDict?["beer"] = beer
        drinksDict?["vodka"] = vodka
        drinksDict?["gin"] = gin
        drinksDict?["whiskey"] = whiskey
        drinksDict?["tequila"] = tequila
        drinksDict?["wine"] = wine
        drinksDict?["elapsedTime"] = 0.0
        
        beerCountLabel.text = String(beer)
        vodkaCountLabel.text = String(vodka)
        ginCountLabel.text = String(gin)
        whiskeyCountLabel.text = String(whiskey)
        tequilaCountLabel.text = String(tequila)
        wineCountLabel.text = String(wine)
        drinkTotalLabel.text = String(drinkTotal)
        BACLabel.text = "0"
        
        //update UserDefaults
        Config.setDrinks(drinksDict!)

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
