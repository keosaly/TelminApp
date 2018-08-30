//
//  LoginViewController.swift
//  TelminApp
//
//  Created by KEOSALY on 10/3/17.
//  Copyright © 2017 KEOSALY. All rights reserved.
//

import UIKit
import Alamofire
class LoginViewController: UIViewController {
    @IBOutlet weak var txtUsername: UITextField!

    @IBOutlet weak var txtPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        txtPassword.isSecureTextEntry = true
        // Do any additional setup after loading the view.
    }

    @IBAction func saveFun(_ sender: Any) {

        
        logIn(txtUsername.text!, password: txtPassword.text!)
       
    }
    @IBAction func cancelFun(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "revealBoard") as? SWRevealViewController
        self.present(vc!, animated: true, completion: nil)
    }
    
    
    func logIn(_ userName : String, password : String) {
        
        let params = [
            "email": userName, //email
            "password": password //password
        ]
        
        var statusCode: Int = 0
    
        
        let apiMethod = "https://www.aseantelmin17.gov.kh/api/login"
        
        Alamofire.request(apiMethod, method: .post, parameters: params, encoding: JSONEncoding.default).responseString { (response) in
            var data = response.value!
            data.contains("error")
            
            if(data.contains("error"))
            {
                let alertController = UIAlertController(title: "Invalid credentials!", message: nil, preferredStyle: .alert);
                           alertController.addAction(UIAlertAction(title: "OK", style: .default,handler: nil));
                
                    self.present(alertController, animated: true, completion: nil)
            }else{
                
                
                var finalword = data.split(separator: ":")
                var tokenstr = finalword[2]
                var re = tokenstr.replacingOccurrences(of: "}", with: "")
                
                var re2 = re.replacingOccurrences(of: "\"", with: "")
                print(re2)
                        UserCore.storeUser(userName, password: password,token: re2)
                
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "revealBoard") as? SWRevealViewController
                        self.present(vc!, animated: true, completion: nil)
            }
        
        }
        
        
    
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
