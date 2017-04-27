//
//  TimelineViewController.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 4/24/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    var eventID:String = ""
    var eventTitle:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = eventTitle
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    
    @IBAction func BACbutton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "DrinkTracker", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Bac") as! BacViewController
        controller.currentEventID = eventID
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @IBAction func drinkLogger(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "DrinkTracker", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DrinkTracker") as! DrinkLoggerViewController
        controller.currentEventID = eventID
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    

    @IBAction func friendLocation(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Location", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "FriendLocator") as! LocateFriendsViewController
        controller.currentEventID = eventID
        self.navigationController?.pushViewController(controller, animated: true)
        
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
