//
//  AddFriendTableViewCell.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 3/23/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddFriendTableViewCell: UITableViewCell {
    
    var friends:Bool = false
    var requestSent:Bool = false
    var requestReceived:Bool = false
    var userEmail:String = ""
    var friendEmail:String = ""
    private let databaseRef:FIRDatabaseReference! = FIRDatabase.database().reference().child("users")

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.layer.cornerRadius = 5
        button.titleEdgeInsets = UIEdgeInsetsMake(2,2,2,2)
        
        
        // Initialization code
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        if !friends && !requestSent && !requestReceived {
            sendFriendRequest()
            button.setTitle("Request Sent", for: .normal)
            button.backgroundColor = UIColor.lightGray
            button.isEnabled = false
        } else if requestReceived && !friends {
            DBHandler.acceptFriendRequest(userEmail: userEmail, friendEmail: friendEmail)
            button.backgroundColor = UIColor(hex: 0x205691)
            button.setTitle("Friends", for: .normal)
            button.isEnabled = false
            print("###################")
            print("Friend Accepted")
        }
    }
    
    private func sendFriendRequest() {
        self.databaseRef.child(friendEmail).child("friendRequests").child(userEmail).setValue(userEmail)
        self.databaseRef.child(userEmail).child("sentFriendRequests").child(friendEmail).setValue(friendEmail)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
