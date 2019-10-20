//
//  LoginGuideVC.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 13/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit

class LoginGuideVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       guard let loginVC = segue.destination as? UINavigationController else {
          return
       }
       loginVC.modalPresentationStyle = .fullScreen
    }
    @IBAction func dismissViewController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func getUserToLogin(_ sender: Any) {
        self.performSegue(withIdentifier: "login_guide_segue", sender: nil)
    }
    
}
