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
    
    private let loginGuideVC = UIStoryboard.init(name: "Main", bundle: nil)
        .instantiateViewController(identifier: "LoginGuideVC")
    private let profileVM = ProfileVM()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.checkCurrentUser()
        self.bindViewModel()
    }
    
    fileprivate func bindViewModel() {
        self.profileVM.isUserExist
            .drive(onNext: { [unowned self] isUserExist in
                if !isUserExist {
                    self.view.addSubview(self.loginGuideVC.view)
                    self.addChild(self.loginGuideVC)
                    self.loginGuideVC.didMove(toParent: self)
                } else {
                    self.loginGuideVC.willMove(toParent: nil)
                    self.loginGuideVC.removeFromParent()
                    self.loginGuideVC.view.removeFromSuperview()
                    self.profileVM.getUserData()
                }
            }).disposed(by: disposeBag)
        
        self.profileVM.userProfile
            .drive(onNext: { [unowned self] userProfile in
                guard let userProfile = userProfile else {
                    return
                }
                self.setupView(user: userProfile)
            }).disposed(by: disposeBag)
        
        self.profileVM.hasError
            .drive(onNext: { [unowned self] hasError in
                if hasError {
                    self.showErrorMessage()
                }
            }).disposed(by: disposeBag)
    }
    
    fileprivate func checkCurrentUser() {
        self.profileVM.checkCurrentUser()
    }
    
    fileprivate func setupView(user: User) {
        self.userImageView.image = UIImage(named: (user.gender == .male) ? "boy":"girl")
        self.userNameLabel.text = user.name
        self.userEmailLabel.text = user.email
        self.userAgeLabel.text = user.birthDay
    }
    
    @IBAction func logout(_ sender: Any) {
        DataService.shared.logout { [unowned self] (success) in
            if success {
                
            } else {
                self.showErrorMessage()
            }
        }
    }
    
    @IBAction func editProfile(_ sender: Any) {
        
    }
}
