//
//  AddViewController.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 8/2/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

//import UIKit
//
//class AddViewController: UIViewController  {
//    
//    
//    @IBOutlet weak var collection: UICollectionView!
//    @IBOutlet weak var table: UITableView!
//    @IBOutlet weak var startDate: UILabel!
//    @IBOutlet weak var endDate: UILabel!
//    
//    private var datePicker = UIDatePicker()
//    private let type = ["Занятие", "Мероприятие"]
//    private var typeBool: EventType = .lesson
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//    }
//    
//    
//    
//}
//
////MARK: CollectionViewDelegate, CollectionViewDataSource
//extension AddViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return type.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "type", for: indexPath) as! TypeCollectionViewCell
//        var mode = false
//        
//        if typeBool == .lesson && indexPath.row == 0 || typeBool == .event && indexPath.row == 1 {
//            mode = true
//        }
//        cell.configure(name: type[indexPath.row], mode: mode)
//        cell.layer.cornerRadius = cell.frame.height / 4
//        
//        return cell
//    }
//    
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = indexPath.row == 0 ? 100 : 150
//        
//        return CGSize(width: width, height: 36)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
//    }
//    
//    
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        switch indexPath.row {
//        case 0:
//            typeBool = .lesson
//        case 1:
//            typeBool = .event
//        default:
//            return
//        }
//        collectionView.reloadData()
//        table.reloadData()
//    }
//    
//    
//}
//
////MARK: CollectionViewDelegate, CollectionViewDataSource
//extension AddViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        3
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var cell = UITableViewCell()
//        
//        switch indexPath.row {
//        case 0:
//            cell = table.dequeueReusableCell(withIdentifier: "startDate")!
//        default:
//            break
//        }
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row == 0 {
//            showPicker()
//        }
//    }
//    
//}
//
//extension AddViewController {
//    
//    func showPicker() {
//        let toolbar = UIToolbar()
//        toolbar.sizeToFit()
//        
//        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
//        toolbar.setItems([doneButton], animated: true)
////        startDate.inputAccessoryView = toolbar
//        
////        startDate.inputView = datePicker
//        
//    }
//    
//    @objc func doneAction() {
//        startDate.text = "\(datePicker.date)"
//        
//    }
//}
//
