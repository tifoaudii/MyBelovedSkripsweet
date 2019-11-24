//
//  ChatVM.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 22/11/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

class ChatVM {
    
    private let _konselor = BehaviorRelay<Konselor?>(value: nil)
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
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let newMessage = Message(senderId: uid, content: content, senderType: .patient)
        DataService.shared.sendMessage(message: newMessage, chatRoom: chatRoom) { _ in }
    }
    
    func fetchMessages(chatRoom: ChatRoom) {
        DataService.shared.fetchKonselorMessages(chatRoom: chatRoom, completion: { [weak self] (message, konselor) in
            self?._messages.accept(message)
            self?._konselor.accept(konselor)
        }) { [weak self] in
            self?._hasError.accept(true)
        }
    }
    
    func observeMessage(chatRoom: ChatRoom) {
        DataService.shared.REF_CHATROOM.child(chatRoom.id).observe(.value) { [weak self] (_) in
            self?.fetchMessages(chatRoom: chatRoom)
        }
    }
    
    func viewModelForMessages(at index: Int) -> KonselorMessageVM? {
        guard index < numberOfMessages, let konselor = _konselor.value else {
            return nil
        }
        
        return KonselorMessageVM(message: _messages.value[index], konselor: konselor)
    }
}
