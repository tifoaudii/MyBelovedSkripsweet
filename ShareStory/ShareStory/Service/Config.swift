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

