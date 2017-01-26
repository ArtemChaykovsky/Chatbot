//
//  QuickReplyViewConfigurator.swift
//  Chatbot
//
//  Created by Artem Chaykovsky on 1/24/17.
//  Copyright © 2017 Onix-Systems. All rights reserved.
//

import UIKit

let QuickReplyViewHeight: CGFloat = 50
let QuickReplyCellFontSize: CGFloat = 16
let QuickReplyCellReuseIdentifier = "QuickReplyCellReuseIdentifier"


protocol QuickReplyCollectionViewDelegate{
    func didSelectItem(item:QuickReply)
}

class QuickReplyCollectionViewLayout: NSObject {

    required init(delegate:QuickReplyCollectionViewDelegate) {
        self.delegate = delegate
    }

    var items:[QuickReply] = []
    var delegate:QuickReplyCollectionViewDelegate?

}

extension QuickReplyCollectionViewLayout: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuickReplyCellReuseIdentifier, for: indexPath) as! QuickReplyCell
        cell.titleLabel.text = item.text
        return cell
    }
}

extension QuickReplyCollectionViewLayout: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizingCell: QuickReplyCell = QuickReplyCell.fromNib()
        let item = items[indexPath.row]
        sizingCell.titleLabel.text = item.text
        sizingCell.titleLabel.font = UIFont.systemFont(ofSize: QuickReplyCellFontSize)
        let size = sizingCell.systemLayoutSizeFitting(CGSize(width: collectionView.contentSize.width, height:QuickReplyViewHeight-20), withHorizontalFittingPriority: UILayoutPriorityDefaultLow, verticalFittingPriority: UILayoutPriorityDefaultHigh)
        return size
    }
}

extension QuickReplyCollectionViewLayout: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        delegate?.didSelectItem(item: item)
    }
}

extension UIColor {
    class func customBlueColor() -> UIColor {
        return UIColor(red: 96/255.0, green: 143/255.0, blue: 191/255.0, alpha: 1)
    }
    class func customGreyColor() -> UIColor {
        return UIColor(red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1)
    }
    class func chatBackgroundColor() -> UIColor {
        return UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
    }
}
