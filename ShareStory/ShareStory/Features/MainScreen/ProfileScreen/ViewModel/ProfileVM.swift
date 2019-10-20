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

class ProfileVM {
    
    private let _userProfile = BehaviorRelay<User?>(value: nil)
    private let _hasError = BehaviorRelay<Bool>(value: false)
    private let _isUserExist = BehaviorRelay<Bool>(value: false)
    
    var userProfile: Driver<User?> {
        return _userProfile.asDriver()
    }
    
    var hasError: Driver<Bool> {
        return _hasError.asDriver()
    }
    
    var isUserExist: Driver<Bool> {
        return _isUserExist.asDriver()
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
}
