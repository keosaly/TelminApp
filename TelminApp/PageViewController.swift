
 //
//  PageViewController.swift
//  TelminApp
//
//  Created by KEOSALY on 10/2/17.
//  Copyright © 2017 KEOSALY. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class PageViewController: UIViewController {
    var index:Int?
    
    @IBOutlet weak var viewIndicator: NVActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtils.applyNavigatonColor(self.navigationController!)
       
        var strURL = ""
        if(index! == 1)
        {
            strURL = "http://asean.org/asean/about-asean/overview/"
            self.navigationItem.title = "About ASEAN"
        }else if(index! == 2)
        {
            strURL = "https://www.aseantelmin17.gov.kh/mobile/page/about-cambodia"
            self.navigationItem.title = "About Cambodia"
        }else if(index! == 3)
        {
            strURL = "http://www.aseantelmin17.gov.kh/mobile/page/about-asean-telmin"
            self.navigationItem.title = "About ASEAN TELMIN"
        }else if(index! == 4)
        {
            strURL = "http://www.aseantelmin17.gov.kh/mobile/page/about-asean-telsom"
            self.navigationItem.title = "About ASEAN TELSOM"
        }else if(index! == 5)
        {
            strURL = "http://www.aseantelmin17.gov.kh/mobile/page/17th-telmin-logo-and-theme"
            self.navigationItem.title = "About Theme&Logo"
        }else if(index! == 6)
        {
            strURL = "https://www.aseantelmin17.gov.kh/mobile/page/programme"
            self.navigationItem.title = "Program"
        }else if (index! == 7)
        {
            strURL = "https://www.aseantelmin17.gov.kh/mobile/page/contact-us"
            self.navigationItem.title = "Contact"
        }
        let url = URL(string: strURL)
        if let unwrappedURL = url {
            
            let request = URLRequest(url: unwrappedURL)
            self.webView.loadRequest(request)
            let session = URLSession.shared
//            
//            let task = session.dataTask(with: request) { (data, response, error) in
//                
//                if error == nil {
//                    
//                    self.webView.loadRequest(request)
//                   
//                    
//                } else {
//                    
//                    print("ERROR: \(error)")
//                    
//                }
//                
//            }
//            
//            task.resume()
            
        }
        
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        showLoadingIndicator()
        //self.progressView.setProgress(0.1, animated: false)
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        viewIndicator.stopAnimating()
       // self.progressView.setProgress(1.0, animated: true)
    }
    
    @IBAction func backFun(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "revealBoard") as? SWRevealViewController
        self.present(vc!, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showLoadingIndicator(){
        var controller = MenuTableViewController()
        controller.viewDidAppear(true)
        viewIndicator.type = .ballSpinFadeLoader;
        viewIndicator.color=UIColor.black;
        viewIndicator.startAnimating()
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
