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
import MobileCoreServices

enum QuickReply{
    case button(text: String)
    var text: String {
        switch self {
        case .button(text:let text):
            return text
        }
    }
}

final class MessagesViewController: JSQMessagesViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let quickReplyView: QuickReplyView = QuickReplyView.fromNib()
    let chatModel = ChatModel()
    var viewModel: MessageViewModel!
    var collectionViewLayout:QuickReplyCollectionViewLayout!
    let imagePickerController = UIImagePickerController();

    override func viewDidLoad() {

        super.viewDidLoad()
        configureChatCollectionView()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = [String(kUTTypeImage),String(kUTTypeVideo),String(kUTTypeMovie)]
        imagePickerController.modalPresentationStyle = .custom;
        collectionViewLayout = QuickReplyCollectionViewLayout(delegate: self)
        configureQuickReply()
        viewModel = MessageViewModel(delegate: self)
        let plusImage = UIImage(named: "plus")
        let accessoryButton = UIButton(type: .custom)
       // accessoryButton.setBackgroundImage(plusImage, for: .normal)
        accessoryButton.setImage(plusImage, for: .normal)
        accessoryButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        inputToolbar.contentView.leftBarButtonItem = accessoryButton
      // inputToolbar.contentView.leftBarButtonItemWidth
        inputToolbar.contentView.backgroundColor = UIColor.white
        inputToolbar.contentView.textView.placeHolder = "Your message"
        inputToolbar.contentView.textView.layer.borderWidth = 0;
        inputToolbar.contentView.rightBarButtonItem.setTitle("SEND", for: .normal)
        inputToolbar.contentView.rightBarButtonItem.setTitleColor(UIColor.black, for: .normal)
        inputToolbar.contentView.rightBarButtonItemWidth = 60
        addSeparator()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        collectionViewLayout.collectionViewWidth = self.quickReplyView.frame.size.width
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

    func configureChatCollectionView() {
        collectionView.backgroundColor = UIColor.chatBackgroundColor()
       // collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize(width: 40, height: 40)
        collectionView.collectionViewLayout.sectionInset = UIEdgeInsetsMake(10, 5, 10, 0)
        collectionView.typingIndicatorDisplaysOnLeft = true
        collectionView.collectionViewLayout.minimumLineSpacing = 10
        collectionView.reloadData()
    }

    func addSeparator() {
        let sepatarator = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 0.5))
        sepatarator.backgroundColor = UIColor.customPlaceholderColor()
        inputToolbar.contentView.addSubview(sepatarator)
    }

    func configureQuickReply() {

        quickReplyView.collectionView.dataSource = collectionViewLayout
        quickReplyView.collectionView.delegate   = collectionViewLayout
        quickReplyView.collectionView.register(UINib(nibName: String(describing: QuickReplyCell.self), bundle:nil), forCellWithReuseIdentifier:QuickReplyCellReuseIdentifier)
        quickReplyView.isHidden = true
        view.addSubview(quickReplyView)
        quickReplyView.snp.makeConstraints { (make) in
            make.bottom.equalTo(inputToolbar.snp.top).offset(-1)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(QuickReplyViewHeight)
        }
    }

    func showQuickReplyViewWithItems(items: [QuickReply]) {
        collectionViewLayout.items = [QuickReply.button(text:"Tips"),QuickReply.button(text:"Odds"),QuickReply.button(text:"Odds"),QuickReply.button(text:"Odds"),QuickReply.button(text:"Odds"),QuickReply.button(text:"Odds"),QuickReply.button(text:"Tips"),QuickReply.button(text:"Tips"),QuickReply.button(text:"Tips")]
        quickReplyView.reloadData()
        collectionView.collectionViewLayout.sectionInset = UIEdgeInsetsMake(10, 5, QuickReplyViewHeight+10, 5)
        collectionView.collectionViewLayout.invalidateLayout()
//        collectionView.layoutIfNeeded()
        collectionView.reloadData()
        scrollToBottom(animated: false)
        quickReplyView.isHidden = false
    }

    func hideQuickReplyView() {
        quickReplyView.isHidden = true
        collectionView.collectionViewLayout.sectionInset = UIEdgeInsetsMake(10, 5, 10, 9)
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
        scrollToBottom(animated: false)
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
        return nil
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
//        viewModel.send(message: text)
//        //TODO:Place JSQMessage unwrapping into Message extension
//        chatModel.messages.append(JSQMessage(senderId: userID, senderDisplayName: userID, date: Date.distantPast, text: text))
//        self.finishSendingMessage()
   //     collectionView.collectionViewLayout.sectionInset = UIEdgeInsetsMake(25, 20, QuickReplyViewHeight+10, 20)
    //    collectionView.layoutIfNeeded()
        showQuickReplyViewWithItems(items: [])

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

        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
        chatModel.addPhotoMediaMessage(image: image)
        } else if let mediaUrl = info[UIImagePickerControllerMediaURL] as? URL {
            chatModel.addVideoMediaMessage(videoUrl: mediaUrl)
        }
        imagePickerController.dismiss(animated: true, completion: nil)
        self.finishSendingMessage()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionViewLayout.collectionViewWidth = CGFloat(size.width)
        quickReplyView.collectionView.collectionViewLayout.invalidateLayout()
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

extension MessagesViewController: QuickReplyCollectionViewDelegate {

    func didSelectItem(item:QuickReply) {
        chatModel.messages.append(JSQMessage(senderId: userID, senderDisplayName: userID, date: Date.distantPast, text: item.text))
        self.finishSendingMessage()
        hideQuickReplyView()
    }
}

