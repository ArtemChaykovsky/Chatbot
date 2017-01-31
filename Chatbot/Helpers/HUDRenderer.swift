//
//  HUDRenderer.swift
//  TipTap
//
//  Created by Artem Chaykovsky on 1/31/17.
//  Copyright © 2017 Onix-Systems. All rights reserved.
//

import MBProgressHUD

protocol HUDRenderer {
    func showHUD()
    func hideHUD()
}

extension HUDRenderer where Self: UIViewController {

    func showHUD() {
        MBProgressHUD.showAdded(to: view, animated: true)
    }

    func hideHUD() {
        MBProgressHUD.hide(for: view, animated: true)
    }
}
