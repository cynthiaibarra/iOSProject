//
//  FriendRequestTableViewCell.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 3/24/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit

class FriendRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var acceptRequestButton: UIButton!
    
    var userEmail:String?
    var friendEmail:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        acceptRequestButton.layer.cornerRadius = 5
        acceptRequestButton.titleEdgeInsets = UIEdgeInsetsMake(2,2,2,2)
    }
    
    @IBAction func acceptRequestButton(_ sender: UIButton) {
        DBHandler.acceptFriendRequest(userEmail: userEmail!, friendEmail: friendEmail!)
        deleteRequest()
        acceptRequestButton.backgroundColor = UIColor(hex: 0x205691)
        acceptRequestButton.setTitle("Friends", for: .normal)
    }
    
    private func deleteRequest() {
        // Delete email from friend requests list of current user
        DBHandler.deleteFriendRequest(userEmail: userEmail!, friendEmail: friendEmail!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


