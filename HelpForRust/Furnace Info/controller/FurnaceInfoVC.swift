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
    
    var customView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupComponents()
        observeFurnace()
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-9023638698585769/5251204135")
        let request = GADRequest()
        interstitial.load(request)
        
        timerShowAd()
      
    }
    
  
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        purchaseRustHelpRemoveAds = UserDefaults.standard.bool(forKey: "purchaseRustHelpRemoveAds")
        
    }
    
    fileprivate func timerShowAd() {
        
        
        
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
        
        var _index = UInt(NSNotFound)
        
        let ref = Database.database().reference().child("FurnaceInfo")
        _index = ref.observe( .value, with: {  [weak self] (snapshot) in
            
            guard let self = self else { return }
            ref.removeObserver(withHandle: _index)
        
            self.furnaceInfoArray.removeAll()
            if let snapDict = snapshot.value as? [String: Any] {
                for furnace in snapDict.values {
                    if let furnaceDict = furnace as? [String: Any] {
                        let myFurnace = Furnace(dictionary: furnaceDict)
                        self.furnaceInfoArray.append(myFurnace)
                    }
                }
            } else {
                if let value = snapshot.value {
                    if let dictionary = value as? [Any] {
                        for furnace in dictionary {
                            if let furnaceDict = furnace as? [String : Any] {
                                let myFurnace = Furnace(dictionary: furnaceDict)
                                self.furnaceInfoArray.append(myFurnace)
                                
                            }
                        }
                        
                    }
                }
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
        }).sorted(by: {
            var sorted = false
            if let first = $0.id, let second = $1.id {
                sorted = first < second
            }
            return sorted
        })
        
        
        DispatchQueue.main.async {
            //
            //            UIView.transition(with: self.tableView, duration: 1.0, options: .transitionCrossDissolve, animations: {
            //
            //
            //            }, completion: nil)
            self.tableView.reloadData()
            guard self.furnaceFiltered.count != 0 else { return }
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            
            self.customView.removeFromSuperview()
        }
        
        //        observeFurnace()
        
    }
    
    @objc func tapSegmentControl(segment: UISegmentedControl) -> Void {
        switch segment.selectedSegmentIndex {
        case 0:
            typeFurnace = "iron"
            if TestConnectionNetwork.isConnectedNetwork() {
                sortFurnaceInfo(type: typeFurnace)
                customView.removeFromSuperview()
            } else {
                furnaceFiltered.removeAll()
                tableView.reloadData()
                tapReloadNotInternetConnection()
            }
        case 1:
            typeFurnace = "sulfur"
            if TestConnectionNetwork.isConnectedNetwork() {
                sortFurnaceInfo(type: typeFurnace)
                customView.removeFromSuperview()
            } else {
                furnaceFiltered.removeAll()
                tableView.reloadData()
                tapReloadNotInternetConnection()
            }
        case 2:
            typeFurnace = "MVK"
            if TestConnectionNetwork.isConnectedNetwork() {
                sortFurnaceInfo(type: typeFurnace)
                customView.removeFromSuperview()
            } else {
                furnaceFiltered.removeAll()
                tableView.reloadData()
                tapReloadNotInternetConnection()
            }
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
        //let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentImagePickerController))
        // navigationItem.rightBarButtonItem = addButton
        
        let items = [NSLocalizedString("iron", comment: ""), NSLocalizedString("sulfur", comment: ""), NSLocalizedString("MVK", comment: "")]
        
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
        tableView.tableFooterView = segmentView
        //tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(FurnaceInfoTableViewCell.self, forCellReuseIdentifier: cellID)
        
        tapReloadNotInternetConnection()
        
    }
    

    func tapReloadNotInternetConnection()  {
        
        if !TestConnectionNetwork.isConnectedNetwork() {
            
            customView.translatesAutoresizingMaskIntoConstraints = false
            customView.backgroundColor = .clear     //give color to the view
          
            self.view.addSubview(customView)
            customView.widthAnchor.constraint(equalToConstant: 50).isActive = true
            customView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            customView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor).isActive = true
            customView.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor).isActive = true
            
            
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(UIImage(named: "update"), for: .normal)
            button.addTarget(self, action: #selector(ifNotInternetConnection), for: .touchUpInside)
            button.startAnimatingPressActions()
            
            customView.addSubview(button)
            
            button.topAnchor.constraint(equalTo: customView.topAnchor).isActive = true
            button.widthAnchor.constraint(equalToConstant: 30).isActive = true
            button.heightAnchor.constraint(equalToConstant: 30).isActive = true
            button.centerXAnchor.constraint(equalTo: customView.centerXAnchor).isActive = true
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.text = NSLocalizedString("No internet connection", comment: "")
            label.font = UIFont(name: "Roboto-Regular", size: 12)
            customView.addSubview(label)
            
            label.topAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
            label.centerXAnchor.constraint(equalTo: customView.centerXAnchor).isActive = true
        }
    }
    
    @objc func ifNotInternetConnection() {
        // print("reload")
        observeFurnace()
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
