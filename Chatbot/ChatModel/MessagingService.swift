//
//  MessagingService.swift
//  FirebaseNeFirebase
//
//  Created by Anton Dolzhenko on 23.01.17.
//  Copyright © 2017 Onix-Systems. All rights reserved.
//

import Foundation
import SwiftWebSocket
import JSQMessagesViewController
import Alamofire
import ObjectMapper

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

struct QuickReply: Mappable {

    var contentType:String?
    var title:String?
    var payload:String?

//    "content_type": "text",
//    "title": "💷 Today's Naps",
//    "payload": "r_naps"

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        contentType <- map["content_type"]
        title <- map["title"]
        payload <- map["payload"]
    }
}

struct Message:Mappable {

    var id:String?
    // {timestamp}.{contact_urn}:{incr_seq} (e.g.1481989728.12324:23)
    var seq:String?
    var text:String?
    var mediaType:MediaType?
    var mediaUrl:URL?
    var metadata:[String:Any]?
    var channelUuid:String?
    var contactUrn:String?
    var contactUuid:String?
    var channelAddress:String?
    var quickReplies:[QuickReply]?
    
//    var anyObject:Any {
//        var msg = [
//            "msg_id":id,
//            "seq":seq,
//            "text":text,
//            "media_type":mediaType.rawValue,
//            "metadata":metadata,
//            "channel_uuid":channelUuid,
//            "contact_urn":contactUrn,
//            "contact_uuid":contactUuid,
//            "channel_address":channelAddress
//        ] as [String : Any]
//        if let url = mediaUrl {
//            msg["media_url"] = url.absoluteURL
//        }
//
//        return msg
//    }

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        seq <- map["seq"]
        text <- map["text"]
        if text != nil, text!.contains("\"quick_replies\"") {
//            text <- map["text"]
            print("quick_replies")
//            let quickReplies <- text?.dictionary
            if let dic = text?.dictionary {
                print(dic["quick_replies"])
                if let replies = Mapper<QuickReply>().mapArray(JSONArray: dic["quick_replies"] as! [[String : Any]]) {
                    quickReplies = replies
                }
            }
            quickReplies <- map["text.quick_replies"]
        }
        mediaType <- map["media_type"]
        mediaUrl <- (map["media_url"],URLTransform())
        metadata <- map["metadata"]
        channelUuid <- map["channel_uuid"]
        contactUrn <- map["contact_urn"]
        contactUuid <- map["contact_uuid"]
        channelAddress <- map["channel_address"]
//        quickReplies <- map["text.quick_replies"]
    }
}

extension Message {
    init?(response:[String:Any]) {
        id = response["msg_id"] as! String
        seq = response["seq"] as! String
        let messagetext = response["text"] as! String
        print("Response: \(response)")
        
        if let unwrappedQuickReplies = messagetext.dictionary {
            text = unwrappedQuickReplies["text"] as! String
            quickReplies = []

            if let repliesArray = unwrappedQuickReplies ["quick_replies"] as? NSArray{
               // let message = repliesArray ["message"]
                for dict in repliesArray {

                }


            }
        } else {
            text = response["text"] as! String
            quickReplies = []
        }
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

//TODO: finish it
//    var jsqMessage:JSQMessage {
//        return JSQMessage(senderId: "", displayName: "", media: <#T##JSQMessageMediaData!#>)
//    }

}

protocol Service {
    var demoMode:Bool { get set }
    var didConnectToChannel:(Error?)->() { get set }
    var onMessageReceived:(Result<Message>)->() { get set }
    func send(msg:Message)
    func sendMessage(text: String)
}

final class WSService: Service {
    var demoMode = false
    var uuid: String!
    var channel: String!
    var ws:WebSocket!
    var didConnectToChannel: (Error?) -> () = { _ in }
    var onMessageReceived: (Result<Message>) -> () = { _ in }
    
    init() {
        uuid = ""
        channel = ""
        //getChannel()
    }
    
    func send(msg:Message) {
        ws.send(msg.toJSON())
    }

    func sendMessage(text: String) {
        if let webSocket = ws {
            let postDict: [String: Any] = ["uuid": uuid!,"text" : text]
            webSocket.send(postDict.json)
        }
    }

    func getChannel() {
        uuid = UUID().uuidString
        Alamofire.request("http://146.185.136.172/getChannel" , method: .post, parameters: ["uuid":uuid], encoding: URLEncoding.httpBody)
            .responseJSON { response in
                print(response.request as Any)  // original URL request
                print(response.response as Any) // URL response
                print(response.result.value as Any)
                print(response.result.error as Any)
                if let error = response.result.error {
                    self.didConnectToChannel(error)
                } else {
                    if let json = response.result.value as? [String: Any] {
                        self.channel = json ["channel"] as? String
                        self.configureWebSocket()
                        self.didConnectToChannel(nil)
                    } else {
                        //TODO: pass parse error to didConnectToChannel
                    }
                }
        }
    }

    func configureWebSocket() {
        ws = WebSocket(channel!)
        ws.event.open = { print("socket opened") }
        ws.event.error = { error in print("Socket error \(error)") }
        ws.event.message = { message in
//            if let uMessage = message as? [String:Any],
//                let msg = Message(response: uMessage) {
//                self.onMessageReceived(.success(r: msg))
//            } else if let error = message as? String {
//              //  self.onMessageReceived(.error(e:error))
////                let msg = Message(response: error)
////                self.onMessageReceived(.success(r:error))
//            }
            if let response = message as? String,
                let messageData = response.dictionary,
                let msg = Mapper<Message>().map(JSON: messageData) {
                     self.onMessageReceived(.success(r: msg))
                }
        }
        ws.event.error = { error in
            self.onMessageReceived(.error(e: error))
        }
        ws.open()
    }


}

extension String {

    var dictionary:[String:Any]? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            return nil
        }
    }
}

extension Dictionary {

    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }

    func printJson() {
        print(json)
    }

}


