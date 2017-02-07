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
import FLAnimatedImage


final class MessagesViewController: JSQMessagesViewController, UINavigationControllerDelegate {

    let quickReplyView: QuickReplyView = QuickReplyView.fromNib()
    let chatModel = ChatModel()
    var viewModel: MessageViewModel!
    var collectionViewLayout:QuickReplyCollectionViewLayout!
    var imagePickerController: UIImagePickerController!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewModel = MessageViewModel(delegate: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureChatCollectionView()
        configureQuickReply()
        configureInputToolbar()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showHUD()
        viewModel.getChannel()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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

    //MARK: Configure layout

    private func configureChatCollectionView() {

        collectionViewLayout = QuickReplyCollectionViewLayout(delegate: self)
        collectionView.backgroundColor = UIColor.chatBackgroundColor()
        collectionView.collectionViewLayout.sectionInset = UIEdgeInsetsMake(20, -15, 13, -20)
        collectionView.collectionViewLayout.minimumLineSpacing = CollectionViewDefaultSpacing
    }

    private func configureInputToolbar() {

        let plusImage = UIImage(named: "plus")
        let accessoryButton = UIButton(type: .custom)
        accessoryButton.frame.size = CGSize(width: 30, height: 30)
        accessoryButton.setBackgroundImage(plusImage, for: .normal)
        inputToolbar.contentView.leftBarButtonItem = accessoryButton
        inputToolbar.contentView.leftBarButtonItem.isHidden = true
        inputToolbar.contentView.backgroundColor = UIColor.white
        inputToolbar.contentView.textView.placeHolder = "Your message"
        inputToolbar.contentView.textView.autocorrectionType = .no;
        inputToolbar.contentView.textView.layer.borderWidth = 0;
        inputToolbar.contentView.rightBarButtonItem.setTitle("SEND", for: .normal)
        inputToolbar.contentView.rightBarButtonItem.setTitleColor(UIColor.black, for: .normal)
        inputToolbar.contentView.rightBarButtonItemWidth = 60
    }

    private func configureQuickReply() {

        quickReplyView.collectionView.dataSource = collectionViewLayout
        quickReplyView.collectionView.delegate   = collectionViewLayout
        quickReplyView.collectionView.register(UINib(nibName: String(describing: QuickReplyCell.self), bundle:nil), forCellWithReuseIdentifier:QuickReplyCellReuseIdentifier)
        quickReplyView.isHidden = true
        view.addSubview(quickReplyView)
        quickReplyView.snp.makeConstraints { (make) in
            make.bottom.equalTo(inputToolbar.snp.top).offset(-0.3)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(QuickReplyViewHeight)
        }
    }

    func showQuickReplyViewWithItems(items: [QuickReply]) {
        
        collectionViewLayout.items = items
        quickReplyView.reloadData()
        collectionView.collectionViewLayout.sectionInset = UIEdgeInsetsMake(20, -15, QuickReplyViewHeight+5, -20)
        collectionView.layoutIfNeeded()
        collectionView.reloadData()
        scrollToBottom(animated: false)
        quickReplyView.isHidden = false
    }

    func hideQuickReplyView() {
        quickReplyView.isHidden = true
        collectionView.collectionViewLayout.sectionInset = UIEdgeInsetsMake(20, -15, 13, -20)
        collectionView.reloadData()
        scrollToBottom(animated: false)
    }

    override func didPressAccessoryButton(_ sender: UIButton!) {
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = [String(kUTTypeImage)]
        imagePickerController.modalPresentationStyle = .custom
        self.present(imagePickerController, animated: true, completion: nil)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        DispatchQueue.global().async {
        self.collectionViewLayout.collectionViewWidth = CGFloat(size.width)
            self.quickReplyView.collectionView.collectionViewLayout.invalidateLayout()
        self.quickReplyView.collectionView.reloadData()
        }
    }
}

extension MessagesViewController {

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

        self.showTypingIndicator = true
        chatModel.messages.append(JSQInfoMessage(senderId: userID, senderDisplayName: userID, date: Date.distantPast, text: text))
        viewModel.messageService.sendMessage(text: text)
        self.finishSendingMessage()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let msg = chatModel.messages[indexPath.item]

        if !msg.isMediaMessage {

            cell.textView?.dataDetectorTypes = UIDataDetectorTypes.lookupSuggestion
            cell.textView!.textColor = UIColor.black

            if msg.senderId == userID {
                cell.textView.textColor = UIColor(red: 98/255.0, green: 98/255.0, blue: 98/255.0, alpha: 1)
            } else {
                cell.textView.textColor = UIColor.white
            }
        } else if msg.gifUrl != nil{

            configureCellWithGif(gifUrl: msg.gifUrl!, cell: cell)
        }


        return cell
    }


    func configureCellWithGif(gifUrl:URL, cell: JSQMessagesCollectionViewCell ) {
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: gifUrl)
                DispatchQueue.main.async {
                    let image = FLAnimatedImage(animatedGIFData: data)
                    let imageView = FLAnimatedImageView()
                    imageView.animatedImage = image
                    imageView.frame = cell.contentView.frame
                    imageView.layer.cornerRadius = 10
                    imageView.layer.masksToBounds = true
                    // imageView.layer.frame = cell.contentView.layer.frame
                    //                cell.mediaView.addSubview(imageView)
                    cell.mediaView = imageView
                }
            } catch {
                print("error")
            }
        }
    }
}

extension MessagesViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            chatModel.addPhotoMediaMessage(image: image)
        } else if let mediaUrl = info[UIImagePickerControllerMediaURL] as? URL {
            chatModel.addVideoMediaMessage(videoUrl: mediaUrl)
        }
        imagePickerController.dismiss(animated: true, completion: nil)
        self.finishSendingMessage()
    }

}

extension MessagesViewController: AlertRenderer { }

extension MessagesViewController: HUDRenderer { }

extension MessagesViewController: MessageViewModelDelegate {

    func didConnectedToChannel(error: Error?) {
        hideHUD()
        if let unwrappedError = error {
            displayError(unwrappedError)
        } else {
            sendInitialMessage()
        }
    }
    
    func didReceive(message: Message) {

        self.showTypingIndicator = false
        if let text = message.text, !(message.text?.isEmpty)! {
            chatModel.messages.append(JSQInfoMessage(senderId: botID, senderDisplayName: botID, date: Date.distantPast, text:text))
            self.finishSendingMessage()
        }
        if let mediaUrl = message.mediaUrl {

            let data = try? Data(contentsOf: mediaUrl) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch

            if let unwrappedData = data {
                let image = UIImage(data:unwrappedData )
                let photoItem = JSQPhotoMediaItem(image: image)
                photoItem?.appliesMediaViewMaskAsOutgoing = false
                let message = JSQInfoMessage(senderId: botID, displayName: botID, media:photoItem)
                if mediaUrl.absoluteString.contains(".gif") {
                    message?.gifUrl = mediaUrl
                }
                chatModel.messages.append(message!)
                self.finishSendingMessage()
            }
        }

        if message.quickReplies!.count > 0 {
            showQuickReplyViewWithItems(items: message.quickReplies!)
        }

    }
    
    func didReceive(error: Error) {
        self.showTypingIndicator = false
        hideHUD()
        displayError(error)
    }

    func sendInitialMessage() {
        showTypingIndicator = true;
        chatModel.messages.append(JSQInfoMessage(senderId: userID, senderDisplayName: userID, date: Date.distantPast, text: "Hi"))
        viewModel.messageService.sendMessage(text:"Hi")
        self.finishSendingMessage()
    }
}

extension MessagesViewController: QuickReplyCollectionViewDelegate {

    func didSelectItem(item:QuickReply) {

        showTypingIndicator = true
        viewModel.messageService.sendMessage(text: item.payload!)
        chatModel.messages.append(JSQInfoMessage(senderId: userID, senderDisplayName: userID, date: Date.distantPast, text: item.title!))
        self.finishSendingMessage()
        hideQuickReplyView()
    }
}

class JSQInfoMessage: JSQMessage {
    var gifUrl: URL?
}
