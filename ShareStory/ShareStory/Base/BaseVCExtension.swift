//
//  BaseVCExtension.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 13/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showErrorMessage() {
        let alertController = UIAlertController(title: "Uppss", message: "Sepertinya ada gangguan dikit, coba lagi ya", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func navigateToAuthScreen() {
        let loginVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginVC")
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
    }
    
    func navigataToMainScreen() {
        let mainVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "Main")
        mainVC.modalPresentationStyle = .fullScreen
        self.present(mainVC, animated: true, completion: nil)
    }
    
    func navigateToKonselorScreen() {
        let konselorVC = UIStoryboard.init(name: "Konselor", bundle: nil).instantiateViewController(identifier: "KonselorLoginVC")
        konselorVC.modalPresentationStyle = .fullScreen
        self.present(konselorVC, animated: true, completion: nil)
    }
    
    func navigateToLoginGuide() {
        let loginGuideVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginGuideVC")
        loginGuideVC.modalPresentationStyle = .fullScreen
        self.present(loginGuideVC, animated: true, completion: nil)
    }
    
    func showValidationMessage(message: String) {
        let alertController = UIAlertController(title: "Upps", message: "Mohon isikan \(message) anda", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
