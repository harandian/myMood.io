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
    private var allEntries:[Entry] = []
    
    private init() {
        ref = Database.database().reference()
        storage = Storage.storage().reference()
        
        //Sample code + Firebase Setup
        ref.child("Users").child("User_id").updateChildValues(["Name":"Sample",
                                                              "Email":"Sample",
            ])
        
        ref.child("Entries").child("Entry_id").updateChildValues(["UserID":"Sample",
                                                                 "Date":"Sample",
                                                                 "Description":"Sample",
                                                                 "PhotoURL":"Sample",
                                                                 "Location":"Sample",
                                                                 "Mood":"Sample"])
        
        ref.child("Entries").child("Entry_id").child("Location").updateChildValues(["Longitude":"Sample",
                                                                                    "Latitude":"Sample"])
        
        loadAllEntries()
    }
    
    
    /*
 
     Sample code to get all entries
     
     get_allEntries()
     
    */
    //Call this to get all the entries
    func get_allEntries() ->[Entry] {
        self.allEntries = self.allEntries.sorted(by: { (e1, e2) -> Bool in
            if e1.date > e2.date {
                return true
            } else {
                return false
            }
        })
        return self.allEntries
    }
    
    //GET all data for the user UNORDERED
    private func getAllEntries(completion: @escaping (NSDictionary) -> Void) {
        //Save shared variables
        let userID = Auth.auth().currentUser?.uid
        let query = ref.child("Entries").queryOrdered(byChild: "UserID").queryEqual(toValue: userID)
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
    private func getEntry(eID:String, completion: @escaping (NSDictionary) -> Void) {
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
        var properties = Dictionary<String,Any>()
        properties["UserID"] = userId
        properties["Date"] = entry.date
        properties["Mood"] = entry.mood
        
        
        //Auto generate entry id
        let newRef = ref.child("Entries").childByAutoId()
        
        
        //Text
        if entry.entryDescription != nil {
            properties["Description"] = entry.entryDescription
        }
        
        //Enter base properties first
        newRef.setValue(properties)
        
        //Set entryID on entry Object
        let entryID = newRef.key
        entry.ID = entryID
        
        //Image
        if entry.photo != nil {
            insertPhoto(entry: entry)
        }else {
            allEntries.insert(entry, at: 0)
        }
        
        //Change location to string
        if let loc = entry.location {
            ref.child("Entries").child(entry.ID!).child("Location").updateChildValues(["Latitude":loc.coordinate.latitude,
                                                                                       "Longitude":loc.coordinate.longitude])
        }
    }
    
    //Update the given Properties
    func updateEntry(entry:Entry) {
        var properties = Dictionary<String,Any>()
        
        //Mood
        properties["Mood"] = entry.mood
        
        //Description
        if let descr = entry.entryDescription {
            properties["Description"] = descr
        } else {
            properties["Description"] = "Start your journey now! Go Do Something"
        }
        
        ref.child("Entries").child(entry.ID!).updateChildValues(properties)
        
        
        //Change location to string
        if let loc = entry.location {
            ref.child("Entries").child(entry.ID!).child("Location").updateChildValues(["Latitude":loc.coordinate.latitude,
                                                                                       "Longitude":loc.coordinate.longitude])
        }
    }
    
    //Insert & Update Photo into Storage
    //Takes in entry containing photo
    private func insertPhoto(entry:Entry) {
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
                
                self.allEntries.insert(entry, at: 0)
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
    
    
    
    func loadAllEntries(){
        if self.allEntries.count > 0 {return}
        var temp:[Entry] = []
        self.getAllEntries { (result) in
            for entry in result {
                guard let dict:NSDictionary  = entry.value as? NSDictionary else {
                    return
                }
                
                //Date, mood and ID are a must
                //Convert UNIX time to date property
                let newDate = dict["Date"] as! Double
    
                //Create new Entry
                let e:Entry = Entry(date: newDate,
                              id: entry.key as! String,
                              mood: dict["Mood"] as! Int)
                
                //Check Description
                if dict["Description"] != nil {
                    e.entryDescription = dict["Description"] as? String
                }
                
                //Check if Photo is made
                if dict["PhotoURL"] != nil {
                    e.photoURL = dict["PhotoURL"] as? String
                }
                
                if dict["Location"] != nil {
                    let loc:NSDictionary = dict["Location"] as! NSDictionary
                    let location:CLLocation = CLLocation(latitude: loc["Latitude"] as! Double,
                                                         longitude: loc["Longitude"] as! Double)
                    e.location = location
                }
                
                temp.append(e)
                
            }
            
            self.allEntries = temp.sorted(by: { (e1, e2) -> Bool in
                if e1.date > e2.date {
                    return true
                } else {
                    return false
                }
            })
        }
    }
}
