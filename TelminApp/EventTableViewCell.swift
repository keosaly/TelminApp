//
//  EventTableViewCell.swift
//  TelminApp
//
//  Created by KEOSALY on 10/4/17.
//  Copyright © 2017 KEOSALY. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblActivity: UILabel!
    @IBOutlet weak var lblRemarks: UILabel!
    @IBOutlet weak var lblTimeText: UILabel!
    @IBOutlet weak var lblTimeEvent: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
