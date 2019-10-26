//
//  ListKonselorVM.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 13/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class ListKonselorVM {
    
    private let _konselors = BehaviorRelay<[Konselor]>(value: [])
    private let _hasError = BehaviorRelay<Bool>(value: false)
    private let _isSuccessFetchingKonselor = BehaviorRelay<Bool>(value: false)
    
    var konselors: Driver<[Konselor]> {
        return _konselors.asDriver()
    }
    
    var hasError: Driver<Bool> {
        return _hasError.asDriver()
    }
    
    var isSuccessFetchingKonselor: Driver<Bool> {
        return _isSuccessFetchingKonselor.asDriver()
    }
    
    func getKonselors() {
        DataService.shared.getKonselor(success: { [weak self] (konselors) in
            self?._konselors.accept(konselors)
            self?._isSuccessFetchingKonselor.accept(true)
        }) { [weak self] in
            self?._hasError.accept(true)
        }
    }
    
    func observeKonselor() {
        DataService.shared.REF_KONSELOR.observe(.value) { [weak self] (_) in
            self?.getKonselors()
        }
    }
}
