//
//  QuickReplyViewConfigurator.swift
//  Chatbot
//
//  Created by Artem Chaykovsky on 1/24/17.
//  Copyright © 2017 Onix-Systems. All rights reserved.
//

import UIKit

let QuickReplyViewHeight: CGFloat          = 63
let QuickReplyCellFontSize: CGFloat        = 13
let CollectionViewDefaultInset: CGFloat    = 40
let QuickReplyCellReuseIdentifier          = "QuickReplyCellReuseIdentifier"


protocol QuickReplyCollectionViewDelegate{
    func didSelectItem(item:QuickReply)
}

class QuickReplyCollectionViewLayout: NSObject {

    required init(delegate:QuickReplyCollectionViewDelegate) {
        self.delegate = delegate
    }

    var items:[QuickReply] = []
    var delegate:QuickReplyCollectionViewDelegate?
    var collectionViewCustomInset:CGFloat = 0
    var collectionViewWidth:CGFloat!
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
        if indexPath.row == 0 {
            collectionViewCustomInset = 0
        }
        let sizingCell: QuickReplyCell = QuickReplyCell.fromNib()
        let item = items[indexPath.row]
        sizingCell.titleLabel.text = item.text
        sizingCell.titleLabel.font = UIFont.systemFont(ofSize: QuickReplyCellFontSize)
        let size = sizingCell.systemLayoutSizeFitting(CGSize(width: collectionView.contentSize.width, height:QuickReplyViewHeight-20), withHorizontalFittingPriority: UILayoutPriorityDefaultLow, verticalFittingPriority: UILayoutPriorityDefaultHigh)
        collectionViewCustomInset += size.width
        return size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

      //  if (collectionView.superview!.frame.size.width > collectionViewCustomInset) {

            collectionView.contentOffset = CGPoint.zero
            if items.count > 1 {
                let insets: CGFloat = CGFloat(items.count-1)*10
                collectionViewCustomInset += (insets)
            }

        if collectionViewCustomInset > collectionViewWidth-CollectionViewDefaultInset*2 {
                collectionView.isScrollEnabled = true
                return UIEdgeInsets(top: 0, left: CollectionViewDefaultInset, bottom: 0, right: CollectionViewDefaultInset)
            } else{

            let offset = collectionViewWidth - collectionViewCustomInset
            collectionView.isScrollEnabled = false
            return UIEdgeInsets(top: 0, left: offset/2, bottom: 0, right: offset/2)
            }

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
    class func customPlaceholderColor() -> UIColor {
        return UIColor(red: 253/255.0, green: 253/255.0, blue: 253/255.0, alpha: 1)
    }
}
