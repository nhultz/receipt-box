//
//  SettingsViewController.swift
//  ReceiptBox
//
//  Created by Nick Hultz on 3/20/18.
//  Copyright © 2018 nhultz. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var versionLabel: UILabel!

    @IBOutlet weak var arrowButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        versionLabel.text = version()
    }

    @IBAction func handleButtonTap(_ sender: UIButton) {
        arrowButton.isSelected = !arrowButton.isSelected
        
        let transform = arrowButton.isSelected ? CGAffineTransform(rotationAngle: CGFloat.pi)
                                               : CGAffineTransform.identity

        UIView.animate(withDuration: 0.25) {
            self.arrowButton.transform = transform
        }
    }

    func version() -> String {
        var version = "n/a"
        var build = "n/a"

        if let infoDict = Bundle.main.infoDictionary {
            version = infoDict["CFBundleShortVersionString"] as? String ?? "n/a"
            build = infoDict["CFBundleVersion"] as? String ?? "n/a"
        }

        return "Version: \(version), Build: \(build)"
    }

}
