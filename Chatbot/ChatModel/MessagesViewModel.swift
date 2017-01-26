//
//  MessagesViewModel.swift
//  Chatbot
//
//  Created by Anton Dolzhenko on 24.01.17.
//  Copyright © 2017 Onix-Systems. All rights reserved.
//

import Foundation

protocol MessageViewModelDelegate {
    func didReceive(message:Message)
    func didReceive(error:Error)
}

final class MessageViewModel {
    lazy var messageService = FRService()
    var delegate:MessageViewModelDelegate?
    
    init(delegate:MessageViewModelDelegate){
        self.delegate = delegate
        messageService.onMessageReceived = { result in
            switch result {
            case .success(let message):
                self.delegate?.didReceive(message: message)
            case .error(let error):
                self.delegate?.didReceive(error: error)
            }
        }
        //disable in production
       // messageService.demoMode = true
    }
    
    func send(message text:String){
        let message = Message(id: "",
                              seq: "",
                              text: text,
                              mediaType:.none,
                              mediaUrl: nil,
                              metadata: [:],
                              channelUuid: "",
                              contactUrn: "",
                              contactUuid: "",
                              channelAddress: "")
        messageService.send(msg: message)
    }
}
