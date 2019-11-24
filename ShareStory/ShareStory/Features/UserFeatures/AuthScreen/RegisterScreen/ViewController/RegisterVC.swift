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
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    //MARK:- Private properties here
    private var gender: Gender = .male
    private let registerVM = RegisterVM()
    private let disposeBag = DisposeBag()
    private let datePicker = UIDatePicker()
    
    //MARK:- ViewController's lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindViewModel()
        self.setupDatePicker()
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
        
        self.registerVM.loading
            .drive(onNext: { [unowned self] loading in
                if loading {
                    self.loadingSpinner.startAnimating()
                } else {
                    self.loadingSpinner.stopAnimating()
                }
            }).disposed(by: disposeBag)
    }
    
    fileprivate func setupDatePicker() {
        self.datePicker.maximumDate = Date()
        self.datePicker.datePickerMode = .date
        birthDayTextField.inputView = datePicker
        self.birthDayTextField.addTarget(self, action: #selector(self.onPickedDate), for: .editingDidEnd)
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
    
    @IBAction func backToLogin(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- Extension here

extension RegisterVC {
    
    func onRegisterSuccess() {
        let mainVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "Main")
        mainVC.modalPresentationStyle = .fullScreen
        self.navigationController?.present(mainVC, animated: true, completion: nil)
    }
    
    func onRegisterFailed() {
        let alertController = UIAlertController(title: "Upps", message: "Sepertinya ada kesalahan dalam pengisian data anda, silahkan periksa kembali", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func onPickedDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        birthDayTextField.text = formatter.string(from: self.datePicker.date)
    }
}
