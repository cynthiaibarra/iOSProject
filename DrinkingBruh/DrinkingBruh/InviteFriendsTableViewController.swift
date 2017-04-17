//
//  InviteFriendsTableViewController.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 4/6/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit
import FirebaseAuth

class InviteFriendsTableViewController: UITableViewController {

    private var friends:[[String:Any]] = []
    var eventID:String!
    var invitees:[String:String]?
    var edit:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(InviteFriendsTableViewController.performSegueToEvents))
        let userEmail:String = (FIRAuth.auth()?.currentUser?.email)!
        DBHandler.getFriends(userEmail: userEmail) { (friend) -> () in
            if (self.edit && self.invitees?[friend] == nil) || !self.edit {
                DBHandler.getUserInfo(userEmail: friend) { (friendInfo) -> () in
                    self.friends.append(friendInfo)
                    self.tableView.insertRows(at: [IndexPath(row: self.friends.count - 1, section: 0)], with: .automatic)
                }
            }
        }
        
        DBHandler.setHost(eventID: eventID)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! InviteFriendsTableViewCell
        let friend = friends[indexPath.row]
        
        cell.nameLabel.text = friend["fullName"] as? String
        cell.friendEmail = friend["email"] as? String
        cell.eventID = eventID
        
        let imageID = friend["image"]
        if imageID != nil {
            DBHandler.getImage(imageID: imageID as! String) { (image) -> () in
                cell.userImageView.image = image
            }
        }

        return cell
    }
    
    @objc private func performSegueToEvents() {
        performSegue(withIdentifier: "segueToEvents", sender: nil)
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
    func performSegueToHome () {
        performSegue(withIdentifier: "segueToHome", sender: nil)
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Home"
        backItem.target = self
        backItem.action = #selector(InviteFriendsTableViewController.performSegueToHome)
        navigationItem.backBarButtonItem = backItem
        // This will show in the next view controller being pushed
    } */

}
