//
//  ProfileNavController.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 7/10/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class ProfileNavController: UINavigationController {
    
    private let stStoryboard = UIStoryboard(name: "Profile", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        openSettings()
    }
    
    
    func openSettings() {
        let profile = stStoryboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        
        profile.onTimeTableTap = { [weak self]  in
            guard let self = self else { return }
            self.openTimeTable()
        }
        
        profile.onDisciplinesTap = { [weak self]  in
            guard let self = self else { return }
            self.openDisciplines()
        }
        
        pushViewController(profile, animated: false)
    }
    
    func openTimeTable() {
        let timeTable = stStoryboard.instantiateViewController(withIdentifier: "TimeTableTVC") as! TimeTableTVC
        
        pushViewController(timeTable, animated: true)
        
    }
    
    func openDisciplines() {
        let disciplines = stStoryboard.instantiateViewController(withIdentifier: "DisciplinesForSettingsTVC") as! DisciplinesForSettingsTVC
        
        pushViewController(disciplines, animated: true)
    }
    
    
}
