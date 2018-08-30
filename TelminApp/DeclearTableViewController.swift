//
//  DeclearTableViewController.swift
//  TelminApp
//
//  Created by KEOSALY on 9/30/17.
//  Copyright © 2017 KEOSALY. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
class DeclearTableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
 @IBOutlet weak var viewIndicator: NVActivityIndicatorView!
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    var data = Array<Dictionary<String,AnyObject>>()
    @IBOutlet weak var decTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadImage()
        let userCount = UserCore.getUser()
        if(userCount != "")
        {
            let logo = UIImage(named: "profile.png")
            self.navigationItem.rightBarButtonItem?.image = logo
        }
        downloadData()

        //Load Drawer
        if self.revealViewController() != nil {
            self.revealViewController().rearViewRevealWidth = self.view.frame.width - 64 //changing the width of the rear view in SWRevealController
            btnMenu.target = self.revealViewController()
            btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        showLoadingIndicator()
        AppUtils.applyNavigatonColor(self.navigationController!)
        decTableView.dataSource=self;
        decTableView.delegate=self;
        decTableView.estimatedRowHeight = 100
        decTableView.rowHeight =  UITableViewAutomaticDimension
        decTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = decTableView.dequeueReusableCell(withIdentifier: "cellDec", for: indexPath) as! DeclearTableViewCell
        cell.lblTItle.text=data[indexPath.row]["title"] as! String


        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let DvC = Storyboard.instantiateViewController(withIdentifier: "showPDF") as! ReadPDFViewController
        DvC.strURL = data[indexPath.row]["pdf"] as! String
        self.navigationController?.pushViewController(DvC, animated: true)
        
    }
    

    func downloadData(){
        let userCount = UserCore.getUser()
        var con1 = "Bearer \(userCount)"
        let headers = [
            "Authorization" : con1,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        let params = [
            "slug": "declaration",
            "per": "10"
        ]
        
        if(userCount != "")
        {
            Alamofire.request("https://www.aseantelmin17.gov.kh/api/feeds" ,method: .post,parameters: params ,headers: headers)
                .responseJSON { response in
                    
                    var full = response.value as! Dictionary<String,AnyObject>
                    self.data = full["data"] as! Array<Dictionary<String,AnyObject>>
                    self.viewIndicator.stopAnimating()
                    self.decTableView.reloadData()
                    //self.viewIndicator.stopAnimating()
                    print(full["data"])
            }
        }else{
            Alamofire.request("https://www.aseantelmin17.gov.kh/api/feeds/declaration/10").responseJSON { response in
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
                
                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                    
                    var da = Dictionary<String,AnyObject>()
                    da = json as! Dictionary<String, AnyObject>
                    
                    self.data = da["data"] as! Array<Dictionary<String, AnyObject>>
                    self.viewIndicator.stopAnimating()
                    self.decTableView.reloadData()
                }
            }
        }
    }
    
    func showLoadingIndicator(){
        var controller = MenuTableViewController()
        controller.viewDidAppear(true)
        viewIndicator.type = .ballSpinFadeLoader;
        viewIndicator.color=UIColor.black;
        viewIndicator.startAnimating()
    }

    func checkProfile() {
        
        
        let rootVC:ProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: "profileBoard") as! ProfileViewController
        rootVC.index = 1
        let nvc:UINavigationController = self.storyboard?.instantiateViewController(withIdentifier: "navigat_profile") as! UINavigationController
        nvc.viewControllers = [rootVC]
        UIApplication.shared.keyWindow?.rootViewController = nvc
    }
    @IBAction func logoutFunc(_ sender: Any) {
        let count = UserCore.getUser()
        if(count == "")
        {
            deleteLogOut()
        }
        
    }
    func deleteLogOut() {
        //UserCore.deleteRecords()
        let next = self.storyboard?.instantiateViewController(withIdentifier: "loginBoard") as! LoginViewController
        self.present(next, animated: true, completion: nil)
    }
    func downloadImage(){
        
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
                    //download image
                    Alamofire.request(imageURL).responseImage { response in
                        debugPrint(response)
                        
                        print(response.request)
                        print(response.response)
                        debugPrint(response.result)
                        
                        if let image = response.result.value {
                            
                            //
                            //                            let size = CGSize(width: 24, height: 28)
                            //                            let finalImg = image.af_imageAspectScaled(toFit: size)
                            //                            self.navigationItem.rightBarButtonItem?.image = finalImg
                            let button = UIButton.init(type: .custom)
                            button.setImage(image, for: UIControlState.normal)
                            
                            button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
                            AppUtils.imageCicle(imageBtn: button)
                            let barButton = UIBarButtonItem.init(customView: button)
                            button.addTarget(self, action:#selector(self.checkProfile), for: UIControlEvents.touchUpInside)
                            self.navigationItem.rightBarButtonItem = barButton
                            
                        }
                    }
                    
            }
        }
        
        
        
    }
}
