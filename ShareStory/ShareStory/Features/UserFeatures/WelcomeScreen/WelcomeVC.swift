//
//  WelcomeVC.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 24/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func userButtonDidClicked(_ sender: Any) {
        self.navigataToMainScreen()
    }
    
    @IBAction func konselorButtonDidClicked(_ sender: Any) {
        self.navigateToKonselorScreen()
    }
}
