//
//  FirebaseDB.swift
//  myMood
//
//  Created by Martin Tsang on 2017-09-05.
//  Copyright © 2017 Hirad. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class FirebaseDBController {
    var ref:DatabaseReference!
    
    //Shared instance
    static let shared = FirebaseDB()
    
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
                                                                 "ListofPhotos":"Sample",
                                                                 "Location":"Sample",
                                                                 "Mood":"Sample"])
        
        
        ref.child("Photos").child("Photo_1").updateChildValues(["url":"Sample"])
    }
    
    //TODO 
    //Insert Entry
    func insertEntry() -> Bool {
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
