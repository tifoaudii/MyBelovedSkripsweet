//
//  ChatVM.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 31/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class KonselorChatVM {
    
    private let _patient = BehaviorRelay<User?>(value: nil)
    private let _messages = BehaviorRelay<[Message]>(value: [])
    private let _hasError = BehaviorRelay<Bool>(value: false)
    
    var messages: Driver<[Message]> {
        return _messages.asDriver()
    }
    
    var hasError: Driver<Bool> {
        return _hasError.asDriver()
    }
    
    var numberOfMessages: Int {
        return _messages.value.count
    }
    
    func sendMessage(content: String, chatRoom: ChatRoom) {
        let newMessage = Message(senderId: DataService.shared.konselorUid, content: content, senderType: .konselor)
        DataService.shared.sendMessage(message: newMessage, chatRoom: chatRoom) { _ in }
    }
    
    func fetchAllMessages(chatRoom: ChatRoom) {
        DataService.shared.fetchAllMessages(chatRoom: chatRoom, completion: { [weak self] (message, patient) in
            self?._messages.accept(message)
            self?._patient.accept(patient)
        }) { [weak self] in
            self?._hasError.accept(true)
        }
    }
    
    func observeMessage(chatRoom: ChatRoom) {
        DataService.shared.REF_CHATROOM.child(chatRoom.id).observe(.value) { [weak self] (_) in
            self?.fetchAllMessages(chatRoom: chatRoom)
        }
    }
    
    func viewModelForMessages(at index: Int) -> PatientMessageVM? {
        guard index < numberOfMessages, let patient = _patient.value else {
            return nil
        }
        
        return PatientMessageVM(message: _messages.value[index], patient: patient)
    }
}
