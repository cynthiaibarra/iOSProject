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
    private static let locationDBRef:FIRDatabaseReference = FIRDatabase.database().reference().child("locations")
    private static let invitees:String = "invitees"
    private static let attendees:String = "attendees"
    private static let invites:String = "invites"
    private static let eventsAttending:String = "eventsAttending"
    private static let events:String = "events"
    
    // Parameters: [String] The current user's email
    // Returns: [String] Values that contain the user's friend's emails
    static func getUserEventIDs(userEmail: String, completion: @escaping ([String:String]) -> ()) {
        let email = userEmail.firebaseSanitize()
        
        usersDBRef.child(email).child(events).observe(.childAdded, with: { (snapshot) in
            if snapshot.exists() {
                let eventID:String = snapshot.key
                let status:String = snapshot.value as! String
                completion(["id":eventID, "status":status])
            } else {
                completion([:])
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
    // Returns: [String:String] Email and status of friend invited to the event
    static func getFriendsInvited(eventID: String, completion: @escaping ([String:String]) -> ()) {
        eventDBRef.child(eventID).child(invitees).observe(.childAdded, with: { (snapshot) in
            if snapshot.exists() {
                let email:String = snapshot.key 
                let status:String = snapshot.value as! String
                completion(["email":email, "status":status])

            }else {
                completion([:])
            }
            
        })
        
    }
    
    // Parameters: [String] Event ID
    // Returns: [String:String] Email and status of friends invited to the event
    static func friendsInvited(eventID: String, completion: @escaping ([String:String]) -> ()) {
        eventDBRef.child(eventID).child(invitees).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                if let invited = snapshot.value as? [String: String] {
                    completion(invited)
                } else {
                    completion([:])
                }
                
            }
        })
        
    }

    // Parameters: [String] Event ID
    // Returns: [String:String] Email and role of friend attending event
    static func getInviteeRoles(eventID: String, completion: @escaping ([String:String]) -> ()) {
        eventDBRef.child(eventID).child("roles").observe(.childAdded, with: { (snapshot) in
            if snapshot.exists() {
                let email:String = snapshot.key
                let role:String = snapshot.value as! String
                completion(["email":email, "role":role])
                
            }else {
                completion([:])
            }
            
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
    
    // Parameters: [String] Event ID
    // Returns: String Email of host
    static func getHost(eventID: String, completion: @escaping (String) -> ()) {
        eventDBRef.child(eventID).child(invitees).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                if let invitees = snapshot.value as? [String:String] {
                    for invitee in invitees {
                        if invitee.value == "hosting" {
                            completion(invitee.key)
                            break
                        }
                    }
                }
            }else {
                completion("")
            }
        })
    }
    
    //    DBHandler.getHost(eventID: "2C659A10-E938-47E3-9A49-7A4ED253C7E3"){ (hostEmail) -> () in
    //      print(hostEmail)
    //    }
    
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
                print(snapshot)
                if let user = snapshot.value as? [String: Any] {
                    completion(user)
                } else {
                    completion([:])
                }
            }
        })
    }
    
    static func setHost(eventID: String) {
        let email = FIRAuth.auth()?.currentUser?.email?.firebaseSanitize()
        eventDBRef.child(eventID).child(invitees).child(email!).setValue("hosting")
        usersDBRef.child(email!).child(events).child(eventID).setValue("hosting")
    }
    
    
    static func inviteFriend(eventID: String, friendEmail: String) {
        let email:String = friendEmail.firebaseSanitize()
        eventDBRef.child(eventID).child(invitees).child(email).setValue("pending")
        usersDBRef.child(email).child(events).child(eventID).setValue("pending")
    }
    
    static func acceptInvite(eventID: String) {
        let email = FIRAuth.auth()?.currentUser?.email?.firebaseSanitize()
        eventDBRef.child(eventID).child(invitees).child(email!).setValue("attending")
        usersDBRef.child(email!).child(events).child(eventID).setValue("attending")
        
        //NotificationManager.eventNotification(date: startDate, eventTitle: eventTitle, eventID: eventID)
    }
    
    static func removeOffInviteeList(eventID: String, userEmail: String) {
        let email:String = userEmail.firebaseSanitize()
        eventDBRef.child(eventID).child(invitees).child(email).removeValue { (error, ref) in
            if let error = error {
                print("DBHandler.removeOffInviteeList error1: \(error.localizedDescription)")
            }
        }
        usersDBRef.child(email).child(events).child(eventID).removeValue { (error, ref) in
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
    
    static func getUserEvents(completion: @escaping ([String:String]) -> ()) {
        usersDBRef.child(getUserEmail()).child("events").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                print(snapshot.value ?? "error")
                if let userEvents = snapshot.value as? [String:String] {
                    completion(userEvents)
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
        usersDBRef.child(fEmail).child("friendRequests").child(email).setValue(email)
        usersDBRef.child(email).child("sentFriendRequests").child(fEmail).setValue(fEmail)
    }
    
    static func addDrink(eventID:String, drinks:[String:Any]) {
        let email = FIRAuth.auth()?.currentUser?.email?.firebaseSanitize()
        eventDBRef.child(eventID).child("drinkLog").child(email!).setValue(["beer":drinks["beer"], "vodka":drinks["vodka"], "gin":drinks["gin"], "whiskey":drinks["whiskey"], "tequila":drinks["tequila"], "wine":drinks["wine"], "elapsedTime":drinks["elapsedTime"]])
    }
    
    static func getDrinks(eventID:String, completion: @escaping ([String:Any]?) -> ()) {
        let email = FIRAuth.auth()?.currentUser?.email?.firebaseSanitize()
        print(email!)
        eventDBRef.child(eventID).child("drinkLog").child(email!).observeSingleEvent(of: .value,  with: { (snapshot) in
            if snapshot.exists() {
                completion(snapshot.value as? [String:Any])
            } else {
                completion(nil)
            }
        })
    }
    
    static func addLocation(latitude: Double, longitude: Double) {
        let email = FIRAuth.auth()?.currentUser?.email?.firebaseSanitize()
        locationDBRef.child(email!).setValue(["latitude":latitude, "longitude":longitude])
    }
    
    static func getAllUsersLocations(completion: @escaping ([String:[String:Double]]?) -> ()) {
        locationDBRef.observeSingleEvent(of: .value,  with: { (snapshot) in
            if snapshot.exists() {
                completion(snapshot.value as? [String:[String:Double]])
            } else {
                completion(nil)
            }
        })
    }
    
    static func emailIsUsers(entry:String) -> Bool {
        let email = FIRAuth.auth()?.currentUser?.email?.firebaseSanitize()
        return email == entry.firebaseSanitize()
    }
    
    static func getUserEmail() -> String {
        return (FIRAuth.auth()?.currentUser?.email?.firebaseSanitize())!
    }
    
    static func createEvent(eventID:String, title:String, start:String, end:String, location:String, address:String, imageID:String, longitude: Double, latitude: Double) {
        usersDBRef.child(getUserEmail()).child("events").child(eventID).setValue("hosting")
        eventDBRef.child(eventID).setValue(["id":eventID, "title" : title, "start" : start, "end" : end, "location" : location, "address" : address, "image" : imageID, "longitude" : longitude, "latitude" : latitude])
    }
    
    static func editEvent(eventID:String, title:String, start:String, end:String, location:String, address:String, imageID:String, longitude: Double, latitude: Double, invitees:[String:String]) {
        usersDBRef.child(getUserEmail()).child("events").child(eventID).setValue("hosting")
        eventDBRef.child(eventID).setValue(["id":eventID, "title" : title, "start" : start, "end" : end, "location" : location, "address" : address, "image" : imageID, "longitude" : longitude, "latitude" : latitude, "invitees":invitees])
    }
    
    static func addRole(role:String, eventID: String) {
        eventDBRef.child(eventID).child("roles").child(getUserEmail()).setValue(role)
    }
    
    static func addEventToTimeline(eventID:String) {
        usersDBRef.child(getUserEmail()).child("timelines").child(eventID).setValue(eventID)
    }
    
    static func getTimelineEvents(completion: @escaping ([String:String]) -> ()) {
        usersDBRef.child(getUserEmail()).child("timelines").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                print(snapshot.value ?? "error")
                if let userEvents = snapshot.value as? [String:String] {
                    completion(userEvents)
                }
            }
        })
    }
}
