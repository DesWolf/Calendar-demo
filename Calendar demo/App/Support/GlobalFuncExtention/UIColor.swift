//
//  Collors.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 5/25/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

extension UIColor {

    static let iconsGray = UIColor(red: 209/255, green: 209/255, blue: 214/255, alpha: 1)
    static let separator = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
    
    static let appBlueLignt = UIColor(red: 83/255, green: 185/255, blue: 208/255, alpha: 1)
    static let appBlueDark = UIColor(red: 88/255, green: 110/255, blue: 180/255, alpha: 1)
    static let appGray = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
    static let appPink = UIColor(red: 217/255, green: 133/255, blue: 234/255, alpha: 1)
    static let appLightGreen = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1)
    static let appBackGray = UIColor(red: 253/255, green: 253/255, blue: 253/255, alpha: 1)
    static let appTabIconGray = UIColor(red: 143/255, green: 155/255, blue: 167/255, alpha: 1)
    static let appBlue = UIColor(red: 0/255, green: 73/255, blue: 196/255, alpha: 1)
    static let appLightBlue = UIColor(red: 235/255, green: 243/255, blue: 252/255, alpha: 1)
    
    static let fieldBackGray = UIColor(red: 244/255, green: 245/255, blue: 246/255, alpha: 1)
    static let fieldBorder = UIColor(red: 224/255, green: 225/255, blue: 227/255, alpha: 1)
    
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
