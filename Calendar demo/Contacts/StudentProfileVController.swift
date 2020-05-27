//
//  StudentProfileVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 5/26/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class StudentProfileVController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var statisticView: UIView!
    @IBOutlet weak var lessonsView: UIView!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func switchViewSegmControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            profileView.alpha = 1
            lessonsView.alpha = 0
            statisticView.alpha = 0
        case 1:
            profileView.alpha = 0
            lessonsView.alpha = 1
            statisticView.alpha = 0
        case 2:
            profileView.alpha = 0
            lessonsView.alpha = 0
            statisticView.alpha = 1
        default:
            return
        }
    

    
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
