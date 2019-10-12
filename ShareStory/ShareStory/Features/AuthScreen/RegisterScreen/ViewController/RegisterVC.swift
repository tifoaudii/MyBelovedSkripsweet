//
//  RegisterVC.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 10/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterVC: UIViewController {

    //MARK:- IBOutlets here
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthDayTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    
    
    //MARK:- Private properties here
    private var gender: Gender = .male
    private let registerVM = RegisterVM()
    private let disposeBag = DisposeBag()
    
    
    //MARK:- ViewController's lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindViewModel()
    }
    
    //MARK:- Fileprivate methods here
    fileprivate func bindViewModel() {
        self.registerVM.registerFailed.drive(onNext: { [unowned self] error in
            if error {
                let alertController = UIAlertController(title: "Upps", message: "Error gan", preferredStyle: .alert)
                self.present(alertController, animated: true, completion: nil)
            }
        }).disposed(by: disposeBag)
        
        self.registerVM.registerSuccess.drive(onNext: { [unowned self] success in
            if success {
                self.onRegisterSuccess()
            }
        }).disposed(by: disposeBag)
    }
    
    //MARK:- IBAction Here
    @IBAction func pickMaleGender(_ sender: UIButton) {
        maleButton.setBackgroundImage(UIImage.init(systemName: "circle.fill")?.withTintColor(.systemTeal), for: .normal)
        femaleButton.setBackgroundImage(UIImage.init(systemName: "circle")?.withTintColor(.systemTeal, renderingMode: .alwaysOriginal), for: .normal)
        self.gender = .male
    }
    
    @IBAction func pickFemaleGender(_ sender: Any) {
        maleButton.setBackgroundImage(UIImage.init(systemName: "circle")?.withTintColor(.systemTeal), for: .normal)
        femaleButton.setBackgroundImage(UIImage.init(systemName: "circle.fill")?.withTintColor(.systemTeal, renderingMode: .alwaysOriginal), for: .normal)
        self.gender = .female
    }
    
    @IBAction func handleRegisterButton(_ sender: Any) {
        guard let name = nameTextField.text, !nameTextField.text!.isEmpty else {
            return self.showValidationMessage(message: "Nama")
        }
        
        guard let birthDay = birthDayTextField.text, !birthDayTextField.text!.isEmpty else {
            return self.showValidationMessage(message: "tanggal lahir")
        }
        
        guard let email = emailTextField.text, !emailTextField.text!.isEmpty else {
            return self.showValidationMessage(message: "email")
        }
        
        guard let password = passwordTextField.text, !passwordTextField.text!.isEmpty else {
            return self.showValidationMessage(message: "kata sandi")
        }
        
        let newUser = User(name: name, birthDay: birthDay, email: email, gender: gender, password: password)
        self.registerVM.registerUser(newUser: newUser)
    }
}

extension RegisterVC {
    
    func showValidationMessage(message: String) {
        let alertController = UIAlertController(title: "Upps", message: "Mohon isikan \(message) anda", preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func onRegisterSuccess() {
        let mainVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "Main")
        mainVC.modalPresentationStyle = .fullScreen
        self.navigationController?.present(mainVC, animated: true, completion: nil)
    }
}
