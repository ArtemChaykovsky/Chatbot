//
//  QuickReplyCell.swift
//  Chatbot
//
//  Created by Artem Chaykovsky on 1/25/17.
//  Copyright © 2017 Onix-Systems. All rights reserved.
//

import UIKit

class QuickReplyCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = UIColor.customBlueColor()
        titleLabel.font = UIFont.systemFont(ofSize: QuickReplyCellFontSize)
        layer.borderWidth = 1
        layer.borderColor = UIColor.customBlueColor().cgColor
        layer.cornerRadius = self.bounds.height / 2;
    }

}
