//
//  EditProfileVC.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 17/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EditProfileVC: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    
    private var gender: Gender = .male
    private let profileVM = ProfileVM()
    private let disposeBag = DisposeBag()
    private var user: User?
    private let datePicker = UIDatePicker()
    var delegate: UpdateProfileDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setupDatePicker()
        self.bindViewModel()
    }
    
    fileprivate func bindViewModel() {
        self.profileVM.isUpdateProfileSuccess
            .drive(onNext: { [unowned self] isUpdateProfileSuccess in
                if isUpdateProfileSuccess {
                    self.onUpdateProfileSuccess()
                }
            }).disposed(by: disposeBag)
        
        self.profileVM.hasError
            .drive(onNext: { [unowned self] hasError in
                if hasError {
                    self.onUpdateProfileFailed()
                }
            }).disposed(by: disposeBag)
    }
    
    fileprivate func setupView() {
        guard user != nil else {
            return
        }
        
        self.nameTextField.text = user?.name
        self.birthdayTextField.text = user?.birthDay
        
        if user?.gender == .male {
            self.setGenderToMale()
        } else {
            self.setGenderToFemale()
        }
    }
    
    fileprivate func setupDatePicker() {
        self.datePicker.maximumDate = Date()
        self.datePicker.datePickerMode = .date
        birthdayTextField.inputView = datePicker
        self.birthdayTextField.addTarget(self, action: #selector(self.onPickedDate), for: .editingDidEnd)
    }
    
    @IBAction func maleButtonDidClicked(_ sender: Any) {
        self.setGenderToMale()
    }
    
    @IBAction func femaleButtonDidClicked(_ sender: Any) {
       self.setGenderToFemale()
    }
    
    @IBAction func submitButtonDidClicked(_ sender: Any) {
        guard let name = nameTextField.text, !nameTextField.text!.isEmpty else {
            return self.showValidationMessage(message: "Nama")
        }
        
        guard let birthDay = birthdayTextField.text, !birthdayTextField.text!.isEmpty else {
            return self.showValidationMessage(message: "tanggal lahir")
        }
        
        self.profileVM.updateUserProfile(name: name, birthday: birthDay, gender: self.gender)
    }
}

extension EditProfileVC {
    
    @objc func onPickedDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        birthdayTextField.text = formatter.string(from: self.datePicker.date)
    }
    
    func setGenderToMale() {
        maleButton.setBackgroundImage(UIImage.init(systemName: "circle.fill")?.withTintColor(.systemTeal), for: .normal)
        femaleButton.setBackgroundImage(UIImage.init(systemName: "circle")?.withTintColor(.systemTeal, renderingMode: .alwaysOriginal), for: .normal)
        self.gender = .male
    }
    
    func setGenderToFemale() {
        maleButton.setBackgroundImage(UIImage.init(systemName: "circle")?.withTintColor(.systemTeal), for: .normal)
        femaleButton.setBackgroundImage(UIImage.init(systemName: "circle.fill")?.withTintColor(.systemTeal, renderingMode: .alwaysOriginal), for: .normal)
        self.gender = .female
    }
    
    func onUpdateProfileSuccess() {
        self.delegate?.didUpdatedProfile()
        self.navigationController?.popViewController(animated: true)
    }
    
    func onUpdateProfileFailed() {
        self.showErrorMessage()
    }
    
    open func loadUserProfile(user: User) {
        self.user = user
    }
}
