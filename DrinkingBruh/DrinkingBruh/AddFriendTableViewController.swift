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

class AddFriendTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let databaseRef:FIRDatabaseReference! = FIRDatabase.database().reference().child("users")
    private var currentUserFriends:[String: Any]? = nil
    private var currentUserSentRequests:[String: Any]? = nil
    private var currentUserReceivedRequests:[String:Any]? = nil
    private var users:[[String:Any]] = []
    
    
    // Search functionality
    private var searching:Bool = false
    var friendSearchResults:[[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsersFromDatabase()
        searchBar.delegate = self
        
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
        if searching {
            print(friendSearchResults.count)
            return friendSearchResults.count
        }
        print(users.count)
        return users.count
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as!AddFriendTableViewCell
        var user:[String:Any] = [:]
        if searching {
            user = friendSearchResults[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        let emailKey:String = (user["email"] as! String).replacingOccurrences(of: ".", with: "\\_")
        let fullName:String = user["fullName"] as! String

        cell.nameLabel.text = fullName
        cell.friends = isFriend(email: emailKey)
        cell.requestSent = sentRequestAlready(email: emailKey)
        cell.requestReceived = requestReceivedAlready(email: emailKey)
        cell.userEmail = (FIRAuth.auth()?.currentUser?.email?.replacingOccurrences(of: ".", with: "\\_"))!
        cell.friendEmail = emailKey
        
        updateButtonUI(cell: cell, friends: cell.friends, sentRequestTo: cell.requestSent, receivedRequestFrom: cell.requestReceived)

        return cell
    }
    
    private func isFriend(email: String) -> Bool {
        if currentUserFriends != nil {
            return currentUserFriends![email] != nil
        }
        return false
    }
    
    private func sentRequestAlready(email: String) -> Bool {
        if currentUserSentRequests != nil {
            return currentUserSentRequests![email] != nil
        }
        return false
    }
    
    private func requestReceivedAlready(email: String) -> Bool {
        if currentUserReceivedRequests != nil {
            return currentUserReceivedRequests![email] != nil
        }
        return false
    }
    
    private func updateButtonUI(cell: AddFriendTableViewCell, friends: Bool, sentRequestTo: Bool, receivedRequestFrom: Bool) {
        if friends {
            cell.button.setTitle("Friends", for: .normal)
            cell.button.isEnabled = false
        } else if sentRequestTo {
            cell.button.setTitle("Request Sent", for: .normal)
            cell.button.backgroundColor = UIColor.lightGray
            cell.button.isEnabled = false
        } else if receivedRequestFrom {
            print("Received request")
//            cell.button.backgroundColor = UIColor.green
//            cell.button.setTitle("Add Friend", for: .normal)
        }
        
    }
    
    private func getUsersFromDatabase() {
        databaseRef.queryOrdered(byChild: "fullName").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                if let userDictionary = snapshot.value as? [String:Any] {
                    for userEntry in userDictionary.values {
                        if let user = userEntry as? [String:Any] {
                            let email:String = user["email"] as! String
                            if email == FIRAuth.auth()?.currentUser?.email {
                                self.currentUserFriends = user["friends"] as? [String:Any]
                                self.currentUserSentRequests = user["sentFriendRequests"] as? [String:Any]
                                self.currentUserReceivedRequests = user["friendRequests"] as? [String:Any]
                            } else {
                                self.users.append(user)
                                self.tableView.insertRows(at: [IndexPath(row: self.users.count - 1, section: 0)], with: .automatic)
                            }
                        }
                    }
                }
                
            }
            
        })
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searching = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searching = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false;
        searchBar.text = nil
        searchBar.endEditing(true)
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searching = false;
    }
    
   func searchBar(_ searchBar: UISearchBar,
                            textDidChange searchText: String) {
    if searchText.isEmpty {
        searching = false
    } else {
        searching = true
        filterContentForSearchText(searchText: searchText)
    }
        self.tableView.reloadData()
        
    }
    
    private func filterContentForSearchText(searchText: String) {
        self.friendSearchResults = self.users.filter({( user: [String:Any]) -> Bool in
            var fieldToSearch: String?
            switch (searchBar.selectedScopeButtonIndex) {
            case (0):
                fieldToSearch = user["fullName"] as! String?
            case (1):
                fieldToSearch = user["email"] as! String?
            default:
                fieldToSearch = nil
            }
            
            if fieldToSearch == nil {
                return false
            }

            return fieldToSearch!.lowercased().range(of: searchText.lowercased()) != nil
        })
    }
}
