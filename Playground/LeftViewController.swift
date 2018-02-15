//
//  LeftViewController.swift
//  Playground
//
//  Created by Jonah U on 8/14/17.
//  Copyright © 2017 Jonah U. All rights reserved.
//

import UIKit
import MapKit

class LeftViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var zoomedInOnLocation = false
    let regionRadius: CLLocationDistance = 1000

    override func viewDidLoad() {
        mapView.delegate = self
        requestLocationAccess()
    }
    
    func requestLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
        case .denied, .restricted:
            print("Location Access Denied")
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func centerMapOnLocation(location: CLLocation){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func displayDirections(){
        let sourceLocation = mapView.userLocation.coordinate
        let destinationLocation = CLLocationCoordinate2D(latitude: 40.748441, longitude: -73.985564)
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .walking
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate(completionHandler: {
            (response, error) -> Void in
            
            guard let response = response else{
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            
            let route = response.routes[0]
            self.mapView.add(route.polyline)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        })
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.cyan
        renderer.lineWidth = 6.0
        
        return renderer
    }

    @IBAction func viewWasTapped(_ sender: UITapGestureRecognizer) {
        if zoomedInOnLocation{
            displayDirections()
            zoomedInOnLocation = false
        }else{
            for overlay in mapView.overlays{
                mapView.remove(overlay)
            }
            centerMapOnLocation(location: mapView.userLocation.location!)
            zoomedInOnLocation = true
        }
    }
}
