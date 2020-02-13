//
//  MapVC.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 12/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa
import FirebaseAuth

class MapVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var centerButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    
    private let mapVM = MapVM()
    private let disposeBag = DisposeBag()
    private let locationManager = CLLocationManager()
    private let regionRadius: CLLocationDistance = 5000
    private var konselors = [Konselor]()
    private let mapViewIdentifier = "MapViewAnnotationIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureMapView()
        self.bindViewModel()
        self.checkLocationAuthorization()
        centerButton.layer.cornerRadius = centerButton.frame.width / 2
        centerButton.layer.borderWidth = 0.5
        centerButton.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        if Auth.auth().currentUser != nil {
            self.dismissButton.isHidden = true
        }
            
    }
   
    fileprivate func bindViewModel() {
        self.mapVM.observeKonselor()
        self.mapVM
            .hasError
            .drive(onNext: { [unowned self] hasError in
                if hasError {
                    self.showErrorMessage()
                }
            }).disposed(by: disposeBag)
        
        self.mapVM
            .konselors
            .drive(onNext: { [unowned self] konselors in
                self.konselors.removeAll()
                self.konselors.append(contentsOf: konselors)
                self.refreshMapView()
            }).disposed(by: disposeBag)
    }
    
    fileprivate func configureMapView() {
        self.mapView.delegate = self
        self.locationManager.delegate = self
        self.mapView.showsUserLocation = true
        guard let userLocation = locationManager.location?.coordinate else {
            return
        }
        
        let coordinateRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
    
    fileprivate func checkLocationAuthorization() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    @IBAction func personButtonDidClicked(_ sender: Any) {
        
    }
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func centeredUserLocation(_ sender: Any) {
        guard let userLocation = locationManager.location?.coordinate else {
            return
        }
        
        let coordinateRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension MapVC: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.configureMapView()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? Konselor else { return nil }
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: mapViewIdentifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
            view.displayPriority = .required
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: mapViewIdentifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: -5)
            view.displayPriority = .required
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard let konselor = view.annotation as? Konselor else {
            return
        }
        
        let detailKonselorVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "DetailKonselor") as DetailKonselorVC
        detailKonselorVC.loadKonselor(konselor: konselor)
        self.navigationController?.present(detailKonselorVC, animated: true, completion: nil)
    }
    
    fileprivate func refreshMapView() {
        let currentAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(currentAnnotations)
        self.mapView.addAnnotations(self.konselors)
    }
    
    fileprivate func removeAllAnnotations() {
        let currentAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(currentAnnotations)
    }
}
