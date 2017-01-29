//
//  ChatModel.swift
//  Chatbot
//
//  Created by Artem Chaykovsky on 1/23/17.
//  Copyright © 2017 Onix-Systems. All rights reserved.
//

import UIKit
import JSQMessagesViewController

let userID   = "053496-4509-289"
let botID    = "468-768355-23123"
let userName = "Username"
let kJSQMessagesCollectionViewAvatarSizeDefault = UInt(30)


final class ChatModel: NSObject {

    var messages:[JSQMessage]! = []
    var avatars:[String:JSQMessagesAvatarImage]! = [:]
    var incomingBubbleImageData:JSQMessagesBubbleImage!
    var outgoingBubbleImageData:JSQMessagesBubbleImage!
    let bubbleFactory = JSQMessagesBubbleImageFactory(bubble: UIImage.jsq_bubbleCompactTailless(), capInsets:UIEdgeInsets.zero)
    let avatarFactory = JSQMessagesAvatarImageFactory()

    override init(){
        super.init()
        loadFakeMessages()
    }
    func loadFakeMessages() {

        let photoItem = JSQPhotoMediaItem(image: UIImage(named:"goldengate"))
        photoItem!.appliesMediaViewMaskAsOutgoing = false
        let photoMessage = JSQMessage(senderId: botID, displayName: botID, media:photoItem)
        messages.append(photoMessage!)
        messages.append(JSQMessage(senderId: botID, senderDisplayName: userID, date: Date.distantPast, text: "You're all caught up for today!\nI can give you tips and odds for all of todays races. Just let me know what you need."))
         messages.append(JSQMessage(senderId: botID, senderDisplayName: userID, date: Date.distantPast, text: "You're all caught up for today!\nI can give you tips and odds for all of todays races. Just let me know what you need."))
        messages.append(JSQMessage(senderId: botID, senderDisplayName: userID, date: Date.distantPast, text: "You're all caught up for today!\nI can give you tips and odds for all of todays races. Just let me know what you need."))
        messages.append(JSQMessage(senderId: botID, senderDisplayName: userID, date: Date.distantPast, text: "You're all caught up for today!\nI can give you tips and odds for all of todays races. Just let me know what you need."))
        self.incomingBubbleImageData = bubbleFactory?.incomingMessagesBubbleImage(with: UIColor(red: 96.0/255.0, green: 143.0/255.0, blue: 191.0/255.0, alpha: 1.0))
        self.outgoingBubbleImageData = bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.customGreyColor())
        let botAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named:"BotImage"), diameter:kJSQMessagesCollectionViewAvatarSizeDefault)
        if let unwrappedImage = botAvatar {
        avatars = [botID : unwrappedImage]
        }
    }

    func addPhotoMediaMessage(image:UIImage) {
        let photoItem = JSQPhotoMediaItem(image: image)
       // photoItem!.appliesMediaViewMaskAsOutgoing = false
        let photoMessage = JSQMessage(senderId: userID, displayName: userID, media:photoItem)
        messages.append(photoMessage!)
    }

    func addVideoMediaMessage(videoUrl:URL) {
        let videoItem = JSQVideoMediaItem(fileURL: videoUrl, isReadyToPlay: false)
        // photoItem!.appliesMediaViewMaskAsOutgoing = false
        let videoMessage = JSQMessage(senderId: userID, displayName: userID, media:videoItem)
        messages.append(videoMessage!)
    }
}
