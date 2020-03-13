//
//  AddWeaponVC.swift
//  HelpForRust
//
//  Created by Сергей Гриневич on 22/12/2019.
//  Copyright © 2019 Grinevich Sergey. All rights reserved.
//

import UIKit
import Firebase

class AddWeaponVC: UIViewController {
    
    var mainCellId = "mainCellId"
    var compoundCellId = "compoundCellId"
    
    var choiceImagePicker: String?
    
    var subjectId : String?
//    var compoundWeaponValueArray = [String]()
//    var compoundWeaponImageArray = [UIImage]()
    
    struct MainWeapon {
        
        var value: String?
        var image: UIImage?
        
    }
    
    var mainWeaporDict = [MainWeapon]()
    
    struct CompoundWeapon {
        
           var value: String?
           var image: UIImage?
      
       }
       
    var compoundWeaporDict = [CompoundWeapon]()
       
    
    fileprivate lazy var weaponImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "add-image.png")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapWeaponImage)))
        return imageView
        
    }()
    
    fileprivate lazy var weaponValueTextField : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Значение"
        return textField
        
    }()
    
    
    
    fileprivate lazy var mainImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "add-image.png")
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapMainImage)))
        return image
    }()
    
    
    fileprivate lazy var mainTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    fileprivate lazy var mainTextField : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Основной предмет"
        return textField
        
    }()
    
    fileprivate lazy var mainAddButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("+", for: .normal)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 6
        button.backgroundColor = UIColor.red.withAlphaComponent(0.6)
        button.tintColor =  UIColor.brown
        button.addTarget(self, action: #selector(tapMainAddButton), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var compoundImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "add-image.png")
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCompoundImage)))
        return image
    }()
    
    
    fileprivate lazy var compoundTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    fileprivate lazy var compoundTextField : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Составной предмет"
        return textField
        
    }()
    
    fileprivate lazy var compoundAddButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("+", for: .normal)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 6
        button.backgroundColor = UIColor.red.withAlphaComponent(0.6)
        button.tintColor =  UIColor.brown
        button.addTarget(self, action: #selector(tapСompoundAddButton), for: .touchUpInside)
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupComponent()
        
 
    }
    
    @objc func addWeapon()  {
        print("add")
        
        if let image = weaponImageView.image {
            self.uploadWeaponImage(selectedImage: image)
            
        }
        
    }
    
    func uploadWeaponImage(selectedImage: UIImage)  {
        
        let imgName = NSUUID().uuidString
        let ref = Storage.storage().reference().child("Weapon").child("WeaponImage").child("\(imgName).jpeg")
        
        if let uploadDate = selectedImage.jpegData(compressionQuality: 0.2) {
            
            ref.putData(uploadDate, metadata: nil) { (metadata, error) in
                
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                
                ref.downloadURL { (url, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                        return
                    }
                    
                    self.sendWeaponImageUrl(imageUrl: (url?.absoluteString)!)
                }
                
                
            }
        }
    }
    
    
    
    func uploadMainWeaponImage(stepsMedia: DatabaseReference) {
        
  
        for (weapor) in  mainWeaporDict {
                let imgName = NSUUID().uuidString
                let childStorageRef = Storage.storage().reference().child("Weapon").child("WeaponMainImage").child("\(imgName).jpeg")
                
            if let uploadData = weapor.image!.jpegData(compressionQuality: 0.2) {
                    
                    childStorageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                        if error != nil {
                            print(error!.localizedDescription)
                            return
                        }
                        
                        childStorageRef.downloadURL { (url, error) in
                            if error != nil {
                                print(error!.localizedDescription)
                                return
                            } else {
                                if let imageUrl = url?.absoluteString {
                                    
                                    let id = stepsMedia.childByAutoId()
                                    let value = ["value": weapor.value!, "imageUrl": imageUrl ]
                                   
                                    id.updateChildValues(value)

                                }
                                
                                
                            }
                            
                        }
                    }
                    
                }
            
        }
        
    }
    
    func uploadCompoundWeaponImage(stepsMedia: DatabaseReference) {
         
         for compound in compoundWeaporDict {
                 let imgName = NSUUID().uuidString
                 let childStorageRef = Storage.storage().reference().child("Weapon").child("WeaponCompoundImage").child("\(imgName).jpeg")
                 
                if let uploadData = compound.image!.jpegData(compressionQuality: 0.2) {
                     
                     childStorageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                         if error != nil {
                             print(error!.localizedDescription)
                             return
                         }
                         
                         childStorageRef.downloadURL { (url, error) in
                             if error != nil {
                                 print(error!.localizedDescription)
                                 return
                             } else {
                                 if let imageUrl = url?.absoluteString {
                                     
                                    let value = ["value": compound.value!, "imageUrl": imageUrl]
                                     let id = stepsMedia.childByAutoId()
                                     id.updateChildValues(value)

                                 }
                                 
                                 
                             }
                             
                         }
                     }
                     
             }
         }
         
     }
    
    
    
    
    
    
    func sendWeaponImageUrl(imageUrl: String)  {
        
        let value: [String: AnyObject] = ["imageUrl": imageUrl as AnyObject]
        
        sendWeaponImage(value: value)
        
    }
    
    func sendWeaponImage(value: [String: AnyObject]) {
        
        let ref = Database.database().reference().child("RaidCalculator").child("Weapon")
        let childRef = ref.childByAutoId()
        let mainWeapor = childRef.child("mainWeapor")
        let compoundWeapon = childRef.child("compoundWeapon")
      
        
        var values: [String: AnyObject] = ["id": childRef.key as AnyObject, "value": weaponValueTextField.text as AnyObject, "subjectId": subjectId as AnyObject]
        
        value.forEach({values[$0] = $1})
        
        childRef.updateChildValues(values) { (error, reference) in
            if error != nil {
                print(error!)
                return
            }
            
        }
        
        self.uploadMainWeaponImage(stepsMedia: mainWeapor)
        self.uploadCompoundWeaponImage(stepsMedia: compoundWeapon)
        
        
    }
    
    
    
    @objc func tapWeaponImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        choiceImagePicker = "WeaponImage"
        present(picker, animated: true, completion: nil)
    }
    
    @objc func tapMainImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        choiceImagePicker = "mainWeaponImage"
        present(picker, animated: true, completion: nil)
    }
    
    @objc func tapCompoundImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        choiceImagePicker = "compoundWeaponImage"
        present(picker, animated: true, completion: nil)
    }
    
    @objc func tapMainAddButton() {
        
//        if let mainWeapon = mainTextField.text {
//            mainWeaponValueArray.append(mainWeapon)
//        }
//
//        if let mainWeaponImage = mainImage.image {
//            mainWeaponImageArray.append(mainWeaponImage)
//        }
        
        mainWeaporDict.append(MainWeapon(value: mainTextField.text, image: mainImage.image))
        
        mainTableView.reloadData()
        
    }
    
    @objc func tapСompoundAddButton() {
        
//
//        if let compoundWeapon = compoundTextField.text {
//            compoundWeaponValueArray.append(compoundWeapon)
//        }
//
//        if let compoundWeaponImage = compoundImage.image {
//            compoundWeaponImageArray.append(compoundWeaponImage)
//        }
//
//        mainWeaporDict[compoundImage.image!] = compoundTextField.text!
//
//        print(mainWeaporDict)
        
        compoundWeaporDict.append(CompoundWeapon(value: compoundTextField.text, image: compoundImage.image))
        
        compoundTableView.reloadData()
        
    }
    
    
    
    
}


extension AddWeaponVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //  return mainWeaponValueArray.count
        return tableView == mainTableView ? mainWeaporDict.count : compoundWeaporDict.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell = UITableViewCell()
        if tableView == mainTableView {
            
            let mainCell = tableView.dequeueReusableCell(withIdentifier: mainCellId, for: indexPath)
            mainCell.imageView?.image = mainWeaporDict[indexPath.row].image
            mainCell.textLabel?.text = mainWeaporDict[indexPath.row].value
            returnCell = mainCell
            
        } else if tableView == compoundTableView {
            
            let compoundCell = tableView.dequeueReusableCell(withIdentifier: compoundCellId, for: indexPath)
            compoundCell.imageView?.image = compoundWeaporDict[indexPath.row].image
            compoundCell.textLabel?.text = compoundWeaporDict[indexPath.row].value
            returnCell = compoundCell
        }
        
        return returnCell
    }
    
    
    
}

extension AddWeaponVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageforPicker : UIImage?
        
        if let editingImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageforPicker = editingImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageforPicker = originalImage
        }
        
        switch choiceImagePicker {
            
        case "mainWeaponImage":
            if let mainImage = selectedImageforPicker {
                self.mainImage.image = mainImage
                
                //  self.uploadWeaponImage(selectedImage: mainImage)
            }
            
        case "WeaponImage":
            
            if let weaponImage = selectedImageforPicker {
                self.weaponImageView.image = weaponImage
                
                //  self.uploadWeaponImage(selectedImage: weaponImage)
            }
        case "compoundWeaponImage":
            
            if let compoundImage = selectedImageforPicker {
                self.compoundImage.image = compoundImage
            }
            
        default:
            break
        }
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
}


extension AddWeaponVC {
    
    fileprivate func setupComponent() {
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(addWeapon))
        
        let containerStack: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let containerMain: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let containerCompound: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        
        view.addSubview(weaponImageView)
        weaponImageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        weaponImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 6).isActive = true
        weaponImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        weaponImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(weaponValueTextField)
       
        weaponValueTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        weaponValueTextField.leftAnchor.constraint(equalTo: weaponImageView.rightAnchor, constant: 5).isActive = true
        weaponValueTextField.centerYAnchor.constraint(equalTo: weaponImageView.centerYAnchor).isActive = true
        
        
        
        view.addSubview(containerStack)
        containerStack.topAnchor.constraint(equalTo: weaponImageView.bottomAnchor, constant: 20).isActive = true
        containerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerStack.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        
        containerStack.addSubview(containerMain)
        containerMain.topAnchor.constraint(equalTo: containerStack.topAnchor).isActive = true
        containerMain.leadingAnchor.constraint(equalTo: containerStack.leadingAnchor).isActive = true
        containerMain.trailingAnchor.constraint(equalTo: containerStack.trailingAnchor).isActive = true
        containerMain.heightAnchor.constraint(equalTo: containerStack.heightAnchor, multiplier: CGFloat(0.5)).isActive = true
        
        //        let stackView = UIStackView(arrangedSubviews: [mainImage, mainImage])
        //        stackView.axis = .horizontal
        //        stackView.distribution = .equalCentering
        //
        //        containerMain.addSubview(stackView)
        //
        //        stackView.translatesAutoresizingMaskIntoConstraints = false
        //        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: containerMain.topAnchor), stackView.leftAnchor.constraint(equalTo: containerMain.leftAnchor), stackView.rightAnchor.constraint(equalTo: containerMain.rightAnchor), stackView.heightAnchor.constraint(equalToConstant: 50)])
        
        containerMain.addSubview(mainImage)
        mainImage.leadingAnchor.constraint(equalTo: containerMain.leadingAnchor).isActive = true
        mainImage.topAnchor.constraint(equalTo: containerMain.topAnchor).isActive = true
        mainImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        mainImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        containerMain.addSubview(mainTextField)
        mainTextField.leftAnchor.constraint(equalTo: mainImage.rightAnchor).isActive = true
        mainTextField.topAnchor.constraint(equalTo: containerMain.topAnchor).isActive = true
        mainTextField.heightAnchor.constraint(equalTo: mainImage.heightAnchor).isActive = true
        mainTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        containerMain.addSubview(mainAddButton)
        
        mainAddButton.leftAnchor.constraint(equalTo: mainTextField.rightAnchor).isActive = true
        mainAddButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        mainAddButton.topAnchor.constraint(equalTo: containerMain.topAnchor).isActive = true
        mainAddButton.heightAnchor.constraint(equalTo: mainTextField.heightAnchor).isActive = true
        
        containerMain.addSubview(mainTableView)
        mainTableView.topAnchor.constraint(equalTo: mainImage.bottomAnchor).isActive = true
        mainTableView.leadingAnchor.constraint(equalTo: containerMain.leadingAnchor).isActive = true
        mainTableView.trailingAnchor.constraint(equalTo: containerMain.trailingAnchor).isActive = true
        mainTableView.bottomAnchor.constraint(equalTo: containerMain.bottomAnchor).isActive = true
        
        mainTableView.tableFooterView = UIView(frame: .zero)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: mainCellId)
        
        
        
        containerStack.addSubview(containerCompound)
        containerCompound.topAnchor.constraint(equalTo: containerMain.bottomAnchor).isActive = true
        containerCompound.leadingAnchor.constraint(equalTo: containerStack.leadingAnchor).isActive = true
        containerCompound.trailingAnchor.constraint(equalTo: containerStack.trailingAnchor).isActive = true
        containerCompound.bottomAnchor.constraint(equalTo: containerStack.bottomAnchor).isActive = true
        
        containerCompound.addSubview(compoundImage)
        compoundImage.leadingAnchor.constraint(equalTo: containerCompound.leadingAnchor).isActive = true
        compoundImage.topAnchor.constraint(equalTo: containerCompound.topAnchor).isActive = true
        compoundImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        compoundImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        containerCompound.addSubview(compoundTextField)
        compoundTextField.leftAnchor.constraint(equalTo: compoundImage.rightAnchor).isActive = true
        compoundTextField.topAnchor.constraint(equalTo: containerCompound.topAnchor).isActive = true
        compoundTextField.heightAnchor.constraint(equalTo: compoundImage.heightAnchor).isActive = true
        compoundTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        containerCompound.addSubview(compoundAddButton)
        
        compoundAddButton.leftAnchor.constraint(equalTo: compoundTextField.rightAnchor).isActive = true
        compoundAddButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        compoundAddButton.topAnchor.constraint(equalTo: containerCompound.topAnchor).isActive = true
        compoundAddButton.heightAnchor.constraint(equalTo: compoundTextField.heightAnchor).isActive = true
        
        containerCompound.addSubview(compoundTableView)
        compoundTableView.topAnchor.constraint(equalTo: compoundImage.bottomAnchor).isActive = true
        compoundTableView.leadingAnchor.constraint(equalTo: containerCompound.leadingAnchor).isActive = true
        compoundTableView.trailingAnchor.constraint(equalTo: containerCompound.trailingAnchor).isActive = true
        compoundTableView.bottomAnchor.constraint(equalTo: containerCompound.bottomAnchor).isActive = true
        
        compoundTableView.tableFooterView = UIView(frame: .zero)
        compoundTableView.delegate = self
        compoundTableView.dataSource = self
        compoundTableView.register(UITableViewCell.self, forCellReuseIdentifier: compoundCellId)
        
        
        
    }
    
    
    
    
}
