//
//  Constants.swift
//  InstChat
//
//  Created by Kostadin Samardzhiev on 29.12.21.
//

struct Constants {
    static let appName = "📱 InstChat"
    static let registerSegue = "goToChatAfterRegister"
    static let loginSegue = "goToChatAfterLogin"
    
    static let reusableCell = "ReuseableCell"
    static let messageCellNib = "MessageCell"
    
    struct Color {
        static let user1ColorSet = "user1ColorSet"
        static let user2ColorSet = "user2ColorSet"
    }
    
    struct FStore {
        static let messagesCollection = "messages"
        static let messageSenderKey = "sender"
        static let messageBodyKey = "body"
        static let messageDateKey = "date"
    }
}
