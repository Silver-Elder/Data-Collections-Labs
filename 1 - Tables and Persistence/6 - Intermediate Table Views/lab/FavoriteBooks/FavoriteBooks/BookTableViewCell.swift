//
//  BookTableViewCell.swift
//  FavoriteBooks
//
//  Created by Sterling Jenkins on 10/21/22.
//

import UIKit

class BookTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func update(with book: Book) {
        titleLabel.text = book.title
        descriptionLabel.text = book.description
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
