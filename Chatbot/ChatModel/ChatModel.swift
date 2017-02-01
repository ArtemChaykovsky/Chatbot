//
//  ChatModel.swift
//  Chatbot
//
//  Created by Artem Chaykovsky on 1/23/17.
//  Copyright © 2017 Onix-Systems. All rights reserved.
//

import UIKit
import JSQMessagesViewController

let userID   = "userID"
let botID    = "botID"
let userName = "Username"
let kJSQMessagesCollectionViewAvatarSizeDefault = UInt(30)


final class ChatModel: NSObject {

    var messages:[JSQInfoMessage]! = []
    var avatars:[String:JSQMessagesAvatarImage]! = [:]
    var incomingBubbleImageData:JSQMessagesBubbleImage!
    var outgoingBubbleImageData:JSQMessagesBubbleImage!
    let bubbleFactory = JSQMessagesBubbleImageFactory(bubble: UIImage.jsq_bubbleCompactTailless(), capInsets:UIEdgeInsets.zero)
    let avatarFactory = JSQMessagesAvatarImageFactory()

    override init(){
        super.init()
        //loadFakeMessages()
        self.incomingBubbleImageData = bubbleFactory?.incomingMessagesBubbleImage(with: UIColor(red: 96.0/255.0, green: 143.0/255.0, blue: 191.0/255.0, alpha: 1.0))
        self.outgoingBubbleImageData = bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.customGreyColor())
    }
    func loadFakeMessages() {

        let photoItem = JSQPhotoMediaItem(image: UIImage(named:"goldengate"))
        photoItem!.appliesMediaViewMaskAsOutgoing = false
        let photoMessage = JSQInfoMessage(senderId: botID, displayName: botID, media:photoItem)
        messages.append(photoMessage!)
        messages.append(JSQInfoMessage(senderId: botID, senderDisplayName: userID, date: Date.distantPast, text: "You're all caught up for today!\nI can give you tips and odds for all of todays races. Just let me know what you need."))
         messages.append(JSQInfoMessage(senderId: botID, senderDisplayName: userID, date: Date.distantPast, text: "You're all caught up for today!\nI can give you tips and odds for all of todays races. Just let me know what you need."))
        messages.append(JSQInfoMessage(senderId: botID, senderDisplayName: userID, date: Date.distantPast, text: "You're all caught up for today!\nI can give you tips and odds for all of todays races. Just let me know what you need."))
        messages.append(JSQInfoMessage(senderId: botID, senderDisplayName: userID, date: Date.distantPast, text: "You're all caught up for today!\nI can give you tips and odds for all of todays races. Just let me know what you need."))
        self.incomingBubbleImageData = bubbleFactory?.incomingMessagesBubbleImage(with: UIColor(red: 96.0/255.0, green: 143.0/255.0, blue: 191.0/255.0, alpha: 1.0))
        self.outgoingBubbleImageData = bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.customGreyColor())
    }

    func addPhotoMediaMessage(image:UIImage) {
        let photoItem = JSQPhotoMediaItem(image: image)
       // photoItem!.appliesMediaViewMaskAsOutgoing = false
        let photoMessage = JSQInfoMessage(senderId: userID, displayName: userID, media:photoItem)
        messages.append(photoMessage!)
    }

    func addVideoMediaMessage(videoUrl:URL) {
        let videoItem = JSQVideoMediaItem(fileURL: videoUrl, isReadyToPlay: false)
        // photoItem!.appliesMediaViewMaskAsOutgoing = false
        let videoMessage = JSQInfoMessage(senderId: userID, displayName: userID, media:videoItem)
        messages.append(videoMessage!)
    }
}
