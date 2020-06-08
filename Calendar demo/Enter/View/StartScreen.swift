//
//  StartScreen.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 5/24/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

@IBDesignable class StartScreen: UIView {
    
    @IBOutlet var startScreenView: UIView!
    @IBOutlet weak var myLabel: UILabel!
    
    var view: UIView!
    var nibName: String = "StartScreen"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func loadFromNimb() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "StartScreen", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }
    
    func setup() {
        view = loadFromNimb()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(view)
    }
    
   
}

