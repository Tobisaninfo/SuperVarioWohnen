//
//  ForumAnswerTableViewCell.swift
//  SuperVarioWohnen
//
//  Created by Ntchouayang Nzeunga, Gires on 12.01.18.
//  Copyright © 2018 Tobias. All rights reserved.
//

import UIKit

class ForumAnswerTableViewCell: UITableViewCell {
    
    //MARK
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
