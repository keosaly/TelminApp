//
//  SplashViewController.swift
//  iFeedsApp
//
//  Created by SALY-Mac on 12/23/16.
//  Copyright © 2016 SALY-Mac. All rights reserved.
//

import UIKit
//import NVActivityIndicatorView

class SplashViewController: UIViewController{

    //@IBOutlet weak var viewIndicator: NVActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let countDownThread=Thread(target: self, selector: #selector(SplashViewController.countDown), object: nil);
        countDownThread.start();
        
        //showLoadingIndicator();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    func showLoadingIndicator(){
//        viewIndicator.type = .ballRotate;
//        viewIndicator.color=UIColor.white;
//        viewIndicator.startAnimating()
//    }
    //Splash Screen
    func countDown()
    {
        let count=3;
        
        for i in 0 ..< count {
            
            //next screen
            if(i==count)
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "revealBoard") as? SWRevealViewController
                self.present(vc!, animated: true, completion: nil)
                //print("Test OK::\(i)")
            }
            print("Count::\(i)")
            if(i==2)
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "revealBoard") as? SWRevealViewController
                self.present(vc!, animated: true, completion: nil)
            }
            Thread.sleep(forTimeInterval: 0.5);// 1 second
            
        }
        
        
    }

}
