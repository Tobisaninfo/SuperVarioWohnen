//
//  ForumPostTableViewCell.swift
//  SuperVarioWohnen
//
//  Created by Xen on 20.12.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit

class ForumPostTableViewCell: UITableViewCell {
    
    //MARK Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pinImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
