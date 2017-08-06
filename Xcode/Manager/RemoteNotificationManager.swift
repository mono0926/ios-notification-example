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
import RxSwift
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
}

extension RemoteNotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {

        logger.info("applicationState: \(UIApplication.shared.applicationState)")
        let content = response.notification.request.content
        logger.info("content: \(content)")
        switch UIApplication.shared.applicationState {
        case .inactive:
            logger.info("A: アプリを閉じたがまだterminatedになっていない状態から通知経由で起動 or D: Terminatedから通知経由で起動")
        case .active:
            logger.info("C: アプリを開いた状態で通知バナータップ")
        case .background:
            logger.fault("到達しないはず")
        }
        completionHandler()

    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        assert(UIApplication.shared.applicationState == .active, "active(アプリを開いている状態)でしか呼ばれないはず")
        do {
            let myPayload = try MyPayload(userInfo: notification.request.content.userInfo)
            logger.debug(myPayload)
        } catch let e {
            logger.error(e)
        }
        logger.info("applicationState: \(UIApplication.shared.applicationState)")
        let content = notification.request.content
        logger.info("content: \(content)")
        logger.info("userInfo: \(content.userInfo)")
        logger.info("B: アプリ開いた状態で通知")
        // これを呼ぶとアプリ起動中でも通知バナーが出せる(呼ばなくても良い)
        completionHandler([.badge, .alert, .sound])
    }
}
