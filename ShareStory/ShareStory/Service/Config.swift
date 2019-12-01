//
//  Config.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 10/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()
let _REF_BASE = DB_BASE
let _REF_USER = DB_BASE.child("user")
let _REF_KONSELOR = DB_BASE.child("konselor")
let _REF_ORDER = DB_BASE.child("order")
let _REF_CHATROOM = DB_BASE.child("chat_room")
let _REF_HISTORY = DB_BASE.child("history_order")

//MARK:- Important Constant
let USER_LOCATION_KEY = "user-location-key"

