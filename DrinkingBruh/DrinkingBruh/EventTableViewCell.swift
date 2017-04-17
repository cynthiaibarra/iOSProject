//
//  EventTableViewCell.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 4/6/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit
import MapKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var acceptInviteButton: UIButton!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    
    var id:String?
    var index:Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
