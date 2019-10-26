//
//  ProfileVM.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 14/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol UpdateProfileDelegate {
    func didUpdatedProfile()
}

class ProfileVM {
    
    private let _userProfile = BehaviorRelay<User?>(value: nil)
    private let _hasError = BehaviorRelay<Bool>(value: false)
    private let _isUserExist = BehaviorRelay<Bool>(value: false)
    private let _isLogoutSuccess = BehaviorRelay<Bool>(value: false)
    private let _isUpdateProfileSuccess = BehaviorRelay<Bool>(value: false)
    
    var userProfile: Driver<User?> {
        return _userProfile.asDriver()
    }
    
    var hasError: Driver<Bool> {
        return _hasError.asDriver()
    }
    
    var isUserExist: Driver<Bool> {
        return _isUserExist.asDriver()
    }
    
    var isLogoutSuccess: Driver<Bool> {
        return _isLogoutSuccess.asDriver()
    }
    
    var isUpdateProfileSuccess: Driver<Bool> {
        return _isUpdateProfileSuccess.asDriver()
    }
    
    func updateUserProfile(name: String, birthday: String, gender: Gender) {
        DataService.shared.updateUserProfile(name: name, birthday: birthday, gender: gender, completion: { [weak self] (isUpdateUserProfileSuccess) in
            if isUpdateUserProfileSuccess {
                self?._isUpdateProfileSuccess.accept(true)
            }
        }) { [weak self] in
            self?._hasError.accept(true)
        }
    }
    
    func calculateUserAge(birthday: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        let dateOfBirth = dateFormatter.date(from: birthday)
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year], from: dateOfBirth!, to: Date())
        return dateComponents.year ?? 0
    }
    
    func getUserData() {
        DataService.shared.getUserProfile(completion: { [weak self] (user) in
            self?._userProfile.accept(user)
            self?._hasError.accept(false)
        }) { [weak self] (failure) in
            self?._hasError.accept(true)
        }
    }
    
    func checkCurrentUser() {
        DataService.shared.getCurrentUser { [weak self] (isUserExist) in
            if isUserExist {
                self?._isUserExist.accept(true)
            }
        }
    }
    
    func logout() {
        DataService.shared.logout { [weak self] (success) in
            if success {
                self?._isLogoutSuccess.accept(true)
            } else {
                self?._isLogoutSuccess.accept(false)
            }
        }
    }
}
