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

class MapVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private let mapVM = MapVM()
    private let disposeBag = DisposeBag()
    private let locationManager = CLLocationManager()
    private let regionRadius: CLLocationDistance = 1000
    private var konselors = [Konselor]()
    private let mapViewIdentifier = "MapViewAnnotationIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureMapView()
        self.bindViewModel()
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
    
    @IBAction func centeredUserLocation(_ sender: Any) {
        guard let userLocation = locationManager.location?.coordinate else {
            return
        }
        
        let coordinateRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension MapVC: MKMapViewDelegate {
    
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
