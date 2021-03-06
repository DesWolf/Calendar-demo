//
//  DetailedDayVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/21/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftKeychainWrapper

//enum Settings: String {
//    case timeTable      = "График свободного времени"
//    case discipline     = "Предмет занятий"
//    case notification   = "Уведомления"
//    case subscription   = "Оформить подписку"
//    case account        = "Учетная запись"
//}

class ProfileVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var singOutButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    var cameraAccess: Bool?
    var onTimeTableTap: (() -> (Void))?
    var onDisciplinesTap: (() -> (Void))?
    private let notifications = Notifications()
    
    var settings = [ "График свободного времени",
                     "Предмет занятий",
                     "Учетная запись",
                     //"Оформить подписку",
                     "Уведомления"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureScreen()
    }
    
    @IBAction func imageTap(_ sender: Any) {
        if cameraAccess == nil || cameraAccess == false {
            requestCameraAccess()
        } else {
            addImage()
        }
    }
    
    @IBAction func nameTap(_ sender: Any) {
        UIAlertController.addTextAlert(target: self,
                                       title: "Укажите ваше имя",
                                       text: "")
        { (name: String?) in
            guard let name = name else { return }
            self.nameLabel.text = name
        }
    }
    
    @IBAction func signOut(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: "accessToken")
        KeychainWrapper.standard.removeObject(forKey: "userId")
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let loginPage = mainStoryboard.instantiateViewController(withIdentifier: "LoginNavController") as! UINavigationController
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = loginPage
    }
    
    func addImage() {
        let cameraIcon = #imageLiteral(resourceName: "camera")
        let photoIcon = #imageLiteral(resourceName: "photo")
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        
        camera.setValue(cameraIcon, forKey: "image")
        camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let photo = UIAlertAction(title: "Photo", style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
        
        photo.setValue(photoIcon, forKey: "image")
        photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
    }
}

//MARK: Setup Screen
extension ProfileVC {
    private func configureScreen() {
        background.backgroundColor = .appBackGray
        UINavigationBar().set(controller: self)
        tableView.tableFooterView = UIView()
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.layer.borderColor = UIColor.fieldBorder.cgColor
        profileImage.layer.borderWidth = 0.5
        singOutButton.tintColor = .appBlue
        
        if let image = loadImageFromDiskWith(fileName: "profileImage") {
            profileImage.image = image
        }
    }
}

//MARK: TableViewDelegate, TableViewDataSourse
extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileCell
        let setting = settings[indexPath.row]
        
        cell.configere(name: setting)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            onTimeTableTap?()
        case 1:
            onDisciplinesTap?()
        case 2:
            print("Профиль")
            //        case 3:
        //            print("Подписка")
        case 3:
            print("Уведомления")
            requestNotificationAccess()
        default:
            return
        }
    }
}

//MARK: Request access to camera and Notifications
extension ProfileVC {
    
    func requestCameraAccess()  {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            cameraAccess = true
        } else {
            if cameraAccess == false {
                UIAlertController.goSettings(title: "Для добавление фото, необходимо предоставить доступ к камере в настройках телефона",
                                             msg: "Перейти в Настройки?",
                                             target: self)
            } else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    if granted {
                        self.cameraAccess = true
                    } else {
                        self.cameraAccess = false
                    }
                })
            }
        }
    }
    
    func requestNotificationAccess() {
        let center  = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
            DispatchQueue.main.async {
                if granted == false {
                    
                    UIAlertController.goSettings(title: "Для получения уведомлений о запланированных мероприятиях, необходимо предоставить доступ в настройках телефона",
                                                 msg: "Перейти в Настройки?",
                                                 target: self)
                } else {
                    UIAlertController.simpleAlert(title: "Уведомления включены", msg: "Мы напомним вам о предстоящих занятиях", target: self)
                }
            }
        }
    }
}

// MARK: Work with image
extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        profileImage.image = info[.editedImage] as? UIImage
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        
        saveImage(imageName: "profileImage", image: profileImage.image)
        dismiss(animated: true)
    }
    
    func saveImage(imageName: String, image: UIImage?) {
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image?.jpegData(compressionQuality: 1) else { return }
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
        
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
        
    }
    
    func loadImageFromDiskWith(fileName: String) -> UIImage? {
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }
        
        return nil
    }
}
