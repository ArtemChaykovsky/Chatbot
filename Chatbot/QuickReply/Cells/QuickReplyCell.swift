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

    @IBOutlet weak var titleLabelLeadingConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = UIColor.customBlueColor()
        titleLabel.font = UIFont.systemFont(ofSize: QuickReplyCellFontSize)
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.customBlueColor().cgColor
        layer.cornerRadius = self.bounds.height / 2.7;
    }

    func setData(title:String,image:UIImage?) {
        titleLabel.text = title
        if let unwrappedImage = image {
            customImage.image = unwrappedImage
            titleLabelLeadingConstraint.constant = 45
            customImage.isHidden = false
        } else {
            customImage.isHidden = true
            titleLabelLeadingConstraint.constant = 20
            customImage.image = nil
        }
    }

}
