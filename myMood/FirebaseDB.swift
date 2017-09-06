//
//  FirebaseDB.swift
//  myMood
//
//  Created by Martin Tsang on 2017-09-05.
//  Copyright © 2017 Hirad. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import MapKit

final class FirebaseDBController {
    var ref:DatabaseReference!
    
    //Shared instance
    static let shared = FirebaseDBController()
    
    init() {
        ref = Database.database().reference()
        
        //Sample code + Firebase Setup
        ref.child("Users").child("User_1").updateChildValues(["Name":"Sample",
                                                              "Email":"Sample",
                                                              "Password":"Sample",
                                                              "ListofEntries":"Sample"
            ])
        
        ref.child("Entries").child("Entry_1").updateChildValues(["Date":"Sample",
                                                                 "Description":"Sample",
                                                                 "PhotoURL":"Sample",
                                                                 "Location":"Sample",
                                                                 "Mood":"Sample"])
        
        
        //ref.child("Photos").child("Photo_1").updateChildValues(["url":"Sample"])
    }
    
    //TODO
    //GET all data for the user
    func getAllEntries() -> NSDictionary {
        let userID = Auth.auth().currentUser?.uid
        var dict:NSDictionary?
        ref.child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapShot) in
            //Get user value
            dict =  (snapShot.value as! NSDictionary)
        }) { (error) in
            print(error.localizedDescription)
        }
        return dict!
    }
    
    //TODO 
    //Insert Entry
    func insertEntry(date:Date, description:String, photo:Photo, mood:Int, location:CLLocation) {
        let userId = Auth.auth().currentUser?.uid
        
        //Date
        let dateFormatter = DateFormatter()
        let date:String = dateFormatter.string(from: date)
        
        //TODO  Get Photo URL
        //Add current Photos
        
        //Change location to string
        let location:String = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        
        //Auto generate entry id
        let newRef = ref.child("Entries").childByAutoId()
        
        newRef.setValue(["Date":date,
                         "Description":description,
                         "PhotoURL":"Sample URL",
                         "Location":location,
                         "Mood":mood])
        
        let entryID = newRef.key
        
        //insert entry to list of entry in user
        ref.child("Users").child(userId!).child("ListofEntries").updateChildValues([entryID:true])
        
    }
    
    //TOOD
    //Update specific properties in entry
    func updateEventProperty() {
        return
    }
    
    //TODO
    //Delete Specific Entry
    func deleteEvent() {
        
    }
    
    //TODO
    //Insert Photo
    func insertPhoto() {
        
    }
    
    //TODO
    //Delete specific photo
    func deletePhoto(){
        
    }
    
}
