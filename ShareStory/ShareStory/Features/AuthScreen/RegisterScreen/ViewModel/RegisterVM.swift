//
//  RegisterVM.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 10/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth

class RegisterVM {
    
    private let _registerSuccess = BehaviorRelay<Bool>(value: false)
    private let _registerFailed = BehaviorRelay<Bool>(value: false)
    private let _loading = BehaviorRelay<Bool>(value: false)
    
    var registerSuccess: Driver<Bool> {
        return _registerSuccess.asDriver()
    }
    
    var registerFailed: Driver<Bool> {
        return _registerFailed.asDriver()
    }
    
    var loading: Driver<Bool> {
        return _loading.asDriver()
    }
    
    func registerUser(newUser: User) {
        self._loading.accept(true)
        DataService.shared.registerUser(newUser: newUser, success: { [weak self] (success) in
            self?._loading.accept(false)
            self?._registerSuccess.accept(true)
        }) { [weak self] (error) in
            self?._loading.accept(false)
            self?._registerFailed.accept(true)
        }
    }
}
