//
//  StatisticsVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/21/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class StatisticTVC: UITableViewController {

    
    @IBOutlet weak var numberOfStudentsLabel: UILabel!
    @IBOutlet weak var numberOfPlannedLessonsLabel: UILabel!
    @IBOutlet weak var numberOfFinishedLessonsLabel: UILabel!
    @IBOutlet weak var numberOfCancelLessonsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
