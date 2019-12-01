//
//  HistoryChatVM.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 30/11/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HistoryChatVM {
    
    private let _messages = BehaviorRelay<[Message]>(value: [])
    private let _hasError = BehaviorRelay<Bool>(value: false)
    private let _isKonselingFinished = BehaviorRelay<Bool>(value: false)
    
    var messages: Driver<[Message]> {
        return _messages.asDriver()
    }
    
    var hasError: Driver<Bool> {
        return _hasError.asDriver()
    }
    
    var numberOfMessages: Int {
        return _messages.value.count
    }
    
    func fetchMessages(chatRoom: ChatRoom) {
        DataService.shared.fetchKonselorMessages(chatRoom: chatRoom, completion: { [weak self] (message, konselor) in
            self?._messages.accept(message)
//            self?._konselor.accept(konselor)
        }) { [weak self] in
            self?._hasError.accept(true)
        }
    }
}
