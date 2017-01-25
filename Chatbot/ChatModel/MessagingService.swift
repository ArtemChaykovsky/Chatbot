//
//  MessagingService.swift
//  FirebaseNeFirebase
//
//  Created by Anton Dolzhenko on 23.01.17.
//  Copyright © 2017 Onix-Systems. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuthUI
import FirebaseFacebookAuthUI
import FirebaseGoogleAuthUI
import FirebaseTwitterAuthUI
import FirebaseDatabaseUI
import SwiftWebSocket
import JSQMessagesViewController

enum Result<T>{
    case success(r: T)
    case error(e: Error)
}

enum MediaType:String {
    case none
    case image
    case video
    case audio
}

struct Message {

    let id:String
    // {timestamp}.{contact_urn}:{incr_seq} (e.g.1481989728.12324:23)
    let seq:String
    let text:String
    let mediaType:MediaType
    let mediaUrl:URL?
    let metadata:[String:Any]
    let channelUuid:String
    let contactUrn:String
    let contactUuid:String
    let channelAddress:String
    
    var anyObject:Any {
        var msg = [
            "msg_id":id,
            "seq":seq,
            "text":text,
            "media_type":mediaType.rawValue,
            "metadata":metadata,
            "channel_uuid":channelUuid,
            "contact_urn":contactUrn,
            "contact_uuid":contactUuid,
            "channel_address":channelAddress
        ] as [String : Any]
        if let url = mediaUrl {
            msg["media_url"] = url.absoluteURL
        }

        return msg
    }
    
}

extension Message {
    init?(response:[String:Any]) {
        id = response["msg_id"] as! String
        seq = response["seq"] as! String
        text = response["text"] as! String
//        mediaType = response["media_type"] as! MediaType
        mediaType = .none
        if let urlString = response["media_url"] as? String,
            let url = URL(string: urlString) {
            mediaUrl = url
        } else {
            mediaUrl = nil
        }
        if let data = response["metadata"] as? [String:Any] {
            metadata = data
        } else {
            metadata = [:]
        }
        channelUuid = response["channel_uuid"] as! String
        contactUrn = response["contact_urn"] as! String
        contactUuid = response["contact_uuid"] as! String
        channelAddress = response["channel_address"] as! String
    }
    
    init?(snapshot: FIRDataSnapshot) {
        guard let snapshotValue = snapshot.value as? [String: Any] else { return nil }
        self.init(response:snapshotValue)
    }

//TODO: finish it
//    var jsqMessage:JSQMessage {
//        return JSQMessage(senderId: "", displayName: "", media: <#T##JSQMessageMediaData!#>)
//    }

}

protocol Service {
    var demoMode:Bool { get set }
    var onMessageReceived:(Result<Message>)->() { get set }
    func send(msg:Message)
}

final class WSService: Service {
    var demoMode = false
    let ws:WebSocket!
    var onMessageReceived: (Result<Message>) -> () = { _ in }
    
    init() {
        ws = WebSocket("wss://echo.websocket.org")
        ws.event.open = { print("socket opened") }
        ws.event.error = { error in print("Socket error \(error)") }
        ws.event.message = { message in
            if let uMessage = message as? [String:Any],
                let msg = Message(response: uMessage) {
                self.onMessageReceived(.success(r: msg))
            }
        }
        ws.open()
    }
    
    func send(msg:Message) {
        ws.send(msg.anyObject)
    }
}

final class FRService: Service {
    var timer:Timer!
    
    var demoMode: Bool = false {
        didSet {
            timer = Timer.scheduledTimer(timeInterval: CDouble(arc4random_uniform(10)), target: self, selector: #selector(fakeMessage), userInfo: nil, repeats: false)
        }
    }
    lazy var ref: FIRDatabaseReference = FIRDatabase.database().reference()
    var conversationRef:FIRDatabaseReference!
    var onMessageReceived: (Result<Message>) -> () = { _ in }
    
    init() {
        FIRAuth.auth()?.signInAnonymously() { (user, error) in
            if let user = user {
                self.conversationRef = self.ref.child(user.uid)
                self.conversationRef.observe(.childAdded, with: { (snapshot) in
                    if let message = Message(snapshot: snapshot) {
                        self.onMessageReceived(.success(r: message))
                    }
                }, withCancel: { (error) in
                    self.onMessageReceived(.error(e:error))
                })
            }
        }
        conversationRef = FIRDatabaseReference()
        
    }
    
    deinit {
        timer.invalidate()
    }
    
    func send(msg:Message) {
        self.conversationRef.childByAutoId().setValue(msg.anyObject)
    }
    
    @objc func fakeMessage(){
        let message = Message(id: "",
                              seq: "",
                              text: randomString(length: 10),
                              mediaType:.none,
                              mediaUrl: nil,
                              metadata: [:],
                              channelUuid: "",
                              contactUrn: "",
                              contactUuid: "",
                              channelAddress: "")
        onMessageReceived(.success(r: message))
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: CDouble(arc4random_uniform(10)), target: self, selector: #selector(fakeMessage), userInfo: nil, repeats: false)
    }
}



