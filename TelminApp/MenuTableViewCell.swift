//
//  MenuTableViewCell.swift
//  TelminApp
//
//  Created by KEOSALY on 9/30/17.
//  Copyright © 2017 KEOSALY. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!

   
    @IBOutlet weak var imgIconMenu: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
