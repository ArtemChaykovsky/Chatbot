//
//  Helpers.swift
//  Chatbot
//
//  Created by Anton Dolzhenko on 24.01.17.
//  Copyright © 2017 Onix-Systems. All rights reserved.
//

import UIKit

protocol AlertRenderer {
    func displayMessage(_ title:String,msg:String)
    func displayError(_ error:Error)
}

extension AlertRenderer where Self: UIViewController {
    func displayError(_ error:Error){
        DispatchQueue.main.async {
        self.displayMessage("Error!", msg: error.localizedDescription)
        }
    }
    
    func displayMessage(_ title:String,msg:String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (action) -> Void in
            alertController.dismiss(animated: true, completion:nil)
            //            self.eventHandler.dismiss()
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)

    }
}

public func randomString(length:Int) -> String {
    let charSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    var c = charSet.characters.map { String($0) }
    var s:String = ""
    for _ in (1...length) {
        s.append(c[Int(arc4random()) % c.count])
    }
    return s
}
