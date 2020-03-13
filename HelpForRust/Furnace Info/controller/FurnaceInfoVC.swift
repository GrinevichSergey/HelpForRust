//
//  FurnaceInfoVC.swift
//  HelpForRust
//
//  Created by Сергей Гриневич on 14/12/2019.
//  Copyright © 2019 Grinevich Sergey. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

class FurnaceInfoVC: UITableViewController {
    
    let cellID = "cellId"
    var furnaceImage : UIImage?
    var typeFurnace = "iron"
    var furnaceInfoArray = [Furnace]()
    var furnaceFiltered = [Furnace]()
    
    var purchaseRustHelpRemoveAds = UserDefaults.standard.bool(forKey: "purchaseRustHelpRemoveAds")
    var interstitial: GADInterstitial!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupComponents()
        observeFurnace()
        
        timerShowAd()
        
       
    }
    
    fileprivate func timerShowAd() {
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-9023638698585769/5251204135")
        let request = GADRequest()
        interstitial.load(request)
        
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (_) in
                if !self.purchaseRustHelpRemoveAds {
                    if self.interstitial.isReady {
                        self.interstitial.present(fromRootViewController: self)
                    }
                }
            }
        } else {
            Timer.scheduledTimer(timeInterval: 2,
                                 target: self,
                                 selector: #selector(self.showAds),
                                 userInfo: nil,
                                 repeats: true)
        }
    }
    
    
    @objc func showAds() {
        if !self.purchaseRustHelpRemoveAds {
            if self.interstitial.isReady {
                self.interstitial.present(fromRootViewController: self)
            }
        }
    }
    
    
    
    @objc func presentImagePickerController() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    
    func addFurnaceInfoImageToFirebaseStorage(selectedImage: UIImage)  {
        
        let imgName = NSUUID().uuidString
        let ref = Storage.storage().reference().child("FurnaceInfo").child("\(imgName).jpeg")
        
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
                    
                   // print("Image URL: \((url?.absoluteString)!)")
                    self.sendFurnaceImageUrl(imageUrl: (url?.absoluteString)!)
                }
                
            }
        }
        
    }
    
    func sendFurnaceImageUrl(imageUrl: String)  {
        
        let value: [String: AnyObject] = ["imageUrl": imageUrl as AnyObject]
        
        sendFurnaceImage(value: value)
        
    }
    
    func sendFurnaceImage(value: [String: AnyObject]) {
        
        let ref = Database.database().reference().child("FurnaceInfo")
        let childRef = ref.childByAutoId()
        
        var values: [String: AnyObject] = ["id": childRef.key as AnyObject, "type": typeFurnace as AnyObject]
        
        value.forEach({values[$0] = $1})
        
        childRef.updateChildValues(values) { (error, reference) in
            if error != nil {
                print(error!)
                return
            }
            
            
        }
        
    }
    
    func observeFurnace()  {
        
        let ref = Database.database().reference().child("FurnaceInfo")
        ref.observe(.childAdded, with: { (snapshot) in
            
            if let dic = snapshot.value as? [String: AnyObject] {
                let myFurnace = Furnace(dictionary: dic)
                
                self.furnaceInfoArray.append(myFurnace)
      
            }
            self.sortFurnaceInfo(type: self.typeFurnace)
         
        }, withCancel: nil)
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return furnaceFiltered.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! FurnaceInfoTableViewCell
        
        cell.furnaceInfoArray = furnaceFiltered[indexPath.row]
        
        return cell
    }
    
    func sortFurnaceInfo(type: String) {

//        furnaceFiltered = furnaceInfoArray.filter({ $0.type!.lowercased().contains(type) })
        //фильтрация массива в зависимости от типа
        furnaceFiltered = furnaceInfoArray.filter({ (furnace) -> Bool in
            return furnace.type == type
        })
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
//        observeFurnace()
        
    }
    
    @objc func tapSegmentControl(segment: UISegmentedControl) -> Void {
        switch segment.selectedSegmentIndex {
        case 0:
            typeFurnace = "iron"
            sortFurnaceInfo(type: typeFurnace)
        case 1:
            typeFurnace = "sulfur"
            sortFurnaceInfo(type: typeFurnace)
        case 2:
            typeFurnace = "MVK"
            sortFurnaceInfo(type: typeFurnace)
        default:
            break
        }
        
    }
    
    func setupComponents()  {
   
        navigationItem.title = "Furnace Info"
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 134/255, green: 149/255, blue: 106/255, alpha: 1.0)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 72/255, green: 71/255, blue: 66/255, alpha: 1.0)
        
        view.backgroundColor = UIColor(red: 93/255, green: 95/255, blue: 92/255, alpha: 1.0)
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentImagePickerController))
        navigationItem.rightBarButtonItem = addButton
        
        let items = ["Железо", "Сера", "МВК"]
        
        let segmentControll = UISegmentedControl(items: items)
        segmentControll.selectedSegmentIndex = 0
        segmentControll.backgroundColor = UIColor(red: 57/255, green: 55/255, blue: 51/255, alpha: 1.0)
        
        segmentControll.translatesAutoresizingMaskIntoConstraints = false
        segmentControll.addTarget(self, action: #selector(tapSegmentControl), for: .valueChanged)
        
        //MARK: setup segmentControll
        let segmentView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor =  UIColor(red: 57/255, green: 55/255, blue: 51/255, alpha: 1.0)
            return view
            
        }()
        
        view.addSubview(segmentView)
        segmentView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        segmentView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        segmentView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        segmentView.heightAnchor.constraint(equalToConstant: 35).isActive = true
    
        segmentView.addSubview(segmentControll)
        segmentControll.centerYAnchor.constraint(equalTo: segmentView.centerYAnchor).isActive = true
        segmentControll.centerXAnchor.constraint(equalTo: segmentView.centerXAnchor).isActive = true
        segmentControll.trailingAnchor.constraint(equalTo: segmentView.trailingAnchor).isActive = true
        segmentControll.leadingAnchor.constraint(equalTo: segmentView.leadingAnchor).isActive = true
        
        //tableView.tableHeaderView = segmentControll
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(FurnaceInfoTableViewCell.self, forCellReuseIdentifier: cellID)
      
               
    }
  

}

extension FurnaceInfoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageForPicket: UIImage?
        
        if let editingImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageForPicket = editingImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageForPicket = originalImage
        }
        
        if let furnaceImage = selectedImageForPicket {
            self.addFurnaceInfoImageToFirebaseStorage(selectedImage: furnaceImage)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
