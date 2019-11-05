//
//  LoginVC.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 10/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    private let loginVM = LoginVM()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindViewModel()
    }
    
    fileprivate func bindViewModel() {
        self.loginVM.isLoading
            .drive(onNext: { [unowned self] isLoading in
                if isLoading {
                    self.loadingSpinner.startAnimating()
                } else {
                    self.loadingSpinner.stopAnimating()
                }
            }).disposed(by: disposeBag)
        
        self.loginVM.isLoginSuccess
            .drive(onNext: { [unowned self] success in
                if success {
                    self.onLoginSuccess()
                }
            }).disposed(by: disposeBag)
        
        self.loginVM.hasError
            .drive(onNext:{ [unowned self] hasError in
                if hasError {
                    self.onLoginFailed()
                }
            }).disposed(by: disposeBag)
    }
    
    @IBAction func handleLoginButton(_ sender: Any) {
        guard let email = emailTextField.text, !emailTextField.text!.isEmpty else {
            return self.showValidationMessage(message: "email")
        }
        
        guard let password = passwordTextField.text, !passwordTextField.text!.isEmpty else {
            return self.showValidationMessage(message: "katasandi")
        }
        
        self.loginVM.loginUser(email: email, password: password)
    }
    
    @IBAction func dismissViewController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension LoginVC {
    
    fileprivate func onLoginSuccess() {
        self.navigataToMainScreen()
    }
    
    fileprivate func onLoginFailed() {
        let alertController = UIAlertController(title: "Upps", message: "Email atau katasandi anda salah, silahkan coba lagi", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
