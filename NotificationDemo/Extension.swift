//
//  Extension.swift
//  NotificationDemo
//
//  Created by 马权 on 6/24/16.
//  Copyright © 2016 马权. All rights reserved.
//

import Foundation

extension String {
    
    enum UNNotificationAction : String {
        case Accept
        case Reject
        case Input
    }
    
    enum UNNotificationCategory : String {
        case Normal
        case Cheer
        case CheerText
    }
    
    enum UNNotificationRequest : String {
        case NormalLocalPush
        case LocalPushWithTrigger
        case LocalPushWithCustomUI1
        case LocalPushWithCustomUI2
    }
}

extension URL {
    
    enum ResourceType : String {
        case Local
        case Local1
        case Remote
        case AttachmentRemote
    }
    
    static func resource(type :ResourceType) -> URL {
        switch type {
        case .Local:
            return Bundle.main.url(forResource: "cheer" , withExtension:"png")!;
        case .Local1:
            return Bundle.main.url(forResource: "hahaha" , withExtension:"gif")!;
        case .Remote:
            return URL(string: "http://ww1.sinaimg.cn/large/65312d9agw1f59leskkcij20cs0csmym.jpg")!
        case .AttachmentRemote:
            return URL(string: "https://assets-cdn.github.com/images/modules/open_graph/github-mark.png")!
        }
    }
}

extension URLSession {
    
    class func downloadImage(atURL url: URL, withCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) {
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            completionHandler(data, error)
        }
        dataTask.resume()
    }
}

