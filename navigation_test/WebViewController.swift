//
//  WebViewController.swift
//  navigation_test
//
//  Created by D7702_10 on 2018. 11. 21..
//  Copyright © 2018년 ksh. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {    
    @IBOutlet var WebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://www.ev.or.kr/portal/main")
        let request = URLRequest(url: url!)
        
        WebView.load(request)
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
