//
//  MenuTableViewCell.swift
//  Restaurant
//
//  Created by Sterling Jenkins on 12/8/22.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuPhoto: UIImageView!
    @IBOutlet weak var menuItemTitle: UILabel!
    @IBOutlet weak var menuItemDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
