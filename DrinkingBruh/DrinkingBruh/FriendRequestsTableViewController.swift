//
//  FriendRequestsTableViewController.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 3/24/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class FriendRequestsTableViewController: UITableViewController {
    
    private let databaseRef:FIRDatabaseReference! = FIRDatabase.database().reference().child("users")
    private var friendRequestsList:[String:String] = [:]
    private var friendRequests:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        getFriendRequests()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendRequests.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendRequestCell", for: indexPath) as! FriendRequestTableViewCell
        
        //Get user data
        let friendRequestEmail:String = friendRequests[indexPath.row]
        let userDB = databaseRef.child(friendRequestEmail)
        
        userDB.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                print(snapshot.value ?? "meep")
                if let user = snapshot.value as? [String: Any] {
                    cell.nameLabel.text = user["fullName"]! as! String
                }
            }
        })
        
        cell.nameLabel.text = friendRequests[indexPath.row]
        return cell
    }
    
    private func getFriendRequests() {
        let userEmail = FIRAuth.auth()?.currentUser?.email?.replacingOccurrences(of: ".", with: "\\_")
        let userFriendRequestsDB = databaseRef.child(userEmail!).child("friendRequests")
        
        userFriendRequestsDB.queryOrdered(byChild: "fullName").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                if let friendRequests = snapshot.value as? [String:String]{
                    print(friendRequests)
                    self.friendRequestsList = friendRequests
                    for key in friendRequests.keys {
                        self.friendRequests.append(key)
                        self.tableView.insertRows(at: [IndexPath(row: self.friendRequests.count - 1, section: 0)], with: .automatic)
                    }
                }
            }
        })
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70;
    }

}
