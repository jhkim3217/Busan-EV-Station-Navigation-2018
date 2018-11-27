//
//  ViewController.swift
//  navigation_test
//
//  Created by test on 2018. 11. 6..
//  Copyright © 2018년 ksh. All rights reserved.
//

import UIKit
import MapKit
@available(iOS 10.0, *)
@available(iOS 10.0, *)
@available(iOS 10.0, *)
class ViewController: UIViewController, XMLParserDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet var searchBtn: UIButton!
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
    var type: String?
    var company: String?
    var startTime: String?
    var endTime: String?
    var holiday: String?
    var phoneNum: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "부산 전기차 충전소"
        
//        self.searchBtn.layer.cornerRadius = 10
//        self.searchBtn.layer.borderColor = UIColor.black.cgColor
//        self.searchBtn.layer.borderWidth = 0.5
        
        self.mapView.showsUserLocation = true
        
        
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
        
//        let initialLocation = CLLocation(latitude: 35.1795543, longitude: 129.075641)
//        zoomMapOn(location: initialLocation)
        
//        let sampleMangmi = BusanData(title: "망미동 공영주차장", subtitle: "부산광역시 수영구 금련로 43번길 17", coordinate: CLLocationCoordinate2D(latitude: 35.1657709, longitude: 129.0703436))
//        mapView.addAnnotation(sampleMangmi)
        
        mapView.delegate = self
        
         //초기맵 설정
        zoomToRegion()
        
        for item in items {
            name = item["충전소명"]
            loc = item["소재지도로명주소"]
            lat = item["위도"]
            long = item["경도"]
            type = item["급속충전타입구분"]
            company = item["관리업체명"]
            startTime = item["이용가능시작시각"]
            endTime = item["이용가능종료시각"]
            holiday = item["휴점일"]
            phoneNum = item["관리업체전화번호"]
            
            
            dLat = Double(lat!)
            dLong = Double(long!)
            annotation = BusanData(title: name!, subtitle: loc!, coordinate: CLLocationCoordinate2D(latitude: dLat!, longitude: dLong!), type: type!, company: company!, startTime: startTime!, endTime: endTime!, holiday: holiday!, phoneNum: phoneNum!, lat: lat!, long: long!)
            annotations.append(annotation!)
        }
        //mapView.showAnnotations(annotations, animated: true)
        mapView.addAnnotations(annotations)

        
    } // viewDidLoad()
    
    
    @IBAction func current(_ sender: Any) {
        let userLocation = mapView.userLocation
        let region = MKCoordinateRegion(center: (userLocation.location?.coordinate)!, latitudinalMeters: 3000, longitudinalMeters: 3000)
        mapView.setRegion(region, animated: true)
    }
    @IBAction func zoomIn(_ sender: Any) {
        print("zoom in pressed")
        var r = mapView.region
        r.span.latitudeDelta = r.span.latitudeDelta / 2
        r.span.longitudeDelta = r.span.longitudeDelta / 2
        self.mapView.setRegion(r, animated: true)
    }
    
    @IBAction func zoomOut(_ sender: Any) {
        print("zoom out pressed")
        var r = mapView.region
        r.span.latitudeDelta = r.span.latitudeDelta * 2
        r.span.longitudeDelta = r.span.longitudeDelta * 2
        self.mapView.setRegion(r, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLcationServiceAuthenticationStatus()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        if let annotation = annotation as? BusanData {
            let identifier = "pin"
            let annotationview = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            annotationview.image = UIImage(named: "pin")
            
            let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            annotationview.image = UIImage(named: "pin")
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                
                view.image = UIImage(named: "pin")
            } else {
                
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
                //view.leftCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
                view.image = UIImage(named: "pin")
            }
            
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            //guard let annotation = view.annotation as? BusanData, let maintitle = annotation.title else { return }
            
            guard let annotation = view.annotation as? BusanData else { return }
            guard let maintitle = annotation.title else { return }
            guard let detialtitle = annotation.subtitle else { return }
            guard let type = annotation.type else { return }
            guard let company = annotation.company else { return }
            guard let startTime = annotation.startTime else { return }
            guard let endTime = annotation.endTime else { return }
            guard let holiday = annotation.holiday else { return }
            guard let phoneNum = annotation.phoneNum else { return }
            guard let lat = annotation.lat else { return }
            guard let long = annotation.long else { return }
            
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "TableViewController") as? TableViewController
            
            vc?.maintitleString = maintitle
            vc?.detailtitleString = detialtitle
            vc?.typeString = type
            vc?.companyString = company
            vc?.startTimeString = startTime
            vc?.endTimeString = endTime
            vc?.holidayString = holiday
            vc?.phoneNumString = phoneNum
            vc?.latString = lat
            vc?.longString = long
            
            
            self.navigationController?.pushViewController(vc!, animated: true)
            
            
        }
        //        else if control == view.leftCalloutAccessoryView {
        //            let location = view.annotation as! BusanData
        //            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        //            location.mapItem().openInMaps(launchOptions: launchOptions)
        //        }
    }
    
    
    func zoomToRegion() {
        let location = CLLocationCoordinate2D(latitude: 35.180100, longitude: 129.081017)
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    private let regionRadius: CLLocationDistance = 1000 // 1km ~ 1.6km(1mile)
    
    func zoomMapOn(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
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
    //mkpinannotationview image
    
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

//extension ViewController : CLLocationManagerDelegate
//{
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location = locations.last!
//        self.mapView.showsUserLocation = true
//    zoomMapOn(location: location)
//    }
//}


