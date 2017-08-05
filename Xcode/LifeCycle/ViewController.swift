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

    override func viewDidLoad() {
        super.viewDidLoad()
        updateBackgroundStatusLabel()
    }

    private func updateBackgroundStatusLabel() {
        backgroundStatusLabel.text = UIApplication.shared.backgroundRefreshStatus.description
    }

    @IBAction func updateDidTap(_ sender: UIButton) {
        updateBackgroundStatusLabel()
    }
}

