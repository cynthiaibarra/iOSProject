//
//  GuestsTableViewController.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 4/16/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit

class GuestsTableViewController: UITableViewController {
    
    var invitees:[String:String]?
    var attending:[[String:Any]] = []
    var invited:[[String:Any]] = []
    var roles:[String:String] = [:]
    var eventID:String?
    var eventHappening = false
    private var themeDict:[String:UIColor] = Theme.getTheme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set Theme
        self.view.backgroundColor = themeDict["viewColor"]
        
        DBHandler.getInviteeRoles(eventID: eventID!){ (guestRole) -> () in
            self.roles[guestRole["email"]!] = guestRole["role"]
        }
        
        DBHandler.getAllUsers() { (users) -> () in
            for invitee in self.invitees! {
                if !DBHandler.emailIsUsers(entry: invitee.key){
                    if invitee.value == "hosting" || invitee.value == "attending" {
                        let user:[String:Any] = users[invitee.key] as! [String:Any]
                        print(user)
                        self.attending.append(user)
                        self.tableView.insertRows(at: [IndexPath(row: self.attending.count - 1, section: 0)], with: .automatic)
                    } else if invitee.value == "pending" {
                        self.invited.append(users[invitee.key] as! [String:Any])
                        self.tableView.insertRows(at: [IndexPath(row: self.invited.count - 1, section: 1)], with: .automatic)
                    }
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if !eventHappening {
            return 2
        } else {
            return 1
        }
   
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !eventHappening && section == 1{
            return invited.count
        }
        return attending.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !eventHappening && section == 1{
            return "Invited"
        }
        return "Attending"
    }
    
    func tableView (tableView:UITableView , heightForHeaderInSection section:Int)->Float {
        return 70.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GuestTableViewCell
        
        var friendInfo:[String:Any] = [:]
        
        if indexPath.section == 0 {
            friendInfo = attending[indexPath.row]
            let friendEmail:String = friendInfo["email"] as! String!
            cell.roleLabel.text = roles[friendEmail.firebaseSanitize()]
        } else {
            friendInfo = invited[indexPath.row]
            cell.roleLabel.isHidden = true
        }
        
        cell.nameLabel.text = friendInfo["fullName"] as? String
        let imageID:String? = friendInfo["image"] as? String
        if imageID != nil {
            DBHandler.getImage(imageID: imageID!) { (image) -> () in
                cell.userImageView.image = image
            }
        }
        
        return cell
    }
}
