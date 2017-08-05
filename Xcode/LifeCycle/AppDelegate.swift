//
//  AppDelegate.swift
//  LifeCycle
//
//  Created by mono on 2017/07/13.
//  Copyright © 2017 mono. All rights reserved.
//

import UIKit
import UserNotifications
import Util

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var deviceTokenDidSet: ((String) -> ())?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            logger.error(error)
            if !granted {
                logger.info("not granged")
                return
            }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        return true
    }

    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        if TARGET_OS_SIMULATOR == 0 {
            logger.error(error)
        } else {
            logger.info("This is Simulator, so failed to registerForRemoteNotifications\nError: \(error)")
        }
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%.2hhx", $0) }.joined()
        logger.info("token: \(token)")
        deviceTokenDidSet?(token)
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        logger.info("userInfo: \(userInfo)")
        logger.info("バックグラウンド通知")
        logger.info("backgroundTimeRemaining: \(application.backgroundTimeRemaining)")
        completionHandler(.newData)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        logger.info("applicationState: \(UIApplication.shared.applicationState)")
        let userInfo = response.notification.request.content.userInfo
        logger.info("userInfo: \(userInfo)")
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
        // ローカル通知の時も呼ばれる
        logger.info("applicationState: \(UIApplication.shared.applicationState)")
        let userInfo = notification.request.content.userInfo
        logger.info("userInfo: \(userInfo)")
        logger.info("B: アプリ開いた状態で通知")
        // これを呼ぶとアプリ起動中でも通知バナーが出せる(呼ばなくても良い)
        completionHandler([.badge, .alert, .sound])
    }
}
