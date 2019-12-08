//
//  ProfileVC.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 14/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileVC: UIViewController {
    
    //MARK:- Outlet's Here
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userAgeLabel: UILabel!
    @IBOutlet weak var userGenderLabel: UILabel!
    @IBOutlet weak var historyView: UIView!
    @IBOutlet weak var appointmentView: UIView!
    
    private let loginGuideVC = UIStoryboard.init(name: "Main", bundle: nil)
        .instantiateViewController(identifier: "LoginGuideVC") as! LoginGuideVC
    private let profileVM = ProfileVM()
    private let disposeBag = DisposeBag()
    private var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.checkCurrentUser()
        self.bindViewModel()
        self.setupTapRecognizer()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? EditProfileVC else {
            return
        }
        
        destinationVC.delegate = self
        destinationVC.loadUserProfile(user: self.user!)
    }
    
    fileprivate func bindViewModel() {
        self.profileVM.isUserExist
            .drive(onNext: { [unowned self] isUserExist in
                if !isUserExist {
                    self.onUserExist()
                } else {
                    self.onUserNotExist()
                }
            }).disposed(by: disposeBag)
        
        self.profileVM.userProfile
            .drive(onNext: { [unowned self] userProfile in
                guard let userProfile = userProfile else {
                    return
                }
                self.user = userProfile
                self.setupView(user: userProfile)
            }).disposed(by: disposeBag)
        
        self.profileVM.hasError
            .drive(onNext: { [unowned self] hasError in
                if hasError {
                    self.showErrorMessage()
                }
            }).disposed(by: disposeBag)
        
        self.profileVM.isLogoutSuccess
            .drive(onNext: { [unowned self] isLogoutSuccess in
                if isLogoutSuccess {
                    self.navigateToWelcomeScreen()
                }
            }).disposed(by: disposeBag)
    }
    
    func setupTapRecognizer() {
        let historyTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.navigateToHistoryView))
        let appointmentTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.navigateToListAppointmentView))
        self.historyView.addGestureRecognizer(historyTapGesture)
        self.appointmentView.addGestureRecognizer(appointmentTapGesture)
    }
    
    fileprivate func checkCurrentUser() {
        self.profileVM.checkCurrentUser()
    }
    
    fileprivate func setupView(user: User) {
        self.userImageView.image = UIImage(named: (user.gender == .male) ? "boy":"girl")
        self.userNameLabel.text = user.name
        self.userEmailLabel.text = user.email
        let userAge = self.profileVM.calculateUserAge(birthday: user.birthDay)
        self.userAgeLabel.text = "\(userAge) Tahun"
        self.userGenderLabel.text = user.gender.rawValue
    }
    
    @IBAction func logout(_ sender: Any) {
        self.showAlertLogout()
    }
    
    @IBAction func editProfile(_ sender: Any) {}
}

extension ProfileVC: UpdateProfileDelegate {
    
    func navigateToWelcomeScreen() {
        let welcomeVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "WelcomeVC") as WelcomeVC
        welcomeVC.modalPresentationStyle = .fullScreen
        self.present(welcomeVC, animated: true, completion: nil)
    }
    
    @objc func navigateToHistoryView() {
        let historyVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "HistoryVC") as HistoryVC
        self.navigationController?.pushViewController(historyVC, animated: true)
    }
    
    @objc func navigateToListAppointmentView() {
        let appointmentVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "AppointmentVC") as AppointmentVC
        self.navigationController?.pushViewController(appointmentVC, animated: true)
    }
    
    func didUpdatedProfile() {
        self.profileVM.getUserData()
    }
    
    func showAlertLogout() {
        let alertController = UIAlertController(title: "Mohon Perhatian", message: "Apakah anda yakin ingin keluar?", preferredStyle: .alert)
        let logoutAction = UIAlertAction(title: "Ya", style: .default) { [unowned self] (_) in
            self.profileVM.logout()
        }
        let cancelAction = UIAlertAction(title: "Batalkan", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(logoutAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func onUserExist() {
        self.view.addSubview(self.loginGuideVC.view)
        self.addChild(self.loginGuideVC)
        self.loginGuideVC.didMove(toParent: self)
        self.loginGuideVC.isDismissButtonHidden(isHidden: true)
    }
    
    func onUserNotExist() {
        self.loginGuideVC.willMove(toParent: nil)
        self.loginGuideVC.removeFromParent()
        self.loginGuideVC.view.removeFromSuperview()
        self.profileVM.getUserData()
    }
}
