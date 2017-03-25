//
//  FriendsTableViewController.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 3/23/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class FriendsTableViewController: UITableViewController {
    
   // private let userEmail = FIRAuth.auth()?.currentUser?.email?.replacingOccurrences(of: ".", with: "\\_")
    private let databaseRef:FIRDatabaseReference! = FIRDatabase.database().reference().child("users")
    private var friendsList:[String:String] = [:]
    private var userEmail:String = ""
    private var friendEmailList:[String] = []
    private var friends:[[String:Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        userEmail = (FIRAuth.auth()?.currentUser?.email?.replacingOccurrences(of: ".", with: "\\_"))!
        
        let userFriendsDB = databaseRef.child(userEmail).child("friends")
        
        userFriendsDB.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                if let friends = snapshot.value as? [String:String]{
                    print(friends)
                    for key in friends.keys {
                        self.friendEmailList.append(key)
                        self.tableView.insertRows(at: [IndexPath(row: self.friendEmailList.count - 1, section: 0)], with: .automatic)
                    }
                }
            }
        })
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
        return friendEmailList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendTableViewCell
        
        //Get user data
        let friendEmail:String = friendEmailList[indexPath.row]
        let userDB = databaseRef.child(friendEmail)
        
        userDB.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                print(snapshot.value ?? "meep")
                if let user = snapshot.value as? [String: Any] {
                    cell.nameLabel.text = (user["fullName"]! as! String)
                }
            }
        })
        
        cell.nameLabel.text = friendEmailList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70;
    }
}
