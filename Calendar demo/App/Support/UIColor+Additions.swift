//
//  Collors.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 5/25/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let rwGreen = UIColor(red: 0.0/255.0, green: 104.0/255.0, blue: 55.0/255.0, alpha: 1.0)
    static let bgStudent = UIColor(red: 81/255, green: 108/255, blue: 180/255, alpha: 1)
    static let bgStudentTransperent = UIColor(red: 81/255, green: 108/255, blue: 180/255, alpha: 0.3)
    static let iconsGray = UIColor(red: 209/255, green: 209/255, blue: 214/255, alpha: 1)
    
    static let appBlueLignt = UIColor(red: 83/255, green: 185/255, blue: 208/255, alpha: 1)
    static let appBlueDark = UIColor(red: 88/255, green: 110/255, blue: 180/255, alpha: 1)
    static let appGray = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
    
    
    static func setGradientToTableView(tableView: UITableView, height: Double) {

        let backLayer = CAGradientLayer()
        
        backLayer.colors = [appGray.cgColor, appGray.cgColor]
        backLayer.locations = [0.0,1.0]
        backLayer.frame = tableView.bounds

        let gradientLayer = CAGradientLayer()
        
        let gradientBackgroundColors = [appBlueLignt.cgColor, appBlueDark.cgColor]
        gradientLayer.colors = gradientBackgroundColors
        gradientLayer.locations = [0.0,1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)

        let width = tableView.bounds.width
        gradientLayer.frame = CGRect(x: 0, y: 0, width: Int(width), height: Int(height))
        
        let backgroundView = UIView(frame: tableView.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 1)
        backgroundView.layer.insertSublayer(backLayer, at: 0)
        tableView.backgroundView = backgroundView
    }
    
}

extension CGColor {
    @available(iOS 13.0, *)
    static let appBlueLignt = CGColor(srgbRed: 83/255, green: 185/255, blue: 208/255, alpha: 1)
    @available(iOS 13.0, *)
    static let appBlueDark = CGColor(srgbRed: 88/255, green: 110/255, blue: 180/255, alpha: 1)
}
