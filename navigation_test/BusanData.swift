//
//  BusanData.swift
//  navigation_test
//
//  Created by test on 2018. 11. 6..
//  Copyright © 2018년 ksh. All rights reserved.
//

import Foundation
import MapKit
import AddressBook

class BusanData: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    let type: String?
    let company: String?
    let startTime: String?
    let endTime: String?
    let holiday: String?
    let phoneNum: String?
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D, type: String, company: String, startTime: String, endTime:String, holiday: String, phoneNum: String) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.type = type
        self.company = company
        self.startTime = startTime
        self.endTime = endTime
        self.holiday = holiday
        self.phoneNum = phoneNum
        
        super.init()
    }
    
    func mapItem() -> MKMapItem
    {
        let addressDictionary = [String(kABPersonAddressStreetKey) : subtitle]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        let mapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = "\(title) \(subtitle)"
        
        return mapItem
    }
}
