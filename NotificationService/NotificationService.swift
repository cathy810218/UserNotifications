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
        
        let fmURL: URL? = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.cardinalblue.com.app.series")
        var attachement: UNNotificationAttachment? = nil
        
        //  use semaphore convert async download to sync
        let semaphore = DispatchSemaphore(value: 0)
        if let imageURLString = bestAttemptContent?.userInfo["attachment"] as? String {
            let url = URL(string: imageURLString)!
            let localURL = fmURL?.appendingPathComponent(url.lastPathComponent)
            URLSession.downloadImage(atURL: url, withCompletionHandler: { (data, error) in
                if (error == nil) {
                    // wrtie to app group
                    try? data?.write(to: localURL!)
                    
                    // create attachment
                    attachement = try! UNNotificationAttachment(identifier: "attachment", url: localURL!, options: nil)
                    semaphore.signal()
                }
            })
        }
        semaphore.wait()
    
        //  success set attachments
        if let bestAttemptContent = bestAttemptContent {
            bestAttemptContent.attachments = [attachement!]
            contentHandler(bestAttemptContent)
        }

    }
    
    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}
