//
//  UIApplicationState.extension.swift
//  Util
//
//  Created by mono on 2017/07/13.
//  Copyright © 2017 mono. All rights reserved.
//

import Foundation

extension UIApplicationState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .background: return "background"
        case .inactive: return "inactive"
        case .active: return "active"
        }
    }
}
