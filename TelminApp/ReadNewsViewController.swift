//
//  ReadNewsViewController.swift
//  TelminApp
//
//  Created by KEOSALY on 10/1/17.
//  Copyright © 2017 KEOSALY. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import NVActivityIndicatorView
class ReadNewsViewController: UIViewController {

    @IBOutlet weak var viewIndicator: NVActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    var newsData:Dictionary<String,AnyObject>?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let imgUrl = newsData?["image"] as? String
        
        var strImg = ""
        var strURL = "https://www.aseantelmin17.gov.kh/mobile/article/\(newsData!["slug"] as! String)"
        let url = URL(string: strURL)
        if let unwrappedURL = url {
            
            let request = URLRequest(url: unwrappedURL)
            let session = URLSession.shared
            
            let task = session.dataTask(with: request) { (data, response, error) in
                
                if error == nil {
                    
                    self.webView.loadRequest(request)
                    
                } else {
                    
                    print("ERROR: \(error)")
                    
                }
                
            }
            
            task.resume()
            
        }
//        if((imgUrl ?? nil ) != nil)
//        {
//            
//            let fullNameArr = imgUrl?.components(separatedBy: ".")
//            let name    = fullNameArr?[0]
//            let surname = fullNameArr?[1]
//             strImg = "https://www.aseantelmin17.gov.kh/storage/"+"\(name!+"-small."+surname!)"
//        }
//        webView.scrollView.bounces = false
//        let body = newsData?["body"] as! String
//       
//        let str="<center>"+"<img src='"+"\(strImg)"+"' width='100%'/>"+"</center>"
//        let title = newsData?["title"] as! String
//        var getHTML = newsData?["body"] as! String
//       
//        webView.loadHTMLString(str.appending("<h3>"+title+"</h3>"+body), baseURL: nil)
        
    }

    func webViewDidStartLoad(_ webView: UIWebView) {
        showLoadingIndicator()
        //self.progressView.setProgress(0.1, animated: false)
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        viewIndicator.stopAnimating()
        // self.progressView.setProgress(1.0, animated: true)
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
