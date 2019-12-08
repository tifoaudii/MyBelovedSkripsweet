//
//  SplashVC.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 09/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit
import RxSwift
import FirebaseAuth
import MapKit

class SplashVC: UIViewController {
   
   private let splashVM = SplashVM()
   private let disposeBag = DisposeBag()
   private let locationManager = CLLocationManager()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.bindViewModel()
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      guard let welcomeVC = segue.destination as? WelcomeVC else {
         return
      }
      
      welcomeVC.modalPresentationStyle = .fullScreen
   }
   
   fileprivate func bindViewModel() {
      
      if let _ = Auth.auth().currentUser {
         DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [unowned self] in
            if DataService.shared.isKonselorLoggedIn {
               self.navigateToMainKonselor()
            } else {
               self.navigataToMainScreen()
            }
         }
      } else {
         DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [unowned self] in
            self.performSegue(withIdentifier: "welcome_segue", sender: nil)
         }
      }
   }
   
   func navigateToMainKonselor() {
      let mainVC = UIStoryboard.init(name: "Konselor", bundle: nil).instantiateViewController(identifier: "KonselorMain")
      mainVC.modalPresentationStyle = .fullScreen
      self.present(mainVC, animated: true, completion: nil)
   }
   
   
}
