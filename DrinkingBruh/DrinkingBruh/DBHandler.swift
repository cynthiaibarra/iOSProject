//
//  DBHandler.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 4/6/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import UIKit

class DBHandler {
    
    private static let eventDBRef:FIRDatabaseReference = FIRDatabase.database().reference().child("events")
    private static let usersDBRef:FIRDatabaseReference = FIRDatabase.database().reference().child("users")
    private static let invitees:String = "invitees"
    private static let attendees:String = "attendees"
    private static let invites:String = "invites"
    private static let eventsAttending:String = "eventsAttending"
    private static let events:String = "events"
    
    // Parameters: [String] The current user's email
    // Returns: [String] Values that contain the user's friend's emails
    static func getUserEventIDs(userEmail: String, completion: @escaping (String) -> ()) {
        let email = userEmail.firebaseSanitize()
        usersDBRef.child(email).child(events).observe(.childAdded, with: { (snapshot) in
            if snapshot.exists() {
                completion(snapshot.value as! String)
            } else {
                completion("")
            }
        })
    }
    
    // Parameters: [String] The current user's email
    // Returns: [String] Values corresponding to the event IDs the user has been invited to
    static func getUserEventInviteIDs(userEmail: String, completion: @escaping (String) -> ()) {
        let email = userEmail.firebaseSanitize()
        usersDBRef.child(email).child(invites).observe(.childAdded, with: { (snapshot) in
            if snapshot.exists() {
                completion(snapshot.value as! String)
            } else {
                completion("")
            }
        })
    }
    
    // Parameters: [String] The current user's email
    // Returns: [String] The event IDs of events that the user has accepted to attend
    static func getUserEventAttendingIDs(userEmail: String, completion: @escaping (String) -> ()) {
        let email = userEmail.firebaseSanitize()
        usersDBRef.child(email).child("attending").observe(.childAdded, with: { (snapshot) in
            if snapshot.exists() {
                completion(snapshot.value as! String)
            } else {
                completion("")
            }
        })
    }
    
    // Parameters: [String] Event ID
    // Returns: [Dictionary] Event Information from Database
    static func getEventInfo(eventID: String, completion: @escaping ([String:Any]) -> ()) {
        eventDBRef.child(eventID).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                if let event = snapshot.value as? [String: Any] {
                    completion(event)
                } else {
                    completion([:])
                }
            }
        })
    }
    
    // Parameters: [String] Event ID
    // Returns: [String] Emails of friend's invited to the event
    static func getFriendsInvited(eventID: String, completion: @escaping ([String]) -> ()) {
        eventDBRef.child(eventID).child(invitees).observeSingleEvent(of: .value, with: { (snapshot) in
            var inviteeList:[String] = []
            if snapshot.exists() {
                if let invitees = snapshot.value as? [String:String] {
                    for invitee in invitees.keys {
                        inviteeList.append(invitee)
                    }
                }
            }
            completion(inviteeList)
        })
        
    }
    
    // Parameters: [String] Event ID
    // Returns: [String] Emails of friend's that are attending the event
    static func getFriendsAttending(eventID: String, completion: @escaping ([String]) -> ()) {
        eventDBRef.child(eventID).child(attendees).observeSingleEvent(of: .value, with: { (snapshot) in
            var attendeeList:[String] = []
            if snapshot.exists() {
                if let attendees = snapshot.value as? [String:String] {
                    for attendee in attendees.keys {
                        attendeeList.append(attendee)
                    }
                }
            }
            completion(attendeeList)
        })
    }
    
    // Parameters: [String] Current user's email
    // Returns: [String] Emails of current user's friends
    static func getFriends(userEmail: String, completion: @escaping (String) -> ()) {
        let email = userEmail.firebaseSanitize()
        usersDBRef.child(email).child("friends").observe(.childAdded, with: { (snapshot) in
            if snapshot.exists() {
                completion(snapshot.value as! String)
            } else {
                completion("")
            }
        })
    }
    
    static func getFriendRequests(userEmail: String, completion: @escaping (String) -> ()) {
        let email = userEmail.firebaseSanitize()
        usersDBRef.child(email).child("friendRequests").observe(.childAdded, with: { (snapshot) in
            if snapshot.exists() {
                completion(snapshot.value as! String)
            } else {
                completion("")
            }
        })
    }
    
    static func friendRequestRemovedObserver(userEmail: String, completion: @escaping (String) -> ()) {
        let email = userEmail.firebaseSanitize()
        usersDBRef.child(email).child("friendRequests").observe(.childAdded, with: { (snapshot) in
            if snapshot.exists() {
                completion(snapshot.value as! String)
            } else {
                completion("")
            }
        })
    }
    
    static func getSentFriendRequests(userEmail: String, completion: @escaping (String) -> ()) {
        let email = userEmail.firebaseSanitize()
        usersDBRef.child(email).child("sentFriendRequests").observe(.childAdded, with: { (snapshot) in
            if snapshot.exists() {
                completion(snapshot.value as! String)
            } else {
                completion("")
            }
        })
    }
    
    static func getUserInfo(userEmail: String, completion: @escaping ([String:Any]) -> ()) {
        let email:String = userEmail.firebaseSanitize()
        let userDB:FIRDatabaseReference = usersDBRef.child(email)
        
        userDB.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                if let user = snapshot.value as? [String: Any] {
                    completion(user)
                } else {
                    completion([:])
                }
            }
        })
    }
    
    static func inviteFriend(eventID: String, friendEmail: String) {
        let email:String = friendEmail.firebaseSanitize()
        eventDBRef.child(eventID).child(invitees).child(email).setValue(email)
        usersDBRef.child(email).child(invites).child(eventID).setValue(eventID)
    }
    
    static func removeOffInviteeList(eventID: String, userEmail: String) {
        let email:String = userEmail.firebaseSanitize()
        eventDBRef.child(eventID).child(invitees).child(email).removeValue { (error, ref) in
            if let error = error {
                print("DBHandler.removeOffInviteeList error1: \(error.localizedDescription)")
            }
        }
        usersDBRef.child(email).child(invites).child(eventID).removeValue { (error, ref) in
            if let error = error {
                print("DBHandler.removeOffInviteeList error2: \(error.localizedDescription)")
            }
        }
    }
    
    static func addToAttendeesList(eventID: String, userEmail: String) {
        let email:String = userEmail.firebaseSanitize()
        eventDBRef.child(eventID).child(attendees).child(email).setValue(email)
        usersDBRef.child(email).child(eventsAttending).child(eventID).setValue(eventID)
    }
    
    static func acceptEventRequest(eventID:String, userEmail:String) {
        addToAttendeesList(eventID: eventID, userEmail: userEmail)
        removeOffInviteeList(eventID: eventID, userEmail: userEmail)
    }
    
    static func getImage(imageID:String, completion: @escaping (UIImage) -> ()){
        let imageRef = FIRStorage.storage().reference(withPath: imageID)
        imageRef.data(withMaxSize: 3 * 1024 * 1024) { data, error in
            if let error = error {
                print("DBHander.getImage error: \(error)")
            } else {
                 completion(UIImage(data: data!)!)
            }
        }
    }
    
    static func getAllUsers(completion: @escaping ([String:Any]) -> ()) {
        usersDBRef.queryOrdered(byChild: "fullName").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                if let userDictionary = snapshot.value as? [String:Any] {
                    completion(userDictionary)
                }
            }
        })
    }
    
    static func deleteFriendRequest(userEmail: String, friendEmail:String) {
        // Delete email from friend requests list of current user
        let email = userEmail.firebaseSanitize()
        let fEmail = friendEmail.firebaseSanitize()
        usersDBRef.child(email).child("friendRequests").child(fEmail).removeValue { (error, ref) in
            if let error = error {
                print("error \(error.localizedDescription)")
            }
        }

        
        // Delete the current user's email from the other user's sent friend requests list
        usersDBRef.child(fEmail).child("sentFriendRequests").child(email).removeValue { (error, ref) in
            if let error = error {
                print("error \(error.localizedDescription)")
            }
        }
    }
    
    static func acceptFriendRequest(userEmail:String, friendEmail:String) {
        let email = userEmail.firebaseSanitize()
        let fEmail = friendEmail.firebaseSanitize()
        usersDBRef.child(fEmail).child("friends").child(email).setValue(email)
        usersDBRef.child(email).child("friends").child(fEmail).setValue(fEmail)
        deleteFriendRequest(userEmail: email, friendEmail: fEmail)
    }
    
    static func sendFriendRequest(userEmail:String, friendEmail:String) {
        let email = userEmail.firebaseSanitize()
        let fEmail = friendEmail.firebaseSanitize()
        usersDBRef.child(fEmail).child("friendRequests").child(email).setValue(fEmail)
        usersDBRef.child(email).child("sentFriendRequests").child(fEmail).setValue(email)
    }
    
}
