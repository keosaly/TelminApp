//
//  ProfileViewController.swift
//  TelminApp
//
//  Created by KEOSALY on 10/20/17.
//  Copyright © 2017 KEOSALY. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage


class ProfileViewController: UIViewController,SWRevealViewControllerDelegate {
    @IBOutlet weak var imgLogoUser: UIImageView!
    var index:Int?
    @IBOutlet weak var lblCreateDate: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    var Controller = MenuTableViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadData()
        print("SAD::::\(index)")
        // Do any additional setup after loading the view.
    }

    @IBAction func logoutFunc(_ sender: Any) {
        UserCore.deleteRecords()
        let next = self.storyboard?.instantiateViewController(withIdentifier: "loginBoard") as! LoginViewController
        self.present(next, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func downloadData(){
        
        let userCount = UserCore.getUser()
        var con1 = "Bearer \(userCount)"
        // print(con1)
        
        let params = [
            "Authorization": con1,
            "Content-Type": "application/json"
        ]
        if(userCount != "")
        {
            let url = "https://www.aseantelmin17.gov.kh/api/details"
            Alamofire.request(url, method: .post, encoding: JSONEncoding.default, headers: ["Authorization" : con1,"Content-Type": "application/x-www-form-urlencoded"])
                .responseJSON { response in
                    var obj0 = response.value as! Dictionary<String,AnyObject>;
                    var imageURL="https://www.aseantelmin17.gov.kh/storage/\(obj0["success"]!["avatar"]! as! String)"
                    var name = obj0["success"]!["name"]! as! String
                    var email = obj0["success"]!["email"]! as! String
                    var crateDate = obj0["success"]!["created_at"]! as! String
                    print("SAD:::\(obj0["success"]!["email"]! as! String)")
                    self.lblName.text? = name
                    self.lblEmail.text? = email
                    self.lblCreateDate.text? = crateDate
                    //download image
                    Alamofire.request(imageURL).responseImage { response in
                        debugPrint(response)
                        
                        print(response.request)
                        print(response.response)
                        debugPrint(response.result)
                        
                        if let image = response.result.value {
                            self.imgLogoUser.image = image
                        }
                    }
                    
            }
        }
        
        
        
    }
    @IBAction func backFun(_ sender: Any) {
        if(index == 1)
        {
            goToController(num: 1)
        }else if(index == 2){
            goToController(num: 2)
        }else{
           
            goToController(num: 0)
        }
    }
    
    func goToController(num:Int)  {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let sw = storyboard.instantiateViewController(withIdentifier: "revealBoard") as! SWRevealViewController
        
        self.view.window?.rootViewController = sw
        
        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "drawhome") as! UITabBarController
        destinationController.selectedIndex = num
        sw.pushFrontViewController(destinationController, animated: true)
    }
    

}
