//
//  GuestTableViewCell.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 4/17/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit

class GuestTableViewCell: UITableViewCell {
 
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
