//
//  OrderVM.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 23/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class OrderVM {
    
    private let _isUserExist = BehaviorRelay<Bool>(value: false)
    private let _isOrderSuccess = BehaviorRelay<Bool>(value: false)
    
    var isUserExist: Driver<Bool> {
        return _isUserExist.asDriver()
    }
    
    var isOrderSuccess: Driver<Bool> {
        return _isOrderSuccess.asDriver()
    }
    
    func getCurrentUser() {
        DataService.shared.getCurrentUser { (isUserExist) in
            if isUserExist {
                self._isUserExist.accept(true)
            }
        }
    }
    
    func createOrder(konselorId: String) {
        guard let userId = DataService.shared.userId else {
            return
        }
        
        let newOrder = Order(senderId: userId, konselorId: konselorId, status: .waiting)
        DataService.shared.createOrder(order: newOrder) { [weak self] (orderSuccess) in
            if orderSuccess {
                self?._isOrderSuccess.accept(true)
            }
        }
    }
}
