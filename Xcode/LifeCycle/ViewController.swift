//
//  ViewController.swift
//  LifeCycle
//
//  Created by mono on 2017/07/13.
//  Copyright © 2017 mono. All rights reserved.
//

import UIKit
import Util

class ViewController: UIViewController {
    @IBOutlet weak var backgroundStatusLabel: UILabel!
    @IBOutlet weak var lowPowerModeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateBackgroundStatusLabel()
        updateLowPowerModeLabel()
    }

    private func updateBackgroundStatusLabel() {
        backgroundStatusLabel.text = UIApplication.shared.backgroundRefreshStatus.description
    }

    private func updateLowPowerModeLabel() {
        lowPowerModeLabel.text = ProcessInfo.processInfo.isLowPowerModeEnabled.description
    }

    @IBAction func updateBackgroundRefreshStatusDidTap(_ sender: UIButton) {
        updateBackgroundStatusLabel()
    }

    @IBAction func updateLowPowerModeEnabledDidTap(_ sender: UIButton) {
        updateLowPowerModeLabel()
    }
}

