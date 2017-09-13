//
//  FirebaseDB.swift
//  myMood
//
//  Created by Martin Tsang on 2017-09-05.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import MapKit

final class FirebaseDBController {
    var ref:DatabaseReference!
    var storage:StorageReference!
    
    //Shared instance
    static let shared = FirebaseDBController()
    
    init() {
        ref = Database.database().reference()
        storage = Storage.storage().reference()
        
        //Sample code + Firebase Setup
        ref.child("Users").child("User_id").updateChildValues(["Name":"Sample",
                                                              "Email":"Sample",
                                                              "Password":"Sample",
            ])
        
        ref.child("Entries").child("Entry_id").updateChildValues(["UserID":"Sample",
                                                                 "Date":"Sample",
                                                                 "Description":"Sample",
                                                                 "PhotoURL":"Sample",
                                                                 "Location":"Sample",
                                                                 "Mood":"Sample"])
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
        let query = ref.child("Entries").queryEqual(toValue: userID, childKey: "userID").queryOrdered(byChild: "Date")
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshotDict = snapshot.value as? NSDictionary, snapshot.hasChildren(){
                completion(snapshotDict)
            } else {
                let error:NSDictionary = ["Error":"Problem Finding User's data"]
                completion(error)
            }
        })
    }
    
    //GET specific entry
    func getEntry(eID:String, completion: @escaping (NSDictionary) -> Void) {
        ref.child("Entries").child(eID).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(eID) {
                completion(snapshot.value as! NSDictionary)
            } else {
                let error:NSDictionary = ["Error":"Problem Finding User's data"]
                completion(error)
            }
            
        })
    }
    
    
    //Insert into Entry
    func insertEntry(entry:Entry) {
        let userId = Auth.auth().currentUser?.uid
        
        //Date
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd.MM.yyyy.hh.mm.ss"
        let date:String = dateFormat.string(from: entry.date)
        
        //Auto generate entry id
        let newRef = ref.child("Entries").childByAutoId()
        newRef.setValue(["UserID":userId!,
                         "Date":date,
                         "Mood":entry.mood])
        
        //Set entryID on entry Object
        let entryID = newRef.key
        entry.ID = entryID
        
    }
    
    //Update the given Properties
    func updateEntry(entry:Entry) {
        var properties = Dictionary<String,Any>()
        
        //Change location to string
        if let loc = entry.location {
            properties["Location"] = "\(loc.coordinate.latitude),\(loc.coordinate.longitude)"
        }
        
        //Mood
        properties["Mood"] = entry.mood
        
        //Description
        if let descr = entry.entryDescription {
            properties["Description"] = descr
        } else {
            properties["Description"] = "Start your journey now! Go Do Something"
        }
        ref.child("Entries").child(entry.ID!).updateChildValues(properties)
    }
    
    //Insert & Update Photo into Storage
    //Takes in entry containing photo
    func insertPhoto(entry:Entry) {
        let userId = Auth.auth().currentUser?.uid
        
        //Check if a photo exist in this entry
        let photoImg:UIImage
        if let img = entry.photo {
            photoImg = img.photoObject
        } else {
            return
        }
        
        //Setup image
        let data = UIImageJPEGRepresentation(photoImg, 0.8)! as NSData
    
        //Set upload path
        //File path: User/userID/entryID
        let filePath = "Users/\(userId!)/\(entry.ID!)"
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
    
        self.storage.child(filePath).putData(data as Data, metadata: metaData){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                //store downloadURL into entry object
                let downloadLink:String = metaData!.downloadURL()!.absoluteString
                entry.photo!.photoURL = metaData!.downloadURL()!.absoluteString
                self.ref.child("Entries").child(entry.ID!).updateChildValues(["PhotoURL":downloadLink])
            }
        }
    }

    //Delete specific photo
    func deletePhoto(entry:Entry){
        let userId = Auth.auth().currentUser?.uid
        let imageRef = storage.child("Users").child(userId!).child(entry.ID!)
        imageRef.delete { (error) in
            if let err = error {
                print("Error: \(err.localizedDescription)")
            } else {
                print("Success deleting image")
            }
        }
    }
    
}
