//
//  ViewController.swift
//  Chatbot
//
//  Created by Artem Chaykovsky on 1/23/17.
//  Copyright © 2017 Onix-Systems. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import SnapKit
//import PARTagPicker

final class MessagesViewController: JSQMessagesViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var quickReplyViewController: PARTagPickerViewController!
    let chatModel = ChatModel()
    var viewModel: MessageViewModel!
    
    lazy var quickReplyConfigurator = QuickReplyConfigurator()
    let imagePickerController = UIImagePickerController();
//    var quickReplyButtons:[QuickReply] {
//        return [QuickReply.button(text:"Tips"),QuickReply.button(text:"Odds"),QuickReply.button(text:"Subscriptions"), QuickReply.button(text:"Human")]
//    }

    var quickReplyButtons:NSMutableArray {
        return ["Tips","Odds","Subscriptions","Human","Tips","Odds","Subscriptions","Human","Tips","Odds","Subscriptions"]
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize(width: 40, height: 40)
        collectionView.collectionViewLayout.minimumLineSpacing = 10
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.modalPresentationStyle = .custom;
        configureQuickReply()
        viewModel = MessageViewModel(delegate: self)
        
    }

    override var senderId: String! {
        get {
            return userID
        }
        set {

        }
    }

    override var senderDisplayName: String! {
        get {
            return userName
        }
        set {

        }
    }


    func configureQuickReply() {


        quickReplyViewController = PARTagPickerViewController()
        quickReplyViewController.view.backgroundColor = UIColor.white
       // quickReplyViewController.view.frame = CGRect(x: 0, y: view.frame.size.height-140, width: view.frame.size.width, height: 90)
        quickReplyViewController.view.autoresizingMask = .flexibleWidth
        quickReplyViewController.delegate = self
        quickReplyViewController.chosenTags = quickReplyButtons
        quickReplyViewController.visibilityState = .topAndBottom
        quickReplyViewController.textfieldEnabled = false
        quickReplyViewController.tagColorRef.chosenTagBackgroundColor = UIColor.white
        quickReplyViewController.tagColorRef.chosenTagBorderColor = UIColor(red: 96/255.0, green: 143/255.0, blue: 191/255.0, alpha: 1)
        quickReplyViewController.tagColorRef.chosenTagTextColor = UIColor(red: 96/255.0, green: 143/255.0, blue: 191/255.0, alpha: 1)
        addChildViewController(quickReplyViewController)
        view.addSubview(quickReplyViewController.view)
        quickReplyViewController.view.snp.makeConstraints { (make) in
            make.bottom.equalTo(inputToolbar.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(55)
        }
    }

    func addButtonToQuickReply(title:String) {

    }


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
        viewModel.send(message: text)

       
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
                cell?.textView.textColor = UIColor(red: 98/255.0, green: 98/255.0, blue: 98/255.0, alpha: 1)
            } else {
                cell?.textView.textColor = UIColor.white
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

    func tipsButtonPressed() {
        chatModel.messages.append(JSQMessage(senderId: userID, senderDisplayName: userID, date: Date.distantPast, text: "Tips"))
        self.finishSendingMessage()
    }

    func oddsButtonPressed() {
        chatModel.messages.append(JSQMessage(senderId: userID, senderDisplayName: userID, date: Date.distantPast, text: "Odds"))
        self.finishSendingMessage()
    }
}

extension MessagesViewController : PARTagPickerDelegate {
    func tagPicker(_ tagPicker: PARTagPickerViewController!, visibilityChangedTo state: PARTagPickerVisibilityState) {

    }
}

extension MessagesViewController: AlertRenderer { }

extension MessagesViewController: MessageViewModelDelegate {
    
    func didReceive(message: Message) {
        chatModel.messages.append(JSQMessage(senderId: botID, senderDisplayName: botID, date: Date.distantPast, text:message.text))
        self.finishSendingMessage()
    }
    
    func didReceive(error: Error) {
        displayError(error)
    }
}

