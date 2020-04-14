//
//  AddBlueprintsVC.swift
//  HelpForRust
//
//  Created by Сергей Гриневич on 04/02/2020.
//  Copyright © 2020 Grinevich Sergey. All rights reserved.
//


import UIKit
import Firebase

class AddBlueprintsVC: UIViewController {
    
    var proverka: Int?
    var lavel = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
    }
    
    lazy var btnLevel1 : UIButton = {
        let btnLvl1 = UIButton()
        btnLvl1.setTitle("Add", for: .normal)
        btnLvl1.addTarget(self, action: #selector(tappedBtnLevel1),  for: .touchUpInside)
        btnLvl1.translatesAutoresizingMaskIntoConstraints = false
        return btnLvl1
    }()
    
    @objc func tappedBtnLevel1() {
        //            print("Work it")
        //        let ref = Database.database().reference().child("Blueprints").child("Level").child("Level_2")
        //        let childRef = ref.childByAutoId()
        //        let values = ["uid": childRef.key as AnyObject, "value1": value1.text as AnyObject]
        //        childRef.updateChildValues(values)
        
        let imageArray = ["\(NSUUID())": imagePicture.image]
        let ref =  Database.database().reference().child("Blueprints").child("Level").child(lavel)
        let childRef = ref.childByAutoId()
        for (key, image) in imageArray {
            let childStorageRef = Storage.storage().reference().child("Images_Level2").child("\(key).png")
            if let uploadData = image!.pngData() {
                childStorageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                        return
                    }
                    childStorageRef.downloadURL { (url, error) in
                        if error != nil {
                            print("Failed to download url:", error!)
                            return
                        } else {
                            if let imageValueUrl = url?.absoluteString {
                                
                                
                                let values = ["uid": childRef.key as AnyObject, "value_1": self.value1.text as AnyObject, "imageURL": imageValueUrl as AnyObject, "name": self.valueName.text as AnyObject]
                                
                                
                                childRef.updateChildValues(values)
      
                            }
                            
                        }
                        
                    }
                }
            }
            
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    lazy var valueName : UITextField = {
        let textValue1 = UITextField()
        textValue1.translatesAutoresizingMaskIntoConstraints = false
        textValue1.placeholder = "Введите наименование предмета"
        return textValue1
    }()
    
    lazy var value1 : UITextField = {
        let textValue1 = UITextField()
        textValue1.translatesAutoresizingMaskIntoConstraints = false
        textValue1.placeholder = "Введите первое значение"
        return textValue1
    }()
    
    lazy var value2 : UITextField = {
        let textValue2 = UITextField()
        textValue2.translatesAutoresizingMaskIntoConstraints = false
        textValue2.placeholder = "Введите второе значение"
        return textValue2
    }()
    
    lazy var imagePicture: UIImageView = {
        var imgPicture = UIImageView()
        imgPicture.image = UIImage(named: "Blueprints_image")
        imgPicture.translatesAutoresizingMaskIntoConstraints = false
        imgPicture.contentMode = .scaleAspectFit
        imgPicture.clipsToBounds = true
        imgPicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedImage)))
        imgPicture.isUserInteractionEnabled = true
        imgPicture.sizeToFit()
        return imgPicture
    }()
    
    
    func setupView(){
        view.addSubview(btnLevel1)
        btnLevel1.backgroundColor = .green
        if #available(iOS 11.0, *) {
            btnLevel1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            // Fallback on earlier versions
        }
        btnLevel1.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        btnLevel1.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        btnLevel1.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(valueName)
        valueName.topAnchor.constraint(equalTo: btnLevel1.bottomAnchor, constant: 15).isActive = true
        valueName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        valueName.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        valueName.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        view.addSubview(value1)
        value1.topAnchor.constraint(equalTo: valueName.bottomAnchor, constant: 15).isActive = true
        value1.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        value1.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        value1.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        view.addSubview(value2)
        value2.topAnchor.constraint(equalTo: value1.bottomAnchor, constant: 15).isActive = true
        value2.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        value2.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        value2.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        view.addSubview(imagePicture)
        imagePicture.topAnchor.constraint(equalTo: value2.bottomAnchor, constant: 15).isActive = true
        imagePicture.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        imagePicture.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        imagePicture.heightAnchor.constraint(equalToConstant:200).isActive = true
    }
    
}

extension AddBlueprintsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func tappedImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageForPicker: UIImage?
        
        if let editingImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageForPicker = editingImage
            
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageForPicker = originalImage
        }
        
        if let selectedImage = selectedImageForPicker {
            self.imagePicture.image = selectedImage
        }
        
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
}
