//
//  ChatRoom.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 31/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import Foundation

enum ChatRoomStatus: String {
    case done = "done"
    case ungoing = "ungoing"
}

struct ChatRoom {
    var id: String
    var patientId: String
    var konselorId: String
    var status: ChatRoomStatus
}
