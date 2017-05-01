//
//  TimelineViewController.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 4/24/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit
import FirebaseStorageUI
import FirebaseStorage


class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var floaty: Floaty!
    @IBOutlet weak var tableView: UITableView!
    
    var eventID:String = ""
    var eventTitle:String = ""
    var posts:[[String:Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.title = eventTitle
        floaty.sticky = true
        floaty.addItem("New Post", icon: UIImage(named: "pencil-box")!, handler: { item in
            self.performSegue(withIdentifier: "segueToNewPost", sender: nil)
        })
        floaty.addItem("Friend Locations", icon: UIImage(named: "map-marker")!, handler: { item in
          let storyboard = UIStoryboard(name: "Location", bundle: nil)
          let controller = storyboard.instantiateViewController(withIdentifier: "FriendLocator") as! LocateFriendsViewController
          controller.currentEventID = self.eventID
          self.navigationController?.pushViewController(controller, animated: true)
        })
        floaty.addItem("Drink Tracker", icon: UIImage(named: "beer")!, handler: { item in
            let storyboard = UIStoryboard(name: "DrinkTracker", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "DrinkTracker") as! DrinkLoggerViewController
            controller.currentEventID = self.eventID
            self.navigationController?.pushViewController(controller, animated: true)
        })
        floaty.addItem("BAC Caculator", icon: UIImage(named: "calculator")!, handler: { item in
            let storyboard = UIStoryboard(name: "DrinkTracker", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "Bac") as! BacViewController
            controller.currentEventID = self.eventID
            self.navigationController?.pushViewController(controller, animated: true)
        })
        floaty.addItem("Leaderboards", icon: UIImage(named: "trophy")!, handler: { item in
            
        })
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 118
        
        DBHandler.getPosts(eventID: eventID) { (post) -> () in
            self.posts.insert(post, at: 0)
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Tableview Delegate & Datasource
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        if posts.count == 0 {
            TableViewHelper.emptyMessage(message: "No posts yet. Be the first to post!", viewController: self, tableView: self.tableView)
        }
        return posts.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let post:[String:Any] = self.posts[indexPath.row]
        let timestamp:Int = (post["timestamp"] as? Int)!
        let seconds:Double = Double(timestamp / 1000)
        let d:Date = Date(timeIntervalSince1970: seconds)
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMM d, yyyy h:mm a"
        dateFormatter.timeZone = TimeZone(abbreviation: "CST")
        let date = dateFormatter.string(from: d)
        

        let email:String = (post["user"] as? String)!
        let content:String = (post["content"] as? String)!
        let postImageID:String? = post["image"] as? String
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! TimelineTableViewCell
        
        cell.timeLabel.text = "\(date)"
        cell.contentLabel.text = content
        
        if postImageID != nil && postImageID != "nil" {
            let reference = FIRStorage.storage().reference().child(postImageID!)
            cell.postImageView.sd_setImage(with: reference)

        }
        
        DBHandler.getUserInfo(userEmail: email) { (user) -> () in
            let imageID:String? = user["image"] as? String
            let name:String? = user["fullName"] as? String
            cell.nameLabel.text = name
            if imageID != nil {
                
                let reference = FIRStorage.storage().reference().child(imageID!)
                let imageView:UIImageView = cell.userImageView
                let placeholderImage = UIImage(named: "genericUser.png")
                imageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
            } else {
                cell.userImageView.image = UIImage(named: "genericUser")
            
            }
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToNewPost" {
            if let newPostVC = segue.destination as? NewPostViewController {
                newPostVC.eventID = self.eventID
            }
        }
    }
}
