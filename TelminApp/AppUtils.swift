//
//  AppUtils.swift
//  NiptechResilientPro
//
//  Created by SALY-Mac on 2/8/17.
//  Copyright © 2017 SALY-Mac. All rights reserved.
//
import Foundation
import UIKit
class AppUtils
{
    static var AppTableHomeCell="cellhome";
    static var AppTableVideoCell="cellvideos";
    
    static func applyShadow(_ backgroudView:UIView)
    {
        //Shadow View
        backgroudView.layer.cornerRadius=5;
        backgroudView.layer.shadowColor = UIColor.black.cgColor;
        backgroudView.layer.shadowOpacity = 0.5;
        backgroudView.layer.shadowOffset = CGSize.zero
    }
    static func applyNavigatonColor(_ navigationController:UINavigationController)
    {
        //use for set Title Color of UINavigationItem
        navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    }
    static func circularImage(_ photoImageView: UIImageView?)
    {
        photoImageView!.layer.frame = photoImageView!.layer.frame.insetBy(dx: 0, dy: 0)
        //photoImageView!.layer.borderColor = UIColor.init(hex: 0x25B31F, alpha: 1).CGColor
        photoImageView!.layer.borderColor = UIColor.white.cgColor
        photoImageView!.layer.cornerRadius = photoImageView!.frame.height/2
        photoImageView!.layer.masksToBounds = false
        photoImageView!.clipsToBounds = true
        photoImageView!.layer.borderWidth = 2.5
        photoImageView!.contentMode = UIViewContentMode.scaleAspectFill
    }
    static func imageCicle(imageBtn:UIButton)
    {
        imageBtn.layer.borderWidth = 1
        imageBtn.layer.masksToBounds = false
        imageBtn.layer.borderColor = UIColor.white.cgColor
        imageBtn.layer.cornerRadius = imageBtn.frame.height/2
        imageBtn.clipsToBounds = true
    }

}
