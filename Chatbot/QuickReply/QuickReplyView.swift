//
//  QuickReplyView.swift
//  Chatbot
//
//  Created by Artem Chaykovsky on 1/25/17.
//  Copyright © 2017 Onix-Systems. All rights reserved.
//

import UIKit


final class QuickReplyView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    func reloadData() {
        collectionView.reloadData()
    }
}

extension UIView {
    class func fromNib<T : UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
