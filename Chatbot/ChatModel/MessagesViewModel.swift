//
//  MessagesViewModel.swift
//  Chatbot
//
//  Created by Anton Dolzhenko on 24.01.17.
//  Copyright © 2017 Onix-Systems. All rights reserved.
//

import Foundation
import ObjectMapper

protocol MessageViewModelDelegate {
    func didConnectedToChannel()
    func didReceive(message:Message)
    func didReceive(error:Error)
}

final class MessageViewModel {

    lazy var messageService = WSService()
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
        messageService.didConnectToChannel = { error in
            if let error = error {
                self.delegate?.didReceive(error: error)
            } else {
                self.delegate?.didConnectedToChannel()
            }
        }
        //disable in production
       // messageService.demoMode = true
    }

    func getChannel() {
        messageService.getChannel()
        delegate?.didConnectedToChannel()
    }
    
    func send(message text:String){
       /* let message = Message(id: "",
                              seq: "",
                              text: text,
                              mediaType:.none,
                              mediaUrl: nil,
                              metadata: [:],
                              channelUuid: "",
                              contactUrn: "",
                              contactUuid: "",
                              channelAddress: "",
                              quickReplies: [])*/

        let dictionary:[String:Any] = ["":""]
        if let message = Mapper<Message>().map(JSON: dictionary) {
            messageService.send(msg: message)
        }
    }
}
