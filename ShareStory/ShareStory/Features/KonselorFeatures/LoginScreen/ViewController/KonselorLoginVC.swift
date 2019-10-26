//
//  KonselorLoginVC.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 24/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class KonselorLoginVC: UIViewController {
    
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private let konselorLoginVM = KonselorLoginVM()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.bindViewModel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let mainVC = segue.destination as? UITabBarController else {
            return
        }
        mainVC.modalPresentationStyle = .fullScreen
    }
    
    fileprivate func bindViewModel() {
        self.konselorLoginVM.isLoginSuccess
            .drive(onNext: { [unowned self] isLoginSuccess in
                if isLoginSuccess {
                    self.onLoginSuccess()
                }
            }).disposed(by: disposeBag)
        
        self.konselorLoginVM.hasError
            .drive(onNext: { [unowned self] hasError in
                if hasError {
                    self.onLoginFailed()
                }
            }).disposed(by: disposeBag)
        
        self.konselorLoginVM.isLoading
            .drive(onNext: { [unowned self] isLoading in
                if isLoading {
                    self.onLoading()
                }
            }).disposed(by: disposeBag)
    }
    
    @IBAction func loginButtonDidCliked(_ sender: Any) {
        guard let email = emailTextField.text, !emailTextField.text!.isEmpty else {
            return self.showValidationMessage(message: "email konselor")
        }
        
        guard let password = passwordTextField.text, !passwordTextField.text!.isEmpty else {
            return self.showValidationMessage(message: "kata sandi konselor")
        }
        
        self.konselorLoginVM.loginKonselor(email: email, password: password)
    }
}

extension KonselorLoginVC {
    
    func onLoginSuccess() {
        self.loadingSpinner.stopAnimating()
        self.performSegue(withIdentifier: "konselor_main_segue", sender: nil)
    }
    
    func onLoginFailed() {
        self.loadingSpinner.stopAnimating()
        self.showErrorMessage()
    }
    
    func onLoading() {
        self.loadingSpinner.startAnimating()
    }
}
