//
//  MapController.swift
//  myMood
//
//  Created by Martin Tsang on 2017-09-11.
//  Copyright © 2017 Hirad. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation
import UIKit

protocol MapControllerDelegate {
    func updateEventWithLocation(location: CLLocation)
}

class MapController:UIView, CLLocationManagerDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    let manager = CLLocationManager()
    
    let delegate:MapControllerDelegate?
    
    //Setup pin onto map and zoom
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01,0.01)
        
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        self.mapView.setRegion(region,animated:true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude:  location.coordinate.longitude)
        mapView.addAnnotation(annotation)
        updateEventWithLocation(location)
    }
    
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        //Create tap Gesture onto self
        let tap = UITapGestureRecognizer(target: self, action: #selector(createMap))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
        mapView.isHidden = true
    }
    
    //Make map appear and update map
    func createMap(sender: UIGestureRecognizer) {
        mapView.isHidden = false

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    //SEND LOCATION TO EVENT
}
