//
//  InviteFriendsTableViewCell.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 4/6/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit

class InviteFriendsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    var eventID:String?
    var friendEmail:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func inviteSent(_ sender: UIButton) {
        DBHandler.inviteFriend(eventID: eventID!, friendEmail: friendEmail!)
        sender.setTitle("Invite Sent", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
