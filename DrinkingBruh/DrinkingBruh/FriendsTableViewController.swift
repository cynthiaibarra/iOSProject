//
//  FriendsTableViewController.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 3/23/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit
import FirebaseAuth

class FriendsTableViewController: UITableViewController {
    
    private var friends:[[String:Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let userEmail:String = (FIRAuth.auth()?.currentUser?.email!)!
        DBHandler.getFriends(userEmail: userEmail) { (friend) -> () in
            DBHandler.getUserInfo(userEmail: friend) { (friendInfo) -> () in
                self.friends.append(friendInfo)
                self.tableView.insertRows(at: [IndexPath(row: self.friends.count - 1, section: 0)], with: .automatic)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friends.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendTableViewCell
        
        //Get user data
        let friend:[String:Any] = friends[indexPath.row]
        cell.nameLabel.text = friend["fullName"] as? String
        let imageID = friend["image"]
        if imageID != nil {
            DBHandler.getImage(imageID: imageID as! String) { (image) -> () in
                cell.userImageView.image = image
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70;
    }
}
