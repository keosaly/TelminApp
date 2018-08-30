//
//  NewsTableViewController.swift
//  TelminApp
//
//  Created by KEOSALY on 9/30/17.
//  Copyright © 2017 KEOSALY. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import NVActivityIndicatorView
import CoreData

class NewsTableViewController: ViewController,UITableViewDataSource,UITableViewDelegate {
    var data = Array<Dictionary<String,AnyObject>>()
    //var passData = Dictionary<String,AnyObject>()
    @IBOutlet weak var viewIndicator: NVActivityIndicatorView!
    
    @IBOutlet weak var newsTableView: UITableView!

   var getIndex = 0
    
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadImage()
        print(getIndex)
        showLoadingIndicator()
        AppUtils.applyNavigatonColor(self.navigationController!)
        newsTableView.dataSource=self;
        newsTableView.delegate=self;
        newsTableView.estimatedRowHeight = 100
        newsTableView.rowHeight =  UITableViewAutomaticDimension
        
        
        //Load Drawer
        if self.revealViewController() != nil {
            self.revealViewController().rearViewRevealWidth = self.view.frame.width - 64 //changing the width of the rear view in SWRevealController
            btnMenu.target = self.revealViewController()
            btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        downloadData()
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        //Load Drawer
        if self.revealViewController() != nil {
            self.revealViewController().rearViewRevealWidth = self.view.frame.width - 64 //changing the width of the rear view in SWRevealController
            btnMenu.target = self.revealViewController()
            btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
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
        let cell = newsTableView.dequeueReusableCell(withIdentifier: "cellNews", for: indexPath) as! NewsTableViewCell
        
        
        var mi = data[indexPath.row]["image"] as? String
        print(mi)
        if((mi ?? nil ) != nil)
        {
            var imgUrl = data[indexPath.row]["image"] as! String
            let fullNameArr = imgUrl.components(separatedBy: ".")
            let name    = fullNameArr[0]
            let surname = fullNameArr[1]
            
            
            Alamofire.request("https://www.aseantelmin17.gov.kh/storage/\(name+"-small."+surname)").responseImage { response in
                debugPrint(response)
                
                print(response.request)
                print(response.response)
                debugPrint(response.result)
                
                if let image = response.result.value {
                    print("image downloaded: \(image)")
                    cell.imgViewNews.image = image
                }
            }

        }
        cell.lblTitle.text=data[indexPath.row]["title"] as! String
        cell.lblDesc.text=data[indexPath.row]["excerpt"] as! String

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let DvC = Storyboard.instantiateViewController(withIdentifier: "showDetail") as! ReadNewsViewController
        DvC.newsData = data[indexPath.row]
        self.navigationController?.pushViewController(DvC, animated: true)
        
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
    func downloadData(){
        let userCount = UserCore.getUser()
        var con1 = "Bearer \(userCount)"
        let headers = [
            "Authorization" : con1,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        let params = [
            "slug": "news",
            "per": "10"
        ]
        
        if(userCount != "")
        {
            Alamofire.request("https://www.aseantelmin17.gov.kh/api/feeds" ,method: .post,parameters: params ,headers: headers)
                .responseJSON { response in
                    
                    var full = response.value as! Dictionary<String,AnyObject>
                    self.data = full["data"] as! Array<Dictionary<String,AnyObject>>
                    self.newsTableView.reloadData()
                    self.viewIndicator.stopAnimating()
                    print(full["data"])
            }
        }else{
            Alamofire.request("https://www.aseantelmin17.gov.kh/api/feeds/news/10").responseJSON { response in
                            print("Request: \(String(describing: response.request))")   // original url request
                            print("Response: \(String(describing: response.response))") // http url response
                            print("Result: \(response.result)")                         // response serialization result
                
                            if let json = response.result.value {
                                print("JSON: \(json)") // serialized json response
                
                                var da = Dictionary<String,AnyObject>()
                                da = json as! Dictionary<String, AnyObject>
                
                                self.data = da["data"] as! Array<Dictionary<String, AnyObject>>
                                self.newsTableView.reloadData()
                                self.viewIndicator.stopAnimating()
                            }
                        }
        }
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
