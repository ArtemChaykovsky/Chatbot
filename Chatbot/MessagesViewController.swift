//
//  ViewController.swift
//  Chatbot
//
//  Created by Artem Chaykovsky on 1/23/17.
//  Copyright © 2017 Onix-Systems. All rights reserved.
//

import UIKit
import JSQMessagesViewController

final class MessagesViewController: JSQMessagesViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let chatModel = ChatModel()
    lazy var messageService = FRService()
    let imagePickerController = UIImagePickerController();

    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize(width: 40, height: 40)
        collectionView.collectionViewLayout.minimumLineSpacing = 10
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.modalPresentationStyle = .custom;
        configureQuickReply()
        messageService.onMessageReceived = { message in
            
        }
    }

    override var senderId: String! {
        get {
            return userID
        }
        set {
            self.senderId = newValue
        }
    }

    override var senderDisplayName: String! {
        get {
            return userName
        }
        set {
            self.senderDisplayName = newValue
        }
    }


    func configureQuickReply() {
        //self.topContentAdditionalInset = 80
    }

//    #pragma mark - UICollectionView DataSource
//
//    - (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//    {
//    return [self.demoData.messages count];
//    }
//
//    - (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//    {
//    /**
//     *  Override point for customizing cells
//     */
//    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
//
//    /**
//     *  Configure almost *anything* on the cell
//     *
//     *  Text colors, label text, label colors, etc.
//     *
//     *
//     *  DO NOT set `cell.textView.font` !
//     *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
//     *
//     *
//     *  DO NOT manipulate cell layout information!
//     *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
//     */
//
//    JSQMessage *msg = [self.demoData.messages objectAtIndex:indexPath.item];
//
//    if (!msg.isMediaMessage) {
//
//    if ([msg.senderId isEqualToString:self.senderId]) {
//    cell.textView.textColor = [UIColor blackColor];
//    }
//    else {
//    cell.textView.textColor = [UIColor whiteColor];
//    }
//
//    cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
//    NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
//    }
//
//    cell.accessoryButton.hidden = ![self shouldShowAccessoryButtonForMessage:msg];
//
//    return cell;
//    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chatModel.messages.count
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageDataForItemAt indexPath: IndexPath) -> JSQMessageData {
        return chatModel.messages[indexPath.item] as JSQMessageData
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAt indexPath: IndexPath) -> JSQMessageBubbleImageDataSource? {
        let message = chatModel.messages[indexPath.item]
        if message.senderId == userID {
            return chatModel.outgoingBubbleImageData
        }
        return chatModel.incomingBubbleImageData
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView, avatarImageDataForItemAt indexPath: IndexPath) -> JSQMessageAvatarImageDataSource? {
       // return [self.demoData.avatars objectForKey:message.senderId];
        let message = chatModel.messages[indexPath.row]
        return chatModel.avatars[message.senderId!]
    }

    override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
//        chat.sendMessage(text) { (result, error) -> () in
//            if let unwrappedError = error {
//                UIHelper.showErrorAlert(CSError.Network(reason: unwrappedError.localizedDescription))
//            }else{
//                DispatchQueue.main.async {
//                    self.finishSendingMessage(animated: true)
//                }
//            }
//        }

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
        //TODO:Place JSQMessage unwrapping into Message extension
        chatModel.messages.append(JSQMessage(senderId: userID, senderDisplayName: userID, date: Date.distantPast, text: text))
        self.finishSendingMessage()

    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as? JSQMessagesCollectionViewCell
        let msg = chatModel.messages[indexPath.item]

        if !msg.isMediaMessage {
            cell?.textView?.dataDetectorTypes = UIDataDetectorTypes.lookupSuggestion
            cell?.textView!.textColor = UIColor.black

            if msg.senderId == userID {
                cell?.textView.textColor = UIColor.white
            } else {
                cell?.textView.textColor = UIColor(red: 48/255.0, green: 48/255.0, blue: 47/255.0, alpha: 1)
            }
        }
        return cell!
    }

    override func didPressAccessoryButton(_ sender: UIButton!) {
        self.present(imagePickerController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        chatModel.addPhotoMediaMessage(image: image)
        imagePickerController.dismiss(animated: true, completion: nil)
        self.finishSendingMessage()
    }

}

