//
//  EntryPopupViewController.swift
//  myMood
//
//  Created by Martin Tsang on 2017-09-20.
//  Copyright © 2017 Hirad. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class EntryPopupViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var myScrollView: UIScrollView!
    var entry:Entry? = nil
    var content:UIView = UIView()
    
    var listOfitems:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myScrollView.backgroundColor = UIColor.white
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
    
        showAnimate()
        
        let tappedOutside = UITapGestureRecognizer(target: self, action: #selector(removeAnimate))
        self.view.addGestureRecognizer(tappedOutside)
        
        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        setupFrames()
        var multiplier:CGFloat = 1
        if listOfitems.count > 0 {
            multiplier = CGFloat(listOfitems.count+1)
        }
        content.frame = CGRect(x:0, y:0, width:myScrollView.frame.width * multiplier, height:myScrollView.frame.height)
        
        
        myScrollView.contentMode = UIViewContentMode.scaleAspectFit
        myScrollView.isPagingEnabled = true
        myScrollView.contentSize = content.frame.size
        myScrollView.addSubview(content)
        myScrollView.delegate = self

    }
 
    
    func setupFrames() {
        
        let textEntry = UITextView()
        textEntry.frame = myScrollView.frame
        
        textEntry.center = CGPoint(x:myScrollView.frame.width*0.5,
                                   y: myScrollView.frame.height/2)
        content.addSubview(textEntry)
        textEntry.text = "Unfortunately there's no information here"
        
        if entry?.entryDescription != nil {
            textEntry.text = entry!.entryDescription
        }
        
        if entry?.location != nil {
            listOfitems.append("Location")
            createMap(location: (entry?.location)!)
            
        }
        
        if entry?.photo != nil {
            //Get the photo and update the image and put it into the frame
            setPhoto(image: (entry!.photo?.photoObject)!)
            
        }else if entry?.photoURL != nil {
            listOfitems.append("Photo")
            let url = URL(string: (entry?.photoURL)!)
            loadPhoto(website: url!)
        }
        
        

        
    }
    
    func createMap(location:CLLocation){
        let myMap = MKMapView(frame:myScrollView.frame)
        
        myMap.center = CGPoint(x:myScrollView.frame.width*(CGFloat(listOfitems.count)+0.5),
                                    y: myScrollView.frame.height/2)
        content.addSubview(myMap)
        
        //Zoom value
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01,0.01)
        //Set map settings
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        myMap.setRegion(region,animated:true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                       longitude:  location.coordinate.longitude)
        myMap.addAnnotation(annotation)
        myMap.isUserInteractionEnabled  = false
        myMap.isZoomEnabled = false
        myMap.isScrollEnabled = false
        
    }
    
    func loadPhoto(website: URL) {
        let session = URLSession(configuration: .default)

        let downloadPicTask = session.dataTask(with: website) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        let downloadedImage = UIImage(data: imageData)
                        self.entry?.photo = Photo(photo: downloadedImage!)
                        self.setPhoto(image:downloadedImage!)
                        
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        
        downloadPicTask.resume()
        
    }
    
    func setPhoto(image: UIImage) {
        DispatchQueue.main.async {
            //Get the photo and update the image and put it into the frame
            let photoFrame = UIImageView(frame: self.myScrollView.frame)
            photoFrame.image = image
            photoFrame.center = CGPoint(x:self.myScrollView.frame.width*(CGFloat(self.listOfitems.count)+0.5),
                                        y: self.myScrollView.frame.height/2)
            self.content.addSubview(photoFrame)
        }
    }
    
    
    
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    @objc func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion: {(finished: Bool) in
            if (finished) {
                self.view.removeFromSuperview()
            } })
    }
    
}
