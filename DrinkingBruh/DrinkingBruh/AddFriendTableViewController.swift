//
//  AddFriendTableViewController.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 3/23/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseStorageUI

class AddFriendTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var currentUserFriends:[String: Any] = [:]
    private var currentUserSentRequests:[String: Any] = [:]
    private var currentUserReceivedRequests:[String:Any] = [:]
    private var users:[[String:Any]] = []
    private var themeDict:[String:UIColor] = Theme.getTheme()
    
    // Search functionality
    private var searching:Bool = false
    var friendSearchResults:[[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set Theme
        self.view.backgroundColor = themeDict["viewColor"]
        
        //Disable tableView Cell Selection
        self.tableView.allowsSelection = false
        
        searchBar.delegate = self
        tableView.separatorStyle = .none;
        
        let email:String = DBHandler.getUserEmail()
        
        DBHandler.getFriends(userEmail: email) { (user) -> () in
            self.currentUserFriends[user] = user
        }
        
        DBHandler.getFriendRequests(userEmail: email) { (user) -> () in
            self.currentUserReceivedRequests[user] = user
        }
        
        DBHandler.getSentFriendRequests(userEmail: email) { (user) -> () in
            self.currentUserSentRequests[user] = user
        }
        
        DBHandler.getAllUsers() { (userDictionary) -> () in
            for user in userDictionary {
                if user.key != email.replacingOccurrences(of: ".", with: "\\_") {
                    self.users.append(user.value as! [String : Any])
                    self.tableView.insertRows(at: [IndexPath(row: self.users.count - 1, section: 0)], with: .automatic)
                }

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
        if searching {
            return friendSearchResults.count
        }
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
        
        //Set theme for Label
        cell.nameLabel.textColor = themeDict["textColor"]

        cell.nameLabel.text = user["fullName"] as? String
        cell.friends = isFriend(email: emailKey)
        cell.requestSent = sentRequestAlready(email: emailKey)
        cell.requestReceived = requestReceivedAlready(email: emailKey)
        cell.userEmail = DBHandler.getUserEmail()
        cell.friendEmail = user["email"] as! String
        
        let imageID:String? = user["image"] as? String
        if imageID != nil {
            let reference = FIRStorage.storage().reference().child(imageID!)
            let imageView:UIImageView = cell.userImageView
            let placeholderImage = UIImage(named: "genericUser")
            imageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
        } else {
            cell.userImageView.image = UIImage(named: "genericUser")
        }
        
        updateButtonUI(cell: cell, friends: cell.friends, sentRequestTo: cell.requestSent, receivedRequestFrom: cell.requestReceived)

        return cell
    }
    
    private func isFriend(email: String) -> Bool {
        if currentUserFriends[email] != nil {
            return currentUserFriends[email] != nil
        }
        return false
    }
    
    private func sentRequestAlready(email: String) -> Bool {
        if currentUserSentRequests[email] != nil {
            return currentUserSentRequests[email] != nil
        }
        return false
    }
    
    private func requestReceivedAlready(email: String) -> Bool {
        if currentUserReceivedRequests[email] != nil {
            return currentUserReceivedRequests[email] != nil
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
            cell.button.backgroundColor = UIColor(hex: 0x4ACE36)
            cell.button.setTitle("Accept Request", for: .normal)
        }
        
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        //cell.layer.borderWidth = 2.0
        //cell.layer.borderColor = themeDict["viewColor"]?.cgColor
    }

}
