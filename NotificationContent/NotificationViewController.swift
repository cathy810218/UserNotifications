//
//  NotificationViewController.swift
//  NotificationContent
//
//  Created by 马权 on 6/23/16.
//  Copyright © 2016 马权. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var label: UILabel!
    @IBOutlet var sublabel: UILabel!
    
    var actionCompletion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  custom content size of view
        self.preferredContentSize = CGSize(width: self.view.bounds.width, height: 300)
    }
    
    func dismissssss() {
        actionCompletion?()
        actionCompletion = nil
    }
}

extension NotificationViewController : UNNotificationContentExtension {
    
    func didReceive(_ notification: UNNotification) {
        let content = notification.request.content
        if let attachment = content.attachments.first {
            if attachment.url.startAccessingSecurityScopedResource() {
                if let imageData = try? Data(contentsOf: attachment.url) {
                    let image = UIImage(data: imageData as Data)
                    imageView.image = image
                }
                attachment.url.stopAccessingSecurityScopedResource()
            }
        }
    }
//    func didReceive(_ response: UNNotificationResponse,
//                    completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
//        
//        //  if response is UNTextInputNotificationResponse
//        if let textInputResponse = response as? UNTextInputNotificationResponse {
//            print(textInputResponse.userText)
//            completion(.dismiss)
//            return
//        }
//        
//        let responseNotificationRequestIdentifier = response.notification.request.identifier
//    
//        if responseNotificationRequestIdentifier == String.UNNotificationRequest.NormalLocalPush.rawValue ||
//            responseNotificationRequestIdentifier == String.UNNotificationRequest.LocalPushWithTrigger.rawValue ||
//            responseNotificationRequestIdentifier == String.UNNotificationRequest.LocalPushWithCustomUI1.rawValue ||
//            responseNotificationRequestIdentifier == String.UNNotificationRequest.LocalPushWithCustomUI2.rawValue {
//            
//            let actionIdentifier = response.actionIdentifier
//            switch actionIdentifier {
//            case String.UNNotificationAction.Accept.rawValue:
//                sublabel.text = "Good"
//                actionCompletion = { completion(.dismiss) }
//                perform(#selector(NotificationViewController.dismissssss), with: nil, afterDelay: 1)
//                break
//            case String.UNNotificationAction.Reject.rawValue:
//                sublabel.text = "Don't allow reject，can't dismiss"
//                completion(.doNotDismiss)
//                break
//            case String.UNNotificationAction.Input.rawValue:
//                becomeFirstResponder()
//                break
//            default:
//                break
//            }
//        }
//    }
}
