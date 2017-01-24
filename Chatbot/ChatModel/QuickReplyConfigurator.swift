//
//  QuickReplyViewConfigurator.swift
//  Chatbot
//
//  Created by Artem Chaykovsky on 1/24/17.
//  Copyright © 2017 Onix-Systems. All rights reserved.
//

import UIKit

enum QuickReply{
    case button(text: String)
    var text: String {
        switch self {
        case .button(text:let text):
            return text
        }
    }
}

struct QuickReplyConfigurator {
    func configureQuickReplyView(buttons:[QuickReply]) -> UIView {
        return UIView()
    }
}
