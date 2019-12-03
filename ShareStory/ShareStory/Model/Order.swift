//
//  Order.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 23/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import Foundation

enum OrderStatus: String {
    case waiting = "Menunggu"
    case refused = "Ditolak"
    case accepted = "Diterima"
    case cancel = "Batal"
}

struct Order {
    var senderId: String
    var konselorId: String
    var status: OrderStatus
}

struct RequestOrder {
    var orderId: String
    var sender: User
    var senderId: String
}

struct AcceptedOrder {
    var chatRoom: ChatRoom
    var patient: User
}

struct Appointment {
    var konselorPhotoUrl: String
    var konselorName: String
    var date: String
}
