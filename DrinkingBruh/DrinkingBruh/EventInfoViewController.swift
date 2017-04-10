//
//  EventInfoViewController.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 4/7/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit
import MapKit

class EventInfoViewController: UIViewController {

  
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var eventTitle:String?
    var imageID:String?
    var start:String?
    var end:String?
    var location:String?
    var address:String?
    var coordinates:CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DBHandler.getImage(imageID: imageID!) { (image) -> () in
            self.eventImageView.image = image
        }
        eventTitleLabel.text = eventTitle
        startDateLabel.text = start
        endDateLabel.text = end
        locationLabel.text = location
        addressLabel.text = address
        mapView.setCenter(coordinates!, animated: true)
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates!
        pin.title = location
        var arr:[MKPointAnnotation] = []
        arr.append(pin)
        mapView.showAnnotations([pin], animated: true)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
