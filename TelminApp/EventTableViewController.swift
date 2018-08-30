
//
//  EventTableViewController.swift
//  TelminApp
//
//  Created by KEOSALY on 10/3/17.
//  Copyright © 2017 KEOSALY. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class EventTableViewController: ViewController,UITableViewDataSource,UITableViewDelegate {
    var data = Array<Dictionary<String,AnyObject>>()
    var telminObj = Array<Dictionary<String,AnyObject>>()
    var dictCH = Dictionary<String,String>()
    
    

    @IBOutlet weak var viewIndicator: NVActivityIndicatorView!
    var valCOUNT = 0
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    @IBOutlet weak var eventTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingIndicator()
        downloadImage()
        let userCount1 = UserCore.getUser()
        if(userCount1 != "")
        {
            let logo = UIImage(named: "profile.png")
            self.navigationItem.rightBarButtonItem?.image = logo
        }
        //Load Drawer
        if self.revealViewController() != nil {
            self.revealViewController().rearViewRevealWidth = self.view.frame.width - 64 //changing the width of the rear view in SWRevealController
            btnMenu.target = self.revealViewController()
            btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }else{
            
        }
        
        AppUtils.applyNavigatonColor(self.navigationController!)
        let userCount = UserCore.getUser()
        //print("SALY::\(userCount)")
        if(userCount == "")
        {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "loginBoard") as! LoginViewController
            self.present(next, animated: true, completion: nil)
            
        }else{
            downloadData()
        }
       
       // print("test:::\(UserCore.getUser())")
        
        
        //var ge = data[0]["created_at"] as! String
        //print("SAM:::\(data)")
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    var mecount = 0
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventTableView.dequeueReusableCell(withIdentifier: "cellEvent", for: indexPath) as! EventTableViewCell

        
        
        let fullDate = data[indexPath.row]["date_text"] as! String
        
        var checkCount = 0
        if(indexPath.row > 0)
        {
            checkCount = (indexPath.row - 1)
        }
        let chDate = data[checkCount]["date_text"] as! String
        if(checkCount > 0 && fullDate.contains(chDate))
        {
            print(chDate)
            cell.lblTimeText.text = ""
            cell.lblTimeEvent.text = ""
            cell.lblTitle.text = data[indexPath.row]["time_text"] as! String
            cell.lblRemarks.text = data[indexPath.row]["remarks"] as! String
            cell.lblActivity.text = data[indexPath.row]["activity"] as! String
            return cell
            
        }
        if(fullDate != "")
        {
            var cutDay = fullDate.split(separator: " ")
            var day = cutDay[1]
            var month = cutDay[2]
            cell.lblTimeText.text = String(month)
            cell.lblTimeEvent.text = String(day)
        }
     
        cell.lblTitle.text = data[indexPath.row]["time_text"] as! String
        cell.lblRemarks.text = data[indexPath.row]["remarks"] as! String
        cell.lblActivity.text = data[indexPath.row]["activity"] as! String
        
       
        
        
       
        
        return cell
    }
    
    func downloadData(){
         let userCount = UserCore.getUser()
        var con1 = "Bearer \(userCount)"
       // print(con1)
        
        let params = [
            "Authorization": con1,
            "Content-Type": "application/json"
        ]
        let url = "https://www.aseantelmin17.gov.kh/api/events"
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Authorization" : con1,"Content-Type": "application/json"])
            .responseJSON { response in
            var obj0 = response.value as! Array<Dictionary<String,AnyObject>>
                
            for x in obj0
            {
                var obj1 = x["telmin_item_event"] as! Array<Dictionary<String,AnyObject>>
                var dict = Dictionary<String,String>()
                
                dict["date_text"] = x["date_text"] as! String
                self.dictCH["date"]=x["date_text"] as! String
                if(obj1.count==0)
                {
                    dict["activity"] = ""
                    dict["remarks"] = ""
                    dict["time_text"] = ""
                    self.data.append(dict as [String : AnyObject])
                }else{
                    for y in obj1
                    {
                        
                        dict["activity"] = y["activity"]! as! String
                        dict["remarks"] = y["remarks"]! as! String
                        dict["time_text"] = y["time_text"]! as! String
                        
                        self.data.append(dict as [String : AnyObject])
                        
                        
                    }
                }
                
            }

            self.eventTableView.reloadData()
            self.viewIndicator.stopAnimating()

        }
        
    }
    func checkProfile() {
        
        
        let rootVC:ProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: "profileBoard") as! ProfileViewController
        rootVC.index = 2
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
    func showLoadingIndicator(){
        var controller = MenuTableViewController()
        controller.viewDidAppear(true)
        viewIndicator.type = .ballSpinFadeLoader;
        viewIndicator.color=UIColor.black;
        viewIndicator.startAnimating()
    }

}
