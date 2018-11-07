//
//  ViewController.swift
//  navigation_test
//
//  Created by test on 2018. 11. 6..
//  Copyright © 2018년 ksh. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController, XMLParserDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var annotation: BusanData?
    var annotations: Array = [BusanData]()
    
    var item: [String:String] = [:]
    var items: [[String:String]] = []
    var currentElement = ""
    
    var address: String?
    var lat: String?
    var long: String?
    var name: String?
    var loc: String?
    var dLat: Double?
    var dLong: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "부산 전기차 충전소"
        
        if let path = Bundle.main.url(forResource: "EV", withExtension: "xml"){
            if let myParser = XMLParser(contentsOf: path) {
                myParser.delegate = self
                if myParser.parse() {
                    print("파싱 성공")
                    for item in items {
                        print("item \(item["소재지지번주소"]!)")
                    }
                } else {
                    print("파싱 실패")
                }
            } else {
                print("파싱 오류1")
            }
        } else {
            print("XML 파일 없음")
        }
        
        let initialLocation = CLLocation(latitude: 35.1795543, longitude: 129.075641)
        zoomMapOn(location: initialLocation)
        
//        let sampleMangmi = BusanData(title: "망미동 공영주차장", subtitle: "부산광역시 수영구 금련로 43번길 17", coordinate: CLLocationCoordinate2D(latitude: 35.1657709, longitude: 129.0703436))
//        mapView.addAnnotation(sampleMangmi)
        
        mapView.delegate = self
        
         //초기맵 설정
        zoomToRegion()
        
        for item in items {
            lat = item["위도"]
            long = item["경도"]
            name = item["충전소명"]
            loc = item["소재지지번주소"]
            dLat = Double(lat!)
            dLong = Double(long!)
            annotation = BusanData(title: name!, subtitle: loc!, coordinate: CLLocationCoordinate2D(latitude: dLat!, longitude: dLong!))
            annotations.append(annotation!)
        }
        //mapView.showAnnotations(annotations, animated: true)
        mapView.addAnnotations(annotations)

        
    } // viewDidLoad()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLcationServiceAuthenticationStatus()
    }
    
    func zoomToRegion() {
        let location = CLLocationCoordinate2D(latitude: 35.180100, longitude: 129.081017)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    private let regionRadius: CLLocationDistance = 1000 // 1km ~ 1.6km(1mile)
    
    func zoomMapOn(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // 현재 위치
    
    var locationManager = CLLocationManager()
    
    func checkLcationServiceAuthenticationStatus()
    {
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
    }
    
    
    // XMLParser Delegete 메소드
    
    // XML 파서가 시작 테그를 만나면 호출됨
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
    }
    
    // XML 파서가 종료 테그를 만나면 호출됨
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "record" {
            items.append(item)
        }
    }
    
    // 현재 테그에 담겨있는 문자열 전달
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        // 공백제거
        let data = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        // 공백체크 후 데이터 뽑기
        if !data.isEmpty {
            item[currentElement] = data
        }
        
    }

}

extension ViewController : CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        self.mapView.showsUserLocation = true
    zoomMapOn(location: location)
    }
}

extension ViewController : MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? BusanData {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! BusanData
        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
}
