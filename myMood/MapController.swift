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
    func removeEventLocation()
}

class MapController:UIView, CLLocationManagerDelegate{

    
    @IBOutlet weak var mapView: MKMapView!
    let manager = CLLocationManager()
    
    var delegate:MapControllerDelegate? = nil
    
    //Location Variable to store the location
    var savedLocation:CLLocation! = nil
    
    //Setup pin onto map and zoom
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01,0.01)
        
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        self.mapView.setRegion(region,animated:true)
        
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude:  location.coordinate.longitude)
        mapView.addAnnotation(annotation)
        savedLocation = location
        self.delegate?.updateEventWithLocation(location: savedLocation)
    }
    
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        //Create tap Gesture onto self
        let tap = UITapGestureRecognizer(target: self, action: #selector(createMap))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
        
        if savedLocation != nil {
            turnOnMap(location: savedLocation)
        } else {
            mapView.isHidden = true
        }
    }
    
    //Make map appear and update map
    func createMap(sender: UIGestureRecognizer) {
        mapView.isHidden = false
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func turnOnMap(location:CLLocation){
        //Turn on map
        mapView.isHidden = false
        
        //Zoom value
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01,0.01)
        //Set map settings
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        self.mapView.setRegion(region,animated:true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                       longitude:  location.coordinate.longitude)
        mapView.addAnnotation(annotation)
    }
    
    @IBAction func cancelLocation(_ sender: Any) {
        mapView.isHidden = true
        mapView.removeAnnotations(mapView.annotations)
        savedLocation = nil
        manager.stopUpdatingLocation()
        self.delegate?.removeEventLocation()
        
    }
}
