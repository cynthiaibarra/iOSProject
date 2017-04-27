//
//  DrinkLoggerViewController.swift
//  DrinkingBruh
//
//  Created by Vineeth on 4/16/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit

class DrinkLoggerViewController: UIViewController {
    
    //MARK: Properties
    var currentEventID:String?
    var drinksDict:[String:Any]?
    
    @IBOutlet weak var beerCountLabel: UILabel!
    @IBOutlet weak var vodkaCountLabel: UILabel!
    @IBOutlet weak var ginCountLabel: UILabel!
    @IBOutlet weak var whiskeyCountLabel: UILabel!
    @IBOutlet weak var tequilaCountLabel: UILabel!
    @IBOutlet weak var wineCountLabel: UILabel!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var drinkTotalLabel: UILabel!
    
    @IBOutlet weak var beerStep: UIStepper!
    @IBOutlet weak var vodkaStep: UIStepper!
    @IBOutlet weak var ginStep: UIStepper!
    @IBOutlet weak var whiskeyStep: UIStepper!
    @IBOutlet weak var tequilaStep: UIStepper!
    @IBOutlet weak var wineStep: UIStepper!
    @IBOutlet weak var elapsedTimeStep: UIStepper!
    
    var beerCount:Int = 0
    var vodkaCount:Int = 0
    var ginCount:Int = 0
    var whiskeyCount:Int = 0
    var tequilaCount:Int = 0
    var wineCount:Int = 0
    var elapsedTime:Double = 0.0
    var drinkTotal:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Drink Logger"
        // Do any additional setup after loading the view.
        
        //currentEventID = "869E96C8-BFE9-48EA-A54D-11E7C314696A"
        //print(currentEventID ?? "")
        
        if (currentEventID != nil) {
            
            DBHandler.getDrinks(eventID: currentEventID!) { (drinkLog) -> () in
                if(drinkLog != nil) {
                    self.drinksDict = drinkLog
                }
                else {
                    self.drinksDict = ["beer": 0, "vodka": 0, "gin": 0, "whiskey": 0, "tequila": 0, "wine": 0, "elapsedTime": 0.0]
                }
                
                self.initialize()
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    @IBAction func saveButton(_ sender: UIButton) {
        
        drinksDict?["beer"] = beerCount
        drinksDict?["vodka"] = vodkaCount
        drinksDict?["gin"] = ginCount
        drinksDict?["whiskey"] = whiskeyCount
        drinksDict?["tequila"] = tequilaCount
        drinksDict?["wine"] = wineCount
        drinksDict?["elapsedTime"] = elapsedTime
        
        //Save Data to database
        if (currentEventID != nil) {
            //print(drinksDict ?? " ")
            DBHandler.addDrink(eventID: currentEventID!, drinks: drinksDict!)
        }
        
        drinkTotal = beerCount + vodkaCount + ginCount + whiskeyCount + tequilaCount + wineCount
        drinkTotalLabel.text = String(drinkTotal)
        
    }
    
    @IBAction func beerStepper(_ sender: UIStepper) {

        beerCount = Int(sender.value)
        beerCountLabel.text = String(beerCount)

    }
    
    @IBAction func vodkaStepper(_ sender: UIStepper) {
        vodkaCount = Int(sender.value)
        vodkaCountLabel.text = String(vodkaCount)

    }
    
    @IBAction func ginStepper(_ sender: UIStepper) {
        ginCount = Int(sender.value)
        ginCountLabel.text = String(ginCount)

    }
    
    @IBAction func whiskeyStepper(_ sender: UIStepper) {
        whiskeyCount = Int(sender.value)
        whiskeyCountLabel.text = String(whiskeyCount)

    }
    
    @IBAction func tequilaStepper(_ sender: UIStepper) {
        tequilaCount = Int(sender.value)
        tequilaCountLabel.text = String(tequilaCount)

    }
    
    @IBAction func wineStepper(_ sender: UIStepper) {
        wineCount = Int(sender.value)
        wineCountLabel.text = String(wineCount)

    }
    
    @IBAction func elapsedTimeStepper(_ sender: UIStepper) {
        elapsedTime = sender.value
        elapsedTimeLabel.text = String(elapsedTime)

    }
    
    
    func initialize() {
        beerCount = drinksDict?["beer"] as! Int
        vodkaCount = drinksDict?["vodka"] as! Int
        ginCount = drinksDict?["gin"] as! Int
        whiskeyCount = drinksDict?["whiskey"] as! Int
        tequilaCount = drinksDict?["tequila"] as! Int
        wineCount = drinksDict?["wine"] as! Int
        elapsedTime = drinksDict?["elapsedTime"] as! Double
        
        drinkTotal = beerCount + vodkaCount + ginCount + whiskeyCount + tequilaCount + wineCount
        drinkTotalLabel.text = String(drinkTotal)
        
        beerCountLabel.text = String(beerCount)
        vodkaCountLabel.text = String(vodkaCount)
        ginCountLabel.text = String(ginCount)
        whiskeyCountLabel.text = String(whiskeyCount)
        tequilaCountLabel.text = String(tequilaCount)
        wineCountLabel.text = String(wineCount)
        elapsedTimeLabel.text = String(elapsedTime)
        
        beerStep.value = Double(beerCount)
        vodkaStep.value = Double(vodkaCount)
        ginStep.value = Double(ginCount)
        whiskeyStep.value = Double(whiskeyCount)
        tequilaStep.value = Double(tequilaCount)
        wineStep.value = Double(wineCount)
        elapsedTimeStep.value = elapsedTime

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
