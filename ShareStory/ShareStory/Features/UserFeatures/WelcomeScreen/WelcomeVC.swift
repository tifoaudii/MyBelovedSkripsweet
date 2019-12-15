//
//  WelcomeVC.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 24/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit


class WelcomeVC: UIViewController {

    @IBOutlet weak var patientButton: UIButton!
    @IBOutlet weak var konselorButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        patientButton.layer.borderWidth = 1
        konselorButton.layer.borderWidth = 1
        patientButton.layer.borderColor = UIColor.systemTeal.cgColor
        konselorButton.layer.borderColor = UIColor.systemTeal.cgColor
        patientButton.layer.cornerRadius = 10
        konselorButton.layer.cornerRadius = 10
//        konselorButton.setImage(#imageLiteral(resourceName: "konselor").withRenderingMode(.alwaysOriginal), for: .normal)
//        konselorButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 12, bottom: 5, right: konselorButton.bounds.width - 35)
//        konselorButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: ((konselorButton.imageView?.frame.width)!))
//
    }
    
    @IBAction func userButtonDidClicked(_ sender: Any) {
        self.navigataToMainScreen()
    }
    
    @IBAction func konselorButtonDidClicked(_ sender: Any) {
        if DataService.shared.isKonselorLoggedIn {
            let konselorMainVC = UIStoryboard.init(name: "Konselor", bundle: nil).instantiateViewController(identifier: "KonselorMain") as! UITabBarController
            konselorMainVC.modalPresentationStyle = .fullScreen
            self.present(konselorMainVC, animated: true, completion: nil)
        } else {
            self.navigateToKonselorScreen()
        }
    }
}
