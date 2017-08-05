//
//  AppDelegate.swift
//  Chapter1
//
//  Created by mono on 2017/07/05.
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
        // A: 通知許可を求める
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            // エラーの場合は出力
            logger.error(error)
            if !granted {
                // 許可されなかった場合は諦める
                logger.info("not granged")
                return
            }
            // C: メインスレッドに戻す
            DispatchQueue.main.async {
                // B: 通知がが許可された場合にdevice tokenをリクエスト
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        return true
    }

    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // `registerForRemoteNotifications()`を契機に、
        // シミュレーター・設定の誤った実機実行ではこちらに到達
        if TARGET_OS_SIMULATOR == 0 {
            logger.error(error)
        } else {
            logger.info("This is Simulator, so failed to registerForRemoteNotifications\nError: \(error)")
        }
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // `registerForRemoteNotifications()`を契機に、
        // 正しく設定された実機実行ではこちらに到達
        let token = deviceToken.map { String(format: "%.2hhx", $0) }.joined()
        logger.info("token: \(token)")
        deviceTokenDidSet?(token)
    }
}
