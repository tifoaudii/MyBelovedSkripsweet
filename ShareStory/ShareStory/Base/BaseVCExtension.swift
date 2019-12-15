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

extension UIView {
    
    //MARK: - Setup Constraint Easier
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop:CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight:CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func bindToKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(UIView.keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChange(_ notification: NSNotification) {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let curFrame = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let targetFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = targetFrame.origin.y - curFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: curve), animations: { [unowned self] in
            self.frame.origin.y += deltaY
            
        },completion: nil)
    }
}
