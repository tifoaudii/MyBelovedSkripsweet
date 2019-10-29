//
//  KonselorLoginVM.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 24/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation
import FirebaseAuth

class KonselorLoginVM {
    
    private var _isLoginSuccess = BehaviorRelay<Bool>(value: false)
    private var _isLoading = BehaviorRelay<Bool>(value: false)
    private var _hasError = BehaviorRelay<Bool>(value: false)
    
    var hasError: Driver<Bool> {
        return _hasError.asDriver()
    }
    
    var isLoginSuccess: Driver<Bool> {
        return _isLoginSuccess.asDriver()
    }
    
    var isLoading: Driver<Bool> {
        return _isLoading.asDriver()
    }
    
    func loginKonselor(email: String, password: String) {
        self._isLoading.accept(true)
        DataService.shared.loginKonselor(email: email, password: password, success: { [weak self] in
            self?._isLoading.accept(false)
            self?._hasError.accept(false)
            self?._isLoginSuccess.accept(true)
            self?.storeKonselorUid()
        }) { [weak self] in
            self?._isLoading.accept(false)
            self?._isLoginSuccess.accept(false)
            self?._hasError.accept(true)
        }
    }
    
    fileprivate func storeKonselorUid() {
        guard let konselorUid = Auth.auth().currentUser?.uid else {
            return
        }
        
        DataService.shared.konselorUid = konselorUid
        DataService.shared.isKonselorLoggedIn = true
    }
}
