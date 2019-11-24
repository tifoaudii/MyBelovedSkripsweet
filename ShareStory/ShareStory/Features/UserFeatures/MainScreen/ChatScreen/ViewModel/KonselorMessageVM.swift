//
//  KonselorMessageVM.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 22/11/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit

class KonselorMessageVM {
    
    private var message: Message
    private var konselor: Konselor
    
    init(message: Message, konselor: Konselor) {
        self.message = message
        self.konselor = konselor
    }
    
    var senderName: String {
        return konselor.name
    }
    
    var content: String {
        return message.content
    }
}
