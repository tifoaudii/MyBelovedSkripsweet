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

class DataService {
    
    static let shared = DataService()
    private init(){}
    
    //MARK:- DB Ref
    var REF_USER: DatabaseReference { return _REF_USER }
    var REF_KONSELOR: DatabaseReference { return _REF_KONSELOR }
    
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
    
    func postNewUser(uid: String, userAccount: Dictionary<String, String>) {
        REF_USER.child(uid).updateChildValues(userAccount)
    }
    
    func updateUserLocation(uid: String, location: Dictionary<String, Double>, completion: @escaping ()-> Void) {
        REF_USER.child(uid).child("location").updateChildValues(location)
        completion()
    }
    
    func getKonselor(success: @escaping (_ konselor: [Konselor]) -> (), failure: @escaping ()-> ()) {
        
        var konselorArray = [Konselor]()
        REF_KONSELOR.observeSingleEvent(of: .value) { (dataSnapshot) in
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
                
                let newKonselor = Konselor(name: name, address: address, university: university, latitude: latitude, longitude: longitude, isOnline: isOnline)
                
                if newKonselor.isOnline {
                    konselorArray.append(newKonselor)
                }
            }
            
            success(konselorArray)
        }
    }
}
