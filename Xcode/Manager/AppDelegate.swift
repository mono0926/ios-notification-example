//
//  AppDelegate.swift
//  Manager
//
//  Created by mono on 2017/08/05.
//  Copyright © 2017 mono. All rights reserved.
//

import UIKit
import UserNotifications
import Util

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var remoteNotificationManager: RemoteNotificationManagerProtocol = RemoteNotificationManager()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // 起動直後(アプリ要件によってはそれ以降の適切なタイミング)に毎回呼ぶ
        remoteNotificationManager.registerRemoteNotification()
        return true
    }

    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // managerに登録失敗を伝えるだけ
        remoteNotificationManager.application(application,
                                              didFailToRegisterForRemoteNotificationsWithError: error)
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // managerに登録成功を伝えるだけ
        remoteNotificationManager.application(application,
                                              didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // managerにバックグラウンド通知を伝えるだけ
        remoteNotificationManager.application(application,
                                              didReceiveRemoteNotification: userInfo,
                                              fetchCompletionHandler: completionHandler)
    }
}
