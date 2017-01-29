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
    @IBOutlet weak var customImage: UIImageView!
    var imageEnabled = false

    @IBOutlet weak var titleLabelLeadingConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = UIColor.customBlueColor()
        titleLabel.font = UIFont.systemFont(ofSize: QuickReplyCellFontSize)
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.customBlueColor().cgColor
        layer.cornerRadius = self.bounds.height / 2;
        if !imageEnabled {
            titleLabelLeadingConstraint.constant = 15
            customImage.isHidden = true
        } else {
            titleLabelLeadingConstraint.constant = 25
            customImage.isHidden = false
        }
    }



}
