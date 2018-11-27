//
//  MyWebViewViewController.swift
//  navigation_test
//
//  Created by 김종현 on 26/11/2018.
//  Copyright © 2018 ksh. All rights reserved.
//

import UIKit
import WebKit 

class MyWebViewViewController: UIViewController, WKUIDelegate {

    @IBOutlet weak var myWebView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://www.ev.or.kr/portal/main")
        //let request = URLRequest(url: url!)
        let myRequest = URLRequest(url: url!)
        myWebView.load(myRequest)

        
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
