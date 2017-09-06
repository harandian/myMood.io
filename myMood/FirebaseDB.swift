//
//  FirebaseDB.swift
//  myMood
//
//  Created by Martin Tsang on 2017-09-05.
//  Copyright © 2017 Hirad. All rights reserved.
//

import Foundation
import Firebase
import MapKit

final class FirebaseDBController {
    var ref:DatabaseReference!
    
    //Shared instance
    static let shared = FirebaseDBController()
    
    init() {
        ref = Database.database().reference()
        
        //Sample code + Firebase Setup
        ref.child("Users").child("User_id").updateChildValues(["Name":"Sample",
                                                              "Email":"Sample",
                                                              "Password":"Sample",
                                                              "Entries":""
            ])
        //Each Entry Id needs some sort of detail e.g. title, date, some sort of string
        ref.child("Users").child("User_id").child("Entries").updateChildValues(["Entry_id":"Mood"])
        
        ref.child("Entries").child("Entry_id").updateChildValues(["Date":"Sample",
                                                                 "Description":"Sample",
                                                                 "PhotoURL":"Sample",
                                                                 "Location":"Sample",
                                                                 "Mood":"Sample"])
        
        
        //ref.child("Photos").child("Photo_1").updateChildValues(["url":"Sample"])
    }
    
    
    /*
 
     Sample code to call each function:
     
     FirebaseDBController.shared.getAllEntries() { result in
        print(result) // result is the NSDictionary object
     }
     
     FirebaseDBController.shared.getEntry(eID: "-KtO4g_VtnCaTZYTKD7Y") { result in
        print(result)
     }
 
    */
    
    //GET all data for the user
    func getAllEntries(completion: @escaping (NSDictionary) -> Void) {
        //Save shared variables
        let userID = Auth.auth().currentUser?.uid
        //var dict:Dictionary<String,Any>?
        ref.child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            completion(snapshot.value as! NSDictionary)
        })
    }
    
    //GET specific entry
    func getEntry(eID:String, completion: @escaping (NSDictionary) -> Void) {
        ref.child("Entries").child(eID).observeSingleEvent(of: .value) { (snapshot) in
            completion(snapshot.value as! NSDictionary)
        }
    }
    
    
    //TODO  - Change to receive one entry model object
    //Insert Entry
    func insertEntry(entry:Entry) {
        let userId = Auth.auth().currentUser?.uid
        
        //Date
        let date:String = DateFormatter().string(from: entry.date)
        
        //TODO  Get Photo URL
        //Add current Photos
        
        
        //Change location to string
        var location:String
        if let loc = entry.location {
            location = "\(loc.coordinate.latitude),\(loc.coordinate.longitude)"
        } else {
            location = ""
        }
        
        //Auto generate entry id
        let newRef = ref.child("Entries").childByAutoId()
        
        newRef.setValue(["Date":date,
                         "Description":entry.description,
                         "PhotoURL":entry.photo!.photoURL,
                         "Location":location,
                         "Mood":entry.mood])
        
        //Set entryID on entry Object
        let entryID = newRef.key
        entry.ID = entryID
        
        //insert entry to list of entry in user
        ref.child("Users").child(userId!).child("Entries").updateChildValues([entryID:entry.mood])
        
    }
    
    
    //Update specific properties in entry
    func updateEventProperty(entry:Entry) {
        //TODO - get photo URL
        
        
        //Change location to string
        var location:String
        if let loc = entry.location {
            location = "\(loc.coordinate.latitude),\(loc.coordinate.longitude)"
        } else {
            location = ""
        }
        
        ref.child("Entries").child(entry.ID).updateChildValues(["Description":entry.description,
                                                                      "PhotoURL":entry.photo!.photoURL,
                                                                      "Location":location,
                                                                      "Mood":entry.mood])
    }
    
    
    //TODO
    //Insert Photo into Storage
    func insertPhoto(photo:Photo) {
        
    }
    
    //TODO
    func updatePhoto(entry:Entry){
        
    }
    
    //TODO
    //Delete specific photo
    func deletePhoto(entry:Entry){
        
    }
    
}
