//
//  ViewController.swift
//  Chapter1
//
//  Created by mono on 2017/07/05.
//  Copyright © 2017 mono. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    @IBOutlet weak var deviceTokenLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        (UIApplication.shared.delegate! as! AppDelegate).deviceTokenDidSet = { [unowned self] token in
            self.deviceTokenLabel.text = token
            UIPasteboard.general.string = token
        }
    }

    // TODO: あとで消す
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        type(of: self).hoge()
    }

    static func hoge() {
        let content = UNMutableNotificationContent()
        content.title = "hoge"
        content.userInfo = ["aps": ["alert": ["body": "(　´･‿･｀)"]]]

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "aaaa", content: content, trigger: trigger)

        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            print(error)
        }
    }
}
