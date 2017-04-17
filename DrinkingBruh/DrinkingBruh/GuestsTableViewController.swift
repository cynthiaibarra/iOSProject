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
      
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return attending.count
        } else {
            return invited.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Attending"
        } else {
            return "Invited"
        }
    }
    
    func tableView (tableView:UITableView , heightForHeaderInSection section:Int)->Float {
        return 70.0
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GuestTableViewCell
        
        var friendInfo:[String:Any] = [:]
        
        if indexPath.section == 0 {
            friendInfo = attending[indexPath.row]
        } else {
            friendInfo = invited[indexPath.row]
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


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
