//
//  RemoteNotificationManager.swift
//  Manager
//
//  Created by mono on 2017/08/05.
//  Copyright © 2017 mono. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import Util

public protocol RemoteNotificationManagerProtocol {
    /** プッシュ通知許可を求める(アプリ起動する度に毎回呼ぶ) */
    func registerRemoteNotification()
    /** プッシュ通知登録成功時に呼ばれる */
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data!)
    /** プッシュ通知登録失敗時に呼ばれる */
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error!)
    /** バックグラウンド通知が来た時に呼ばれる */
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
}

class RemoteNotificationManager: NSObject, RemoteNotificationManagerProtocol {

    fileprivate let notificationCenter = UNUserNotificationCenter.current()

    override init() {
        super.init()
        notificationCenter.delegate = self
    }

    func registerRemoteNotification() {
        notificationCenter.requestAuthorization(options: [.badge, .sound, .alert]) { granted, error in
            logger.error(error)
            if !granted {
                logger.info("not granged")
                return
            }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        registerCategories()
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data!) {
        let token = deviceToken.map { String(format: "%.2hhx", $0) }.joined()
        logger.info("token: \(token)")
        // 通常、ここに到達する度にプッシュ通知サーバーにdeviceTokenを伝える
    }

    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error!) {
        if TARGET_OS_SIMULATOR == 0 {
            logger.error(error)
        } else {
            logger.info("This is Simulator, so failed to registerForRemoteNotifications\nError: \(error)")
        }
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        logger.info("userInfo: \(userInfo)")
        logger.info("バックグラウンド通知")
        logger.info("backgroundTimeRemaining: \(application.backgroundTimeRemaining)")
        // ここで実際にやりたいバックグラウンド処理を挟んで、終わったら以下を適切な引数で呼ぶ
        completionHandler(.newData)
    }

    func registerCategories() {
        // オプション省略
        let action1 = UNNotificationAction(identifier: "action1",
                                           title: "title1")
        // オプションを1つ指定
        let action2 = UNNotificationAction(identifier: "action2",
                                           title: "title2",
                                           options: .authenticationRequired)
        // オプションを複数指定
        let action3 = UNNotificationAction(identifier: "action3",
                                           title: "title3",
                                           options: [.authenticationRequired, .destructive])
        if #available(iOS 11.0, *) {
            let category = UNNotificationCategory(identifier: "category1",
                                                  actions: [action1, action2, action3],
                                                  intentIdentifiers: [],
                                                  options: [])
            notificationCenter.setNotificationCategories([category])
        } else {
            // Fallback on earlier versions
        }
//        let category = UNNotificationCategory(identifier: <#T##String#>,
//                                              actions: <#T##[UNNotificationAction]#>,
//                                              intentIdentifiers: <#T##[String]#>,
//                                              hiddenPreviewsBodyPlaceholder: <#T##String#>,
//                                              options: <#T##UNNotificationCategoryOptions#>)
    }
}

extension RemoteNotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let actionIdentifier = response.actionIdentifier
        if actionIdentifier == UNNotificationDefaultActionIdentifier {
            logger.info("通常の通知バナータップ")
        } else if actionIdentifier == UNNotificationDismissActionIdentifier {
            logger.info("通知バナーが閉じられた")
        } else if actionIdentifier == "category1" {
            logger.info("自分で定義したカテゴリー(\(actionIdentifier))")
        } else {
            logger.default("想定しないカテゴリー(\(actionIdentifier))")
        }
        switch UIApplication.shared.applicationState {
        case .inactive:
            logger.info("アプリを閉じた状態で`foreground`オプション有りのアクション実行")
        case .active:
            logger.info("アプリを開いた状態でアクション実行")
        case .background:
            logger.info("アプリを閉じた状態で`foreground`オプション無しのアクション実行")
            logger.info("backgroundTimeRemaining: \(application.backgroundTimeRemaining)")
        }
        completionHandler()
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        assert(UIApplication.shared.applicationState == .active, "active(アプリを開いている状態)でしか呼ばれないはず")
        logger.info("applicationState: \(UIApplication.shared.applicationState)")
        let content = notification.request.content
        logger.info("content: \(content)")
        logger.info("userInfo: \(content.userInfo)")
        logger.info("B: アプリ開いた状態で通知")
        // これを呼ぶとアプリ起動中でも通知バナーが出せる(呼ばなくても良い)
        completionHandler([.badge, .alert, .sound])
    }
}
