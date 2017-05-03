//
//  LeaderBoardTableViewController.swift
//  DrinkingBruh
//
//  Created by Vineeth on 4/30/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit

class LeaderBoardTableViewController: UITableViewController {
    
    //MARK: Properties
    var currentEventID:String?
    private var themeDict:[String:UIColor] = Theme.getTheme()
    var designatedDriversEmails:[String]?
    var designatedDriversNames:[String]?
    var sortedBACs:[String]?
    var emailsForBAC:[String]?
    var namesForBAC:[String]?
    var sortedAcendingBACs:[Double]?
    var sortedDescendingBACs:[Double]?
    
    let gold = UIColor(hex: 0xFFD700)
    let silver = UIColor(hex: 0xC0C0C0)
    let bronze = UIColor(hex: 0xCD7F32)

    @IBOutlet weak var rankLabel1: UILabel!
    @IBOutlet weak var rankLabel2: UILabel!
    @IBOutlet weak var rankLabel3: UILabel!
    @IBOutlet weak var rankLabel4: UILabel!
    @IBOutlet weak var rankLabel5: UILabel!
    
    @IBOutlet weak var nameLabel1: UILabel!
    @IBOutlet weak var nameLabel2: UILabel!
    @IBOutlet weak var nameLabel3: UILabel!
    @IBOutlet weak var nameLabel4: UILabel!
    @IBOutlet weak var nameLabel5: UILabel!
    
    @IBOutlet weak var bacLabel1: UILabel!
    @IBOutlet weak var bacLabel2: UILabel!
    @IBOutlet weak var bacLabel3: UILabel!
    @IBOutlet weak var bacLabel4: UILabel!
    @IBOutlet weak var bacLabel5: UILabel!
    
    @IBOutlet weak var ddNameLabel1: UILabel!
    @IBOutlet weak var ddNameLabel2: UILabel!
    @IBOutlet weak var ddNameLabel3: UILabel!
    @IBOutlet weak var ddNameLabel4: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Leaderboard"
        
        //Set Theme
        self.view.backgroundColor = themeDict["viewColor"]
        
        //Disable tableView Cell Selection
        self.tableView.allowsSelection = false
        
        designatedDriversEmails = [String]()
        designatedDriversNames = [String]()
        sortedBACs = [String]()
        emailsForBAC = [String]()
        namesForBAC = [String]()
        sortedAcendingBACs = [Double]()
        sortedDescendingBACs = [Double]()
        
        //set labels to blank
        initializeLabels()
        
        if(currentEventID != nil) {
            DBHandler.getBACs(eventID: self.currentEventID!) { (bacDict) -> () in
                if(bacDict != nil) {
                    for bac in bacDict! {
                        let temp = bac.value as! [String : Any]
                        for item in temp {
                            self.emailsForBAC?.append(bac.key)
                            //self.sortedBACs?.append(String(item.value as! Double))
                            self.sortedAcendingBACs?.append(item.value as! Double)
                        }
                    }
                    
                    self.sortedDescendingBACs = self.sortedAcendingBACs?.sorted(by: >)
                    for item in self.sortedDescendingBACs! {
                        self.sortedBACs?.append(String(item))
                    }
                    
                    //print(self.emailsForBAC ?? "emails")
                    //print(self.sortedBACs ?? "bacs")

                    var counter1 = 0;
                    for email in self.emailsForBAC! {
                        DBHandler.getUserInfo(userEmail: email) { (user) -> () in
                            let fullName:String = user["fullName"] as! String
                            self.namesForBAC?.append(fullName)
                            
                            if(counter1 == (self.emailsForBAC?.count)! - 1) {
                                self.setupLeaderboard()
                            }
                            else {
                                counter1 += 1
                            }
                            
                            //print(self.namesForBAC ?? " ")
                        }
                    }
                    
                    DBHandler.getRoles(eventID: self.currentEventID!) { (roles) -> () in
                        //print(roles)
                        for role in roles {
                            
                            if (role.value == "Designated Driver") {
                                self.designatedDriversEmails?.append(role.key)
                            }
                        }
                        
                        var counter2 = 0;
                        for desigEmail in self.designatedDriversEmails! {
                            DBHandler.getUserInfo(userEmail: desigEmail) { (user) -> () in
                                let fullName:String = user["fullName"] as! String
                                self.designatedDriversNames?.append(fullName)
                                
                                if(counter2 == (self.designatedDriversEmails?.count)! - 1) {
                                    self.addDesignatedDrivers()
                                }
                                else {
                                    counter2 += 1
                                }
                                
                            }
                        }
                        

                    }
                    
                    //print(self.designatedDriversEmails ?? "test")
                    
                }
            }
        }
        
        //Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LeaderBoardTableViewController.setupLeaderboard), userInfo: nil, repeats: false)
        
        //Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LeaderBoardTableViewController.addDesignatedDrivers), userInfo: nil, repeats: false)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeLabels() {
        rankLabel1.text = " "
        nameLabel1.text = " "
        bacLabel1.text = " "
        
        rankLabel2.text = " "
        nameLabel2.text = " "
        bacLabel2.text = " "
        
        rankLabel3.text = " "
        nameLabel3.text = " "
        bacLabel3.text = " "
        
        rankLabel4.text = " "
        nameLabel4.text = " "
        bacLabel4.text = " "

        rankLabel5.text = " "
        nameLabel5.text = " "
        bacLabel5.text = " "

        ddNameLabel1.text = " "
        ddNameLabel2.text = " "
        ddNameLabel3.text = " "
        ddNameLabel4.text = " "
    }
    
    func setupLeaderboard() {
        
        if((sortedBACs?.count)! < 5) {
            while ((sortedBACs?.count)! < 5) {
                sortedBACs?.append(" ")
                namesForBAC?.append(" ")
            }
        }

        var rank:Int = 1;
        var index:Int = 0;
        
        //Position 1
        
        rankLabel1.text = String(rank)
        nameLabel1.text = namesForBAC?[index]
        bacLabel1.text = sortedBACs?[index]
        
        setColors(rank: rank, rLabel: rankLabel1, nLabel: nameLabel1, bLabel: bacLabel1)
        
        index += 1
        
        //Position 2
        if(sortedBACs?[index] != " " && sortedBACs?[index] != sortedBACs?[index - 1]) {
            rank += 1;
        }
        
        if(sortedBACs?[index] != " ") {
            rankLabel2.text = String(rank)
            nameLabel2.text = namesForBAC?[index]
            bacLabel2.text = sortedBACs?[index]
            setColors(rank: rank, rLabel: rankLabel2, nLabel: nameLabel2, bLabel: bacLabel2)
        }
        
        index += 1
        
        //Position 3
        if(sortedBACs?[index] != " " && sortedBACs?[index] != sortedBACs?[index - 1]) {
            rank += 1;
        }
        
        if(sortedBACs?[index] != " ") {
            rankLabel3.text = String(rank)
            nameLabel3.text = namesForBAC?[index]
            bacLabel3.text = sortedBACs?[index]
            setColors(rank: rank, rLabel: rankLabel3, nLabel: nameLabel3, bLabel: bacLabel3)
        }
        
        index += 1
        
        //Position 4
        if(sortedBACs?[index] != " " && sortedBACs?[index] != sortedBACs?[index - 1]) {
            rank += 1;
        }

        if(sortedBACs?[index] != " ") {
            rankLabel4.text = String(rank)
            nameLabel4.text = namesForBAC?[index]
            bacLabel4.text = sortedBACs?[index]
            setColors(rank: rank, rLabel: rankLabel4, nLabel: nameLabel4, bLabel: bacLabel4)
        }
        
        index += 1
        
        //Position 5
        if(sortedBACs?[index] != " " && sortedBACs?[index] != sortedBACs?[index - 1]) {
            rank += 1;
        }

        if(sortedBACs?[index] != " ") {
            rankLabel5.text = String(rank)
            nameLabel5.text = namesForBAC?[index]
            bacLabel5.text = sortedBACs?[index]
            setColors(rank: rank, rLabel: rankLabel5, nLabel: nameLabel5, bLabel: bacLabel5)
        }
        
    }
    
    func addDesignatedDrivers() {
        
        if((designatedDriversNames?.count)! < 4) {
            while ((designatedDriversNames?.count)! < 4) {
                designatedDriversNames?.append(" ")
            }
        }
        
        var index:Int = 0;
        
        //Position 1
        ddNameLabel1.text = designatedDriversNames?[index]
        index += 1
        
        //Position 2
        ddNameLabel2.text = designatedDriversNames?[index]
        index += 1

        //Position 3
        ddNameLabel3.text = designatedDriversNames?[index]
        index += 1
        
        //Position 4
        ddNameLabel4.text = designatedDriversNames?[index]
        
    }
    
    func setColors(rank:Int, rLabel:UILabel, nLabel:UILabel, bLabel:UILabel) {
        
        if(rank == 1) {
            rLabel.textColor = gold
            nLabel.textColor = gold
            bLabel.textColor = gold
        }
        else if(rank == 2) {
            rLabel.textColor = silver
            nLabel.textColor = silver
            bLabel.textColor = silver
            
        }
        else if(rank == 3) {
            rLabel.textColor = bronze
            nLabel.textColor = bronze
            bLabel.textColor = bronze
            
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
