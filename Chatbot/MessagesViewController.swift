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

    var quickReplyView: UIView!
    let chatModel = ChatModel()
    lazy var messageService = FRService()
    lazy var quickReplyConfigurator = QuickReplyConfigurator()
    let imagePickerController = UIImagePickerController();
    var quickReplyButtons:[QuickReply] {
        return [QuickReply.button(text:"Tips"),QuickReply.button(text:"Odds"),QuickReply.button(text:"Subscriptions"), QuickReply.button(text:"Human")]
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
        messageService.onMessageReceived = { message in

        }
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

        collectionView.collectionViewLayout.sectionInset = UIEdgeInsetsMake(10, 10, 70, 10)
        collectionView.backgroundColor = UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)

        quickReplyView = UIView(frame: CGRect(x: 0, y: view.frame.size.height-140, width: view.frame.size.width, height: 60))
        quickReplyView.backgroundColor = UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)

        let tips = UIButton(frame: CGRect(x: 10, y: 10, width: 60, height: 30))
        tips.setTitleColor(UIColor(red: 96/255.0, green: 143/255.0, blue: 191/255.0, alpha: 1), for: .normal)
        tips.setTitle("Tips", for: .normal)
        tips.layer.borderWidth = 1
        tips.layer.borderColor = UIColor(red: 96/255.0, green: 143/255.0, blue: 191/255.0, alpha: 1).cgColor
        tips.layer.cornerRadius = 15
        tips.addTarget(self, action: #selector(tipsButtonPressed),for:.touchUpInside)

        let odds = UIButton(frame: CGRect(x: 80, y: 10, width: 75, height: 30))
        odds.setTitleColor(UIColor(red: 96/255.0, green: 143/255.0, blue: 191/255.0, alpha: 1), for: .normal)
        odds.setTitle("Odds", for: .normal)
        odds.layer.borderWidth = 1
        odds.layer.borderColor = UIColor(red: 96/255.0, green: 143/255.0, blue: 191/255.0, alpha: 1).cgColor
        odds.layer.cornerRadius = 15
        odds.addTarget(self, action: #selector(oddsButtonPressed),for:.touchUpInside)

        let subscroptions = UIButton(frame: CGRect(x: 165, y: 10, width: 125, height: 30))
        subscroptions.setTitleColor(UIColor(red: 96/255.0, green: 143/255.0, blue: 191/255.0, alpha: 1), for: .normal)
        subscroptions.setTitle("Subscriptions", for: .normal)
        subscroptions.layer.borderWidth = 1
        subscroptions.layer.borderColor = UIColor(red: 96/255.0, green: 143/255.0, blue: 191/255.0, alpha: 1).cgColor
        subscroptions.layer.cornerRadius = 15

        let human = UIButton(frame: CGRect(x: 300, y: 10, width: 70, height: 30))
        human.setTitleColor(UIColor(red: 96/255.0, green: 143/255.0, blue: 191/255.0, alpha: 1), for: .normal)
        human.setTitle("Human", for: .normal)
        human.layer.borderWidth = 1
        human.layer.borderColor = UIColor(red: 96/255.0, green: 143/255.0, blue: 191/255.0, alpha: 1).cgColor
        human.layer.cornerRadius = 15

        quickReplyView.addSubview(tips)
        quickReplyView.addSubview(odds)
        quickReplyView.addSubview(subscroptions)
        quickReplyView.addSubview(human)

        quickReplyView.translatesAutoresizingMaskIntoConstraints = false
        let trailing = NSLayoutConstraint(item: quickReplyView, attribute: .trailing, relatedBy: .equal, toItem:view, attribute: .trailing, multiplier: 1.0, constant: 0)
        let leading = NSLayoutConstraint(item: quickReplyView, attribute: .leading, relatedBy: .equal, toItem:view, attribute: .leading, multiplier: 1.0, constant: 0)
        let bottom = NSLayoutConstraint(item: quickReplyView, attribute: .bottom, relatedBy: .equal, toItem:inputToolbar, attribute: .top, multiplier: 1.0, constant: 0)
        let width = NSLayoutConstraint(item: quickReplyView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: quickReplyView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)

        view.addSubview(quickReplyView)
        view.addConstraints([trailing,leading,bottom,width,height])

       // let quickReplyView = quickReplyConfigurator.configureQuickReplyView(buttons:quickReplyButtons)

        for button in quickReplyButtons {
            addButtonToQuickReply(title:button.text)
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

