//
//  ReadPDFViewController.swift
//  TelminApp
//
//  Created by KEOSALY on 10/2/17.
//  Copyright © 2017 KEOSALY. All rights reserved.
//

import UIKit

class ReadPDFViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var strURL:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.scrollView.bounces = false
        let fullLink = "https://www.aseantelmin17.gov.kh/storage/"+strURL!
        let url : URL! = URL(string: fullLink)
        webView.loadRequest(URLRequest.init(url: url as URL))
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
