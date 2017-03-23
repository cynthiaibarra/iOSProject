//
//  AddFriendTableViewController.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 3/23/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class AddFriendTableViewController: UITableViewController {
    
    private let databaseRef:FIRDatabaseReference! = FIRDatabase.database().reference().child("users")
    private var currentUserFriends:[String: Any]? = nil
    private var currentUserSentRequests:[String: Any]? = nil
    private var currentUserReceivedReqeusts:[String:Any]? = nil
    private var users:[[String:Any]] = []
    private var usersByName:[String:Any] = [String:Any]()
    private var usersByEmail:[String:Any] = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef.queryOrdered(byChild: "fullName").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                if let userDictionary = snapshot.value as? [String:Any] {
                    for userEntry in userDictionary.values {
                        if let user = userEntry as? [String:Any] {
                            let email:String = user["email"] as! String
                            if email == FIRAuth.auth()?.currentUser?.email {
                                self.currentUserFriends = user["friends"] as? [String:Any]
                                self.currentUserSentRequests = user["sentRequests"] as? [String:Any]
                                self.currentUserReceivedReqeusts = user["receivedRequests"] as? [String:Any]
                            } else {
                                let fullName:String = user["fullName"] as! String
                                self.users.append(user)
                                self.usersByName[fullName] = user
                                self.usersByEmail[email] = user
                            }
                        }
                    }
                }

            }
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70;
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as!AddFriendTableViewCell
        let user:[String:Any] = users[indexPath.row]
        cell.nameLabel.text = (user["fullName"] as! String)
        

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
