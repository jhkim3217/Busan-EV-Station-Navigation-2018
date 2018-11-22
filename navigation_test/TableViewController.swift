//
//  TableViewController.swift
//  navigation_test
//
//  Created by test on 2018. 11. 18..
//  Copyright © 2018년 ksh. All rights reserved.
//

import UIKit
import MapKit
import AddressBook

class TableViewController: UITableViewController {
    @IBOutlet weak var detaillbl: UILabel!
    @IBOutlet weak var maintitle: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var holiday: UILabel!
    var maintitleString = ""
    var detailtitleString = ""
    var typeString = ""
    var companyString = ""
    var startTimeString = ""
    var endTimeString = ""
    var holidayString = ""
    var phoneNumString = ""
    var latString = ""
    var longString = ""
    var dLat: Double?
    var dLong: Double?

    override func viewDidLoad() {
        super.viewDidLoad()
        print(maintitleString)
        maintitle.text = maintitleString
        detaillbl.text = detailtitleString
        type.text = typeString
        company.text = companyString
        startTime.text = startTimeString
        endTime.text = endTimeString
        holiday.text = holidayString
        phone.text = phoneNumString
        //detaillbl.text = detailtitleString
        dLat = Double(latString)
        dLong = Double(longString)
        print(dLat)
        print(dLong)
        
    }

    @IBAction func navi(_ sender: Any) {
        let latitude:CLLocationDegrees = dLat!
        let longitude:CLLocationDegrees = dLong!
        
        let addressDictionary = [String(kABPersonAddressStreetKey) : detailtitleString]
        
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: addressDictionary)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\(maintitleString) \(detailtitleString)"
        mapItem.openInMaps(launchOptions: launchOptions)
        
    }
    
//    let addressDictionary = [String(kABPersonAddressStreetKey) : subtitle]
//    let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
//    let mapItem = MKMapItem(placemark: placemark)
//
//    mapItem.name = "\(title!) \(subtitle!)"
//
//    let location = view.annotation as! BusanData
//    let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
//    location.mapItem().openInMaps(launchOptions: launchOptions)
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 8
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "RE", for: indexPath) as! TableViewCell
//
//        cell.maintitle.text = "왜안댐"
//
//
//        return cell
//    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
