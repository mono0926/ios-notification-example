//
//  UIBackgroundRefreshStatus.extension.swift
//  Util
//
//  Created by mono on 2017/08/05.
//  Copyright © 2017 mono. All rights reserved.
//

import Foundation

extension UIBackgroundRefreshStatus: CustomStringConvertible {
    public var description: String {
        switch self {
        case .available: return "available"
        case .denied: return "denied"
        case .restricted: return "restricted"
        }
    }
}
