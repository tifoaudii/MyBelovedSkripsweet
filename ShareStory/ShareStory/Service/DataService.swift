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
    
    //MARK:- Global State
    var userLocation: CLLocation?
    var geoCoder = CLGeocoder()
    
    //MARK:- DB Ref
    var REF_USER: DatabaseReference { return _REF_USER }
    var REF_KONSELOR: DatabaseReference { return _REF_KONSELOR }
    var REF_ORDER: DatabaseReference { return _REF_ORDER }
    
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
    
    func createOrder(order: Order, completion: @escaping (_ success: Bool)->()) {
        
        let newOrder = [
            "senderId": order.senderId,
            "konselorId": order.konselorId,
            "status": order.status.rawValue
        ]
        
        REF_ORDER.childByAutoId().updateChildValues(newOrder)
        completion(true)
    }
    
    func updateUserProfile(name: String, birthday: String, gender: Gender, completion: @escaping (_ success: Bool)-> (), failure: @escaping ()->()) {
        
        guard let uid = self.userId else {
            failure()
            return
        }
        
        let updatedProfile = [
            "name": name,
            "birthday": birthday,
            "gender": gender.rawValue
        ]
        
        REF_USER.child(uid).updateChildValues(updatedProfile)
        completion(true)
    }
    
    func getRequestOrderFromUser(completion: @escaping (_ orders: [RequestOrder])-> (), failure: @escaping ()->()) {
        var ownerOrder = Dictionary<String,String>()
        
        REF_ORDER.observeSingleEvent(of: .value) { [unowned self] (dataSnapshot) in
            guard let ordersSnapshot = dataSnapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            
            guard let uid = self.userId else {
                return
            }
            
            for order in ordersSnapshot {
                let konselorId = order.childSnapshot(forPath: "konselorId").value as! String
                let patientId = order.childSnapshot(forPath: "senderId").value as! String
                
                if konselorId == uid {
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
                    let requestOrder = RequestOrder(orderId: orderKey ?? "", sender: patient)
                    requestOrders.append(requestOrder)
                }
            }
            completion(requestOrders)
        }
    }
}
