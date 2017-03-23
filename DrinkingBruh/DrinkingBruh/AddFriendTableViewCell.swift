//
//  AddFriendTableViewCell.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 3/23/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit

class AddFriendTableViewCell: UITableViewCell {

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
        print("button pressed")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
