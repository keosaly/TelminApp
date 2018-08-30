//
//  MenuTableViewController.swift
//  TelminApp
//
//  Created by KEOSALY on 9/30/17.
//  Copyright © 2017 KEOSALY. All rights reserved.
//
import UIKit
import Alamofire
import AlamofireImage
class MenuTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var imgLogoUser: UIImageView!

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    
    var data = Array<Dictionary<String,AnyObject>>()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        var dic = Dictionary<String,String>();
        dic["title"]="Home"
        dic["img"]="ic_home"
        data.append(dic as [String : AnyObject])
        dic["title"]="ASEAN"
        dic["img"]="ic_general"
        data.append(dic as [String : AnyObject])
        dic["title"]="Cambodia"
        dic["img"]="ic_general"
        data.append(dic as [String : AnyObject])
        dic["title"]="TELMIN"
        dic["img"]="ic_general"
        data.append(dic as [String : AnyObject])
        dic["title"]="TELSOM"
        dic["img"]="ic_general"
        data.append(dic as [String : AnyObject])
        dic["title"]="Theme&Logo"
        dic["img"]="ic_theme"
        data.append(dic as [String : AnyObject])
        dic["title"]="Program"
        dic["img"]="ic_program"
        data.append(dic as [String : AnyObject])
        dic["title"]="Contact US"
        dic["img"]="ic_declaration"
        data.append(dic as [String : AnyObject])
        dic["title"]="Logout"
        dic["img"]="ic_logout"
        data.append(dic as [String : AnyObject])
        
        downloadData()
        
        AppUtils.circularImage(imgLogoUser)
        
        menuTableView.dataSource=self;
        menuTableView.delegate=self;
        menuTableView.estimatedRowHeight = 100
        menuTableView.rowHeight =  UITableViewAutomaticDimension
        //menuTableView.reloadData()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        var con = ProfileViewController()
        con.Controller = self
    }
    override func viewDidAppear(_ animated: Bool) {
        //downloadData()
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
        let cell = menuTableView.dequeueReusableCell(withIdentifier: "cellMenu", for: indexPath) as! MenuTableViewCell
        cell.lblTitle.text=data[indexPath.row]["title"] as! String
        let imgName=data[indexPath.row]["img"] as! String
        cell.imgIconMenu.image=UIImage(named: imgName)
        // Configure the cell...

        return cell
    }
 

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if(indexPath.row == 0)//home
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "drawhome") as? UITabBarController
            vc?.selectedIndex=0
            self.revealViewController().pushFrontViewController(vc, animated: true)
        }else if(indexPath.row == 8){
            UserCore.deleteRecords()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "revealBoard") as? SWRevealViewController
            self.present(vc!, animated: true, completion: nil)
        }else{
            let rootVC:PageViewController = self.storyboard?.instantiateViewController(withIdentifier: "page") as! PageViewController
            rootVC.index=indexPath.row
            let nvc:UINavigationController = self.storyboard?.instantiateViewController(withIdentifier: "PageView") as! UINavigationController
            nvc.viewControllers = [rootVC]
            UIApplication.shared.keyWindow?.rootViewController = nvc
        
        }
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
                    print("SAD:::\(obj0["success"]!["email"]! as! String)")
                    self.lblEmail.text? = email
                    self.lblName.text? = name
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

}
