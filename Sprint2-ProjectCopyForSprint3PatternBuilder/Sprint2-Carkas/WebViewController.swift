//
//  WebViewController.swift
//  Sprint2-Carkas
//
//  Created by Aleksey Shepelev on 15/11/2019.
//  Copyright © 2019 Дмитрий Гришин. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var webView: WKWebView!
    var link : String!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
//        webView.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.height - 100)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string: link)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.documentElement.outerHTML.toString()") { (html, error) in
            guard let html = html as? String else { return }
            let range = NSRange(location: 0, length: html.count)
            let regex = try! NSRegularExpression(pattern: "<pre>[a-z0-9]{64}</pre>")
            let match = regex.firstMatch(in: html, options: [], range: range)
        
            guard let _match = match else { return }
            let tokenStr = String(html[Range(_match.range, in: html)!])
            let tokenRange = Range(NSRange(location: 5, length: 64), in: tokenStr)
            UserDefaults.standard.set(String(tokenStr.substring(with: tokenRange!)), forKey: "token")
        }
    }
}



