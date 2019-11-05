//
//  Message.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 02/11/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import Foundation

enum SenderType: String {
    case patient = "patient"
    case konselor = "konselor"
}

struct Message {
    var senderId: String
    var content: String
    var senderType: SenderType
}
