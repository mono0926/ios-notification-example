//
//  MyPayload.swift
//  NotificationManager
//
//  Created by mono on 2017/08/06.
//  Copyright © 2017 mono. All rights reserved.
//

import Foundation

public struct MyPayload: Decodable {
    let text: String?
    let inner: MyInnerPayload?

    init?(userInfo: [AnyHashable: Any]) throws {
        guard let custom = userInfo["custom"] else {
            return nil
        }
        let data = try JSONSerialization.data(withJSONObject: custom)
        self = try JSONDecoder().decode(MyPayload.self, from: data)
    }
}

public struct MyInnerPayload: Decodable {
    let text: String?
}
