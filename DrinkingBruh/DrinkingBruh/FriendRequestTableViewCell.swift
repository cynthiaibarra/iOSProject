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
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func acceptRequestButton(_ sender: UIButton) {
        
    }
    
    @IBAction func deleteRequestButton(_ sender: UIButton) {
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
