//
//  FriendRequestTableViewCell.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 3/24/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FriendRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var acceptRequestButton: UIButton!
    
    var userEmail:String?
    var friendEmail:String?
    private let databaseRef:FIRDatabaseReference! = FIRDatabase.database().reference().child("users")

    
    override func awakeFromNib() {
        super.awakeFromNib()
        acceptRequestButton.layer.cornerRadius = 5
        acceptRequestButton.titleEdgeInsets = UIEdgeInsetsMake(2,2,2,2)
    }
    
    @IBAction func acceptRequestButton(_ sender: UIButton) {
        if friendEmail != nil && userEmail  != nil {
            self.databaseRef.child(friendEmail!).child("friends").child(userEmail!).setValue(userEmail)
            self.databaseRef.child(userEmail!).child("friends").child(friendEmail!).setValue(friendEmail)
        }
        deleteRequest()
        acceptRequestButton.backgroundColor = UIColor(hex: 0x205691)
        acceptRequestButton.setTitle("Friends", for: .normal)
    }
    
    private func deleteRequest() {
        // Delete email from friend requests list of current user
        databaseRef.child(userEmail!).child("friendRequests").child(friendEmail!).removeValue { (error, ref) in
            if error != nil {
                print("error \(error)")
            }
        }
        
        // Delete the current user's email from the other user's sent friend requests list
        databaseRef.child(friendEmail!).child("sentFriendRequests").child(userEmail!).removeValue { (error, ref) in
            if error != nil {
                print("error \(error)")
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

public extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex:Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
}
