//
//  InformationTableViewCell.swift
//  OnTheMap
//
//  Created by Kevin Lu on 6/12/2015.
//  Copyright © 2015 Kevin Lu. All rights reserved.
//

import UIKit

class InformationTableViewCell: UITableViewCell {

    @IBOutlet weak var pinImage: UIImageView!
    @IBOutlet weak var studentName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
