//
//  DataService.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 10/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import MapKit
import CoreLocation

class DataService {
    
    static let shared = DataService()
    private init(){}
    let userId = Auth.auth().currentUser?.uid
    var userDefault = UserDefaults.standard
    
    var konselorUid: String {
        get { return userDefault.value(forKey: "konselor_uid") as! String }
        set { userDefault.set(newValue, forKey: "konselor_uid") }
    }
    
    var isKonselorLoggedIn: Bool {
        get { return userDefault.bool(forKey: "konselor_loggedIn") }
        set { userDefault.set(newValue, forKey: "konselor_loggedIn") }
    }
    
    //MARK:- Global State
    var userLocation: CLLocation?
    var geoCoder = CLGeocoder()
    
    //MARK:- DB Ref
    var REF_USER: DatabaseReference { return _REF_USER }
    var REF_KONSELOR: DatabaseReference { return _REF_KONSELOR }
    var REF_ORDER: DatabaseReference { return _REF_ORDER }
    var REF_CHATROOM: DatabaseReference { return _REF_CHATROOM }
    
    //MARK:- Helper Function
    func registerUser(newUser: User, success: @escaping (_ success: Bool)-> Void, failure: @escaping (_ fail: Bool)-> Void) {
        Auth.auth().createUser(withEmail: newUser.email, password: newUser.password) { (result, error) in
            
            if error != nil  {
                failure(true)
            }
            
            guard let result = result, let email = result.user.email else {
                failure(true)
                return
            }
            
            let userData : [String: String] = [
                "email": email,
                "name": newUser.name,
                "gender": newUser.gender.rawValue,
                "birthday": newUser.birthDay
            ]
            
            DispatchQueue.global(qos: .utility).async { [unowned self] in
                self.postNewUser(uid: result.user.uid, userAccount: userData)
            }
            
            success(true)
        }
    }
    
    func loginUser(email: String, password: String, success: @escaping () -> (), failure: @escaping ()->()) {
        Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
            if error != nil {
                failure()
            }
            success()
        }
    }
    
    func loginKonselor(email: String, password: String, success: @escaping ()->(), failure: @escaping ()->()) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                failure()
            }
            
            guard let result = result else {
                return failure()
            }
            
            if let konselorLocation = self.userLocation {
                DispatchQueue.global(qos: .background).async { [unowned self] in
                    self.updateKonselorOnlineStatus(konselor: result.user.uid, konselor: konselorLocation)
                }
            }
            
            success()
        }
    }
    
    func updateKonselorOnlineStatus(konselor uid: String, konselor location: CLLocation) {
        self.geoCoder.reverseGeocodeLocation(location) { [unowned self] (placemark, _) in
            if let placeName = placemark?.first {
                let konselorAddress = "\(placeName)"
                self.REF_KONSELOR.child(uid).updateChildValues(["isOnline": true, "address": konselorAddress])
                self.REF_KONSELOR.child(uid).child("location").updateChildValues(["latitude": location.coordinate.latitude, "longitude": location.coordinate.longitude])
            }
        }
    }
    
    func logout(completion: @escaping (_ success: Bool)-> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch {
            print(error)
            completion(false)
        }
    }
    
    func postNewUser(uid: String, userAccount: Dictionary<String, String>) {
        REF_USER.child(uid).updateChildValues(userAccount)
    }
    
    func updateUserLocation(uid: String, location: Dictionary<String, Double>, completion: @escaping ()-> Void) {
        REF_USER.child(uid).child("location").updateChildValues(location)
        completion()
    }
    
    func getKonselor(success: @escaping (_ konselor: [Konselor]) -> (), failure: @escaping ()-> ()) {
        
        var konselorArray = [Konselor]()
        REF_KONSELOR.observeSingleEvent(of: .value) { [unowned self] (dataSnapshot) in
            guard let rawKonselor = dataSnapshot.children.allObjects as? [DataSnapshot] else {
                failure()
                return
            }
            
            for konselor in rawKonselor {
                let name = konselor.childSnapshot(forPath: "name").value as! String
                let address = konselor.childSnapshot(forPath: "address").value as! String
                let university = konselor.childSnapshot(forPath: "university").value as! String
                let latitude = konselor.childSnapshot(forPath: "location").childSnapshot(forPath: "latitude").value as! Double
                let longitude = konselor.childSnapshot(forPath: "location").childSnapshot(forPath: "longitude").value as! Double
                let isOnline = konselor.childSnapshot(forPath: "isOnline").value as! Bool
                let distance = self.calculateDistance(konselor: latitude, konselor: longitude)
                
                let newKonselor = Konselor(id: konselor.key, name: name, address: address, university: university, latitude: latitude, longitude: longitude, isOnline: isOnline, distance: distance)
                
                if newKonselor.isOnline {
                    konselorArray.append(newKonselor)
                }
            }
            konselorArray = konselorArray.sorted(by: { $0.distance < $1.distance })
            success(konselorArray)
        }
    }
    
    func calculateDistance(konselor latitude: Double, konselor longitude: Double) -> Double {
        guard let userCoordinate = self.userLocation else {
            return 0
        }
        let konselorCoordinate = CLLocation(latitude: latitude, longitude: longitude)
        let distanceInKm: Double = userCoordinate.distance(from: konselorCoordinate) / 1000
        return round(100 * distanceInKm)/100
    }
    
    func getCurrentUser(completion: @escaping (_ isUserExist: Bool) -> Void) {
        let currentUser = Auth.auth().currentUser
        let isUserExist = (currentUser != nil) ? true:false
        completion(isUserExist)
    }
    
    func getUserProfile(completion: @escaping (_ user: User)-> Void, failure: @escaping (_ fail: Bool) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            failure(true)
            return
        }
        
        REF_USER.observeSingleEvent(of: .value) { (dataSnapshot) in
            guard let usersSnapshot = dataSnapshot.children.allObjects as? [DataSnapshot] else {
                failure(true)
                return
            }
            for user in usersSnapshot {
                if user.key == uid {
                    let name = user.childSnapshot(forPath: "name").value as! String
                    let birthday = user.childSnapshot(forPath: "birthday").value as! String
                    let email = user.childSnapshot(forPath: "email").value as! String
                    let gender = user.childSnapshot(forPath: "gender").value as! String
                    
                    let currentUser = User(name: name, birthDay: birthday, email: email, gender: Gender(rawValue: gender)!, password: "")
                    completion(currentUser)
                    break
                }
            }
        }
    }
    
    func getKonselorProfile(uid: String,completion: @escaping (_ konselor: Konselor) -> Void, failure: @escaping ()->()) {
        REF_KONSELOR.observeSingleEvent(of: .value) { (konselorSnapshot) in
            guard let konselorSnapshot = konselorSnapshot.children.allObjects as? [DataSnapshot] else {
                failure()
                return
            }
            
            for konselor in konselorSnapshot {
                if konselor.key == uid {
                    let name = konselor.childSnapshot(forPath: "name").value as! String
                    let address = konselor.childSnapshot(forPath: "address").value as! String
                    let university = konselor.childSnapshot(forPath: "university").value as! String
                    let latitude = konselor.childSnapshot(forPath: "location").childSnapshot(forPath: "latitude").value as! Double
                    let longitude = konselor.childSnapshot(forPath: "location").childSnapshot(forPath: "longitude").value as! Double
                    let isOnline = konselor.childSnapshot(forPath: "isOnline").value as! Bool
                    let distance = self.calculateDistance(konselor: latitude, konselor: longitude)
                    
                    let currentKonselor = Konselor(id: konselor.key, name: name, address: address, university: university, latitude: latitude, longitude: longitude, isOnline: isOnline, distance: distance)
                    completion(currentKonselor)
                    break
                }
            }
        }
    }
    
    func getPatientProfile(with uid: String, completion: @escaping (_ user: User) -> Void, failure: @escaping ()->()) {
        
        REF_USER.observeSingleEvent(of: .value) { (dataSnapshot) in
            guard let usersSnapshot = dataSnapshot.children.allObjects as? [DataSnapshot] else {
                failure()
                return
            }
            
            for user in usersSnapshot {
                if user.key == uid {
                    let name = user.childSnapshot(forPath: "name").value as! String
                    let birthday = user.childSnapshot(forPath: "birthday").value as! String
                    let email = user.childSnapshot(forPath: "email").value as! String
                    let gender = user.childSnapshot(forPath: "gender").value as! String
                    
                    let currentUser = User(name: name, birthDay: birthday, email: email, gender: Gender(rawValue: gender)!, password: "")
                    completion(currentUser)
                    break
                }
            }
        }
    }
    
    func createOrder(order: Order, completion: @escaping (_ success: Bool, _ orderId: String)->()) {
        
        let newOrder = [
            "senderId": order.senderId,
            "konselorId": order.konselorId,
            "status": order.status.rawValue
        ]
        
        guard let newOrderId = REF_ORDER.childByAutoId().key else {
            return
        }
        
        REF_ORDER.child(newOrderId).updateChildValues(newOrder)
        completion(true, newOrderId)
    }
    
    func updateUserProfile(name: String, birthday: String, gender: Gender, completion: @escaping (_ success: Bool)-> (), failure: @escaping ()->()) {
        
        guard let uid = self.userId else {
            failure()
            return
        }
        
        let updatedProfile = [
            "name": name,
            "birthday": birthday,
            "gender": gender.rawValue,
            "info": ""
        ]
        
        REF_USER.child(uid).updateChildValues(updatedProfile)
        completion(true)
    }
    
    func acceptOrder(order: RequestOrderVM, completion: @escaping (_ chatroom: ChatRoom)->()) {
        REF_ORDER.child(order.orderId).updateChildValues(["status": OrderStatus.accepted.rawValue])
        
        DispatchQueue.main.async { [unowned self] in
            self.REF_CHATROOM.childByAutoId()
                .updateChildValues([
                    "orderId": order.orderId,
                    "patientId": order.patientId,
                    "konselorId": self.konselorUid,
                    "status": ChatRoomStatus.ungoing.rawValue
                ])
            
            self.REF_CHATROOM.observeSingleEvent(of: .value) { (dataSnapshot) in
                guard let chatRoomSnapshot = dataSnapshot.children.allObjects.last as? DataSnapshot else {
                    return
                }
                
                let newChatRoom = ChatRoom(id: chatRoomSnapshot.key, patientId: order.patientId, konselorId: self.konselorUid, status: .ungoing)
                completion(newChatRoom)
            }
        }
    }
    
    func declineOrder(orderId: String, message: String, completion: @escaping (_ success: Bool)->()) {
        REF_ORDER.child(orderId).updateChildValues(["status": OrderStatus.refused.rawValue, "info": message])
        completion(true)
    }
    
    func getRequestOrderFromUser(completion: @escaping (_ orders: [RequestOrder])-> (), failure: @escaping ()->()) {
        var ownerOrder = Dictionary<String,String>()
        
        REF_ORDER.observeSingleEvent(of: .value) { [unowned self] (dataSnapshot) in
            guard let ordersSnapshot = dataSnapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            
            let uid = self.konselorUid
            
            for order in ordersSnapshot {
                let konselorId = order.childSnapshot(forPath: "konselorId").value as! String
                let patientId = order.childSnapshot(forPath: "senderId").value as! String
                let status = order.childSnapshot(forPath: "status").value as! String
                
                if konselorId == uid && status == OrderStatus.waiting.rawValue  {
                    ownerOrder["\(patientId)"] = order.key
                }
            }
            
            self.decodeDataIntoRequestOrder(with: ownerOrder, completion: { (requestOrder) in
                completion(requestOrder)
            }) {
                failure()
            }
        }
    }
    
    
    func decodeDataIntoRequestOrder(with orders: Dictionary<String,String>, completion: @escaping (_ orders: [RequestOrder])-> (), failure: @escaping ()->()) {
        
        REF_USER.observeSingleEvent(of: .value) { (userSnapshot) in
            
            var requestOrders = [RequestOrder]()
            
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {
                return failure()
            }
            
            for user in userSnapshot {
                if orders.keys.contains(user.key) {
                    
                    let name = user.childSnapshot(forPath: "name").value as! String
                    let birthday = user.childSnapshot(forPath: "birthday").value as! String
                    let email = user.childSnapshot(forPath: "email").value as! String
                    let gender = user.childSnapshot(forPath: "gender").value as! String
                    
                    let patient = User(name: name, birthDay: birthday, email: email, gender: Gender(rawValue: gender)!, password: "")
                    let orderKey = orders["\(user.key)"]
                    let requestOrder = RequestOrder(orderId: orderKey ?? "", sender: patient, senderId: user.key)
                    requestOrders.append(requestOrder)
                }
            }
            completion(requestOrders)
        }
    }
    
    func fetchKonselorMessages(
        chatRoom: ChatRoom,
        completion: @escaping (_ messages: [Message], _ konselor: Konselor)-> Void,
        failure: @escaping ()-> Void) {
        
        var messages = [Message]()
        
        REF_CHATROOM.child(chatRoom.id).child("messages").observeSingleEvent(of: .value) { (messageSnapshot) in
            guard let messageSnapshot = messageSnapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            
            for message in messageSnapshot {
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderId").value as! String
                let senderType = message.childSnapshot(forPath: "senderType").value as! String
                
                let newMessage = Message(senderId: senderId, content: content, senderType: SenderType(rawValue: senderType)!)
                messages.append(newMessage)
            }
        }
        
        self.getKonselorProfile(uid: chatRoom.konselorId, completion: { (konselor) in
            completion(messages, konselor)
        }) {
            failure()
        }
    }
    
    func fetchAllMessages(
        chatRoom: ChatRoom,
        completion: @escaping (_ messages: [Message], _ patient: User)-> Void,
        failure: @escaping ()-> Void) {
        
        var messages = [Message]()
        
        REF_CHATROOM.child(chatRoom.id).child("messages").observeSingleEvent(of: .value) { (messageSnapshot) in
            guard let messageSnapshot = messageSnapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            
            for message in messageSnapshot {
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderId").value as! String
                let senderType = message.childSnapshot(forPath: "senderType").value as! String
                
                let newMessage = Message(senderId: senderId, content: content, senderType: SenderType(rawValue: senderType)!)
                messages.append(newMessage)
            }
        }
        
        self.getPatientProfile(with: chatRoom.patientId, completion: { (patient) in
            let patient: User = patient
            DispatchQueue.main.async {
                completion(messages,patient)
            }
        }) {
            failure()
        }
    }
    
    func sendMessage(message: Message, chatRoom: ChatRoom, success: @escaping (_ success: Bool)->()) {
        
        let newMessage = [
            "content": message.content,
            "senderId": message.senderId,
            "senderType": message.senderType.rawValue
        ]
        
        REF_CHATROOM
            .child(chatRoom.id)
            .child("messages")
            .childByAutoId()
            .updateChildValues(newMessage)
        
        success(true)
    }
    
    func fetchAllAcceptedOrder(completion: @escaping (_ acceptedOrders: [AcceptedOrder]) -> (), failure: @escaping ()->()) {
        
        var acceptedOrderDict = Dictionary<String,ChatRoom>()
        REF_CHATROOM.observeSingleEvent(of: .value) { (dataSnapshot) in
            
            guard let chatRoomSnapshot = dataSnapshot.children.allObjects as? [DataSnapshot] else {
                return failure()
            }
            
            for chatRoom in chatRoomSnapshot {
                let konselorId = chatRoom.childSnapshot(forPath: "konselorId").value as! String
                let status = chatRoom.childSnapshot(forPath: "status").value as! String
                let patientId = chatRoom.childSnapshot(forPath: "patientId").value as! String
                let newChatRoom = ChatRoom(id: chatRoom.key, patientId: patientId, konselorId: konselorId, status: ChatRoomStatus(rawValue: status)!)
                
                if self.konselorUid == konselorId && status == ChatRoomStatus.ungoing.rawValue {
                    acceptedOrderDict["\(patientId)"] = newChatRoom
                }
            }
            
            self.decodeDataIntoAcceptedOrder(orderDict: acceptedOrderDict) { (acceptedOrders) in
                print(acceptedOrders)
                completion(acceptedOrders)
            }
        }
    }
    
    func decodeDataIntoAcceptedOrder(orderDict: Dictionary<String,ChatRoom>, completion: @escaping (_ acceptedOrders: [AcceptedOrder])->()) {
        
        var acceptedOrders = [AcceptedOrder]()
        
        REF_USER.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            
            for user in userSnapshot {
                if orderDict.keys.contains(user.key) {
                    let name = user.childSnapshot(forPath: "name").value as! String
                    let birthday = user.childSnapshot(forPath: "birthday").value as! String
                    let email = user.childSnapshot(forPath: "email").value as! String
                    let gender = user.childSnapshot(forPath: "gender").value as! String
                    
                    let patient = User(name: name, birthDay: birthday, email: email, gender: Gender(rawValue: gender)!, password: "")
                    let chatRoom = orderDict[user.key]
                    let acceptedOrder = AcceptedOrder(chatRoom: chatRoom!, patient: patient)
                    acceptedOrders.append(acceptedOrder)
                }
            }
            completion(acceptedOrders)
        }
    }
    
    func getChatRoom(orderId: String, completion: @escaping (_ chatRoom: ChatRoom)->(), failure: @escaping ()->()) {
        REF_CHATROOM.observeSingleEvent(of: .value) { (chatRoomSnapshot) in
            guard let chatRoomSnapshot = chatRoomSnapshot.children.allObjects as? [DataSnapshot] else {
                return failure()
            }
            
            for chatRoom in chatRoomSnapshot {
                let orderChatRoom = chatRoom.childSnapshot(forPath: "orderId").value as! String
                if orderChatRoom == orderId {
                    let konselorId = chatRoom.childSnapshot(forPath: "konselorId").value as! String
                    let patientId = chatRoom.childSnapshot(forPath: "patientId").value as! String
                    let status = chatRoom.childSnapshot(forPath: "status").value as! String
                    let currentChatRoom = ChatRoom(id: chatRoom.key, patientId: patientId, konselorId: konselorId, status: ChatRoomStatus.init(rawValue: status)!)
                    completion(currentChatRoom)
                    break
                }
            }
        }
    }
}
