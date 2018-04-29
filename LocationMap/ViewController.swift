//
//  ViewController.swift
//  LocationMap
//
//  Created by Yerassyl Duisenbi on 22.04.2018.
//  Copyright © 2018 Yerassyl Duisenbi. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapkitView: MKMapView!
    
    let regionRadius: CLLocationDistance = 15000
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapkitView.delegate = self
        mapkitView.showsScale = true
        mapkitView.showsPointsOfInterest = true
        mapkitView.showsUserLocation = true
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        mapkitView.showsCompass = false
        mapkitView.showsScale = true
        
        let sourceCoordinate = locationManager.location?.coordinate
        let destCoordinate = CLLocationCoordinate2DMake(37.337206, -122.041001)
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate!)
        let destPlacemark = MKPlacemark(coordinate: destCoordinate)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destItem = MKMapItem(placemark: destPlacemark)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceItem
        directionRequest.destination = destItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let response = response else{
                if let error = error{
                    print("Something went wrong")
                }
                return
            }
            let route = response.routes[0]
            self.mapkitView.add(route.polyline, level: .aboveRoads)
            
            let rekt = route.polyline.boundingMapRect
            self.mapkitView.setRegion(MKCoordinateRegionForMapRect(rekt), animated: true)
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

