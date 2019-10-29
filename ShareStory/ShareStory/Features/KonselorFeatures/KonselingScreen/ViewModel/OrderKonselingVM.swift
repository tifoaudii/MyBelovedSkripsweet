//
//  KonselingVM.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 26/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class OrderKonselingVM {
    
    private let _requestOrders = BehaviorRelay<[RequestOrder]>(value: [])
    private let _hasError = BehaviorRelay<Bool>(value: false)
    
    var requestOrders: Driver<[RequestOrder]> {
        return _requestOrders.asDriver()
    }
    
    var hasError: Driver<Bool> {
        return _hasError.asDriver()
    }
    
    var numberOfRequestOrders: Int {
        return _requestOrders.value.count
    }
    
    func fetchRequestOrders() {
        DataService.shared.getRequestOrderFromUser(completion: { [weak self] (requestOrders) in
            self?._requestOrders.accept(requestOrders)
            self?._hasError.accept(false)
        }) { [weak self] in
            self?._hasError.accept(true)
        }
    }
    
    func viewModelForOrder(at index: Int) -> RequestOrderVM? {
        guard index < _requestOrders.value.count else {
            return nil
        }
        
        return RequestOrderVM(with: _requestOrders.value[index])
    }
}
