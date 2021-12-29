//
//  ViewController.swift
//  InstChat
//
//  Created by Kostadin Samardzhiev on 28.12.21.
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = Constants.appName
    }

}

