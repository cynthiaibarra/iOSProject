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

    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
//        let userEmail = FIRAuth.auth()?.currentUser?.email?.replacingOccurrences(of: ".", with: "\\_")
//        let userFriendsDB = databaseRef.child(userEmail!).child("friends")
        
//        userFriendsDB.queryOrdered(byChild: "fullName").observeSingleEvent(of: .value, with: { (snapshot) in
//            if snapshot.exists() {
//                if let friendsList = snapshot.value as? [String:String] {
//                    
//                }
//                if let userDictionary = snapshot.value as? [String:Any] {
//                    for userEntry in userDictionary.values {
//                        if let user = userEntry as? [String:Any] {
//                            let email:String = user["email"] as! String
//                            if email == FIRAuth.auth()?.currentUser?.email {
//                                self.currentUserFriends = user["friends"] as? [String:Any]
//                                self.currentUserSentRequests = user["sentFriendRequests"] as? [String:Any]
//                                self.currentUserReceivedRequests = user["friendRequests"] as? [String:Any]
//                            } else {
//                                let fullName:String = user["fullName"] as! String
//                                self.users.append(user)
//                                self.usersByName[fullName] = user
//                                self.usersByEmail[email] = user
//                                self.tableView.insertRows(at: [IndexPath(row: self.users.count - 1, section: 0)], with: .automatic)
//                            }
//                        }
//                    }
//                }
//                
//            }
//            
//        })


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
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    @objc private func segueToAddFriends() {
        performSegue(withIdentifier: "segueToAddFriends", sender: nil)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath)

        // Configure the cell...

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