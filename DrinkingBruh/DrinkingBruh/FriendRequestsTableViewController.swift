//
//  FriendRequestsTableViewController.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 3/24/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseStorageUI

class FriendRequestsTableViewController: UITableViewController {

    private var friendRequests:[[String:Any]] = []
    private var userEmail:String = DBHandler.getUserEmail()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
        DBHandler.getFriendRequests(userEmail: userEmail) { (requestEmail) -> () in
            DBHandler.getUserInfo(userEmail: requestEmail) { (user) -> () in
                self.friendRequests.append(user)
                self.tableView.insertRows(at: [IndexPath(row: self.friendRequests.count - 1, section: 0)], with: .automatic)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if friendRequests.count == 0 {
            TableViewHelper.emptyMessage(message: "You have no friend requests at the moment.", viewController: self, tableView: self.tableView)
        }
        return friendRequests.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendRequestCell", for: indexPath) as! FriendRequestTableViewCell
        
        //Get user data
        let friendRequest:[String:Any] = friendRequests[indexPath.row]
        
        cell.nameLabel.text = friendRequest["fullName"]! as? String
        cell.userEmail = self.userEmail
        cell.friendEmail = friendRequest["email"] as? String
        
        let imageID:String? = friendRequest["image"] as? String
        if imageID != nil {
            let reference = FIRStorage.storage().reference().child(imageID!)
            let imageView:UIImageView = cell.userImageView
            let placeholderImage = UIImage(named: "genericUser.png")
            imageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
        } else {
            cell.userImageView.image = UIImage(named: "genericUser")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DBHandler.deleteFriendRequest(userEmail: self.userEmail, friendEmail: (friendRequests[indexPath.row]["email"] as? String)!)
            friendRequests.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70;
    }
    
    func friendRequestAcceptedElsewhere(){
        DBHandler.friendRequestRemovedObserver(userEmail: userEmail) { (requestEmail) -> () in
            print("hereereregargda")
            var index:Int = 0
            for request in self.friendRequests {
                let friendRequestEmail:String = (request["email"] as? String)!
                print(requestEmail)
                print(friendRequestEmail.firebaseSanitize())
                if requestEmail == friendRequestEmail.firebaseSanitize() {
                    print(index)
                    self.friendRequests.remove(at: index)
                    self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                    break
                }
                index += 1
            }
            
        }
    }

}
