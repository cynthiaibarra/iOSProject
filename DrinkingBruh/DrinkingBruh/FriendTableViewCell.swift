//
//  FriendTableViewCell.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 3/24/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
