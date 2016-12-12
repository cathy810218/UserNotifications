//
//  NotificationService.swift
//  NotificationService
//
//  Created by 马权 on 6/23/16.
//  Copyright © 2016 马权. All rights reserved.
//


/*
 Service push data struct:
 
 {
    "aps" : {
        "alert" : {
        "title" : "title",
        "body" : "Your message Here"
        },
        "mutable-content" : "1",
        "category" : "Cheer"    //  if needn't use custom extensionContent, delete it.
    },
    "imageAbsoluteString" : "http://ww1.sinaimg.cn/large/65312d9agw1f59leskkcij20cs0csmym.jpg"  //  custom info
 }
 */

import UIKit
import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest,
                             withContentHandler contentHandler:@escaping (UNNotificationContent) -> Void) {
        
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        func failEarly() {
            contentHandler(request.content)
        }
        
        guard let content = (request.content.mutableCopy() as? UNMutableNotificationContent) else {
            return failEarly()
        }
        
        guard let attachmentURL = content.userInfo["attachment"] as? String else {
            return failEarly()
        }

        guard let imageData = try? Data(contentsOf: URL(string: attachmentURL)!) else {
            return failEarly()
        }
        guard let attachment = UNNotificationAttachment.create(imageFileIdentifier: "image.jpg", data: imageData, options: nil) else {
            return failEarly()
        }
        
        content.attachments = [attachment]
        contentHandler(content.copy() as! UNNotificationContent)
    }

    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}

extension UNNotificationAttachment {
    /// Save the image to disk
    static func create(imageFileIdentifier: String, data: Data, options: [NSObject : AnyObject]?) ->UNNotificationAttachment? {
        let fileManager = FileManager.default
        let tmpSubFolderName = "notification"
        let tmpSubFolderURL =
            URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)
        do {
            try fileManager.createDirectory(at: tmpSubFolderURL, withIntermediateDirectories: true, attributes: nil)
            let fileURL = tmpSubFolderURL.appendingPathComponent(imageFileIdentifier)
            try data.write(to: fileURL, options: [])
            let attachment = try UNNotificationAttachment(identifier: imageFileIdentifier, url: fileURL, options: options)
            return attachment
        } catch let error {
            print("error \(error)")
        }
        return nil
    }
}
