//
//  RaidCalculatorVC.swift
//  HelpForRust
//
//  Created by Сергей Гриневич on 15/12/2019.
//  Copyright © 2019 Grinevich Sergey. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import AlamofireImage


class RaidCalculatorVC: UIViewController {
    
    var cellId = "cellId"
    var emptyId = "emptyId"
    var cellIdCollectionView = "cellId"
    var subjectImageView = [Subject]()
    var subjectArrayFilter = [Subject]()
    var subjectType = "Двери"
    
    var weaponItems = [WeaponsSubject]()
    var weaponDTOs = [WeaponSubjectDTO]()
    var itemsDtOs = [ItemsWeaponsDTO]()
    var compoundItemsDtOs = [ItemsCompoundDTO]()
    
    var dict = [Int: Compound]()
    var dictFilter = [Int: Compound]()
    var arrayCleaned = [Compound]()
    
    var filteredItemsDtOs = [ItemsWeaponsDTO]()
    var subjectId : String?
    var timer: Timer?
    
    
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        adBannerView.adUnitID = "ca-app-pub-9023638698585769/4959252606"
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        
        return adBannerView
    }()
    
    var interstitial: GADInterstitial!
    var purchaseRustHelpRemoveAds = UserDefaults.standard.bool(forKey: "purchaseRustHelpRemoveAds")
    
    
    
    
    lazy var weaponTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(red: 93/255, green: 95/255, blue: 92/255, alpha: 1.0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
        
    }()
    
    
    lazy var stepperCalc: UIStepper = {
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.autorepeat = true
        stepper.backgroundColor = UIColor(red: 218/255, green: 84/255, blue: 63/255, alpha: 1.0)
        stepper.layer.borderColor = UIColor.white.cgColor
        stepper.layer.borderWidth = 1.0
        stepper.layer.cornerRadius = 10
        stepper.transform = CGAffineTransform(scaleX: 0.9, y: 0.8)
        //stepper.wraps = true
        
        stepper.minimumValue = 1
        stepper.maximumValue = 100
        stepper.value = 1
        stepper.addTarget(self, action: #selector(tapStepper), for: .valueChanged)
        stepper.isHidden = true
        return stepper
        
    }()
    
    lazy var labelStepper: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(Int(stepperCalc.value))
        label.textColor = .white
        label.isHidden = true
        return label
    }()
    
    lazy var subjectCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = UIColor(red: 56/255, green: 54/255, blue: 48/255, alpha: 1.0)
        layout.scrollDirection = .horizontal
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupComponents()
        observeSubjectRaidCalculator()
        observeItemsWeapons()
        observeItemsCompound()
        
        adBannerView.load(GADRequest())
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-9023638698585769/5251204135")
        let request = GADRequest()
        interstitial.load(request)
        
    }
    
    
    func observeWeapon(subject: Int) {
        
        weaponItems.removeAll()
        weaponDTOs.removeAll()
        
        let ref = Database.database().reference().child("RaidCalculator").child("WeaponsSubject").queryOrdered(byChild: "subject_id").queryEqual(toValue: subject)
        //        ref.observeSingleEvent(of:of: .value) { (<#DataSnapshot#>) in
        //            <#code#>
        //        }
        // var _index = UInt(NSNotFound)
        ref.observe( .value, with: { [weak self] (snaphot) in
            guard let self = self else { return }
            
            print(snaphot)
            
            // ref.removeObserver(withHandle: _index)
            
            if let snapDict = snaphot.value as? [String: Any] {
                
                for weapon in snapDict.values {
                    if let weaponDict = weapon as? [String : Any] {
                        let weapon = WeaponsSubject(dictionary: weaponDict)
                        self.weaponItems.append(weapon)
                    }
                }
                
            } else {
                
                if let value = snaphot.value {
                    if let dictionary = value as? [Any] {
                        for weapon in dictionary {
                            if let weaponDict = weapon as? [String : Any] {
                                let weapon = WeaponsSubject(dictionary: weaponDict)
                                self.weaponItems.append(weapon)
                                
                            }
                        }
                        
                    }
                }
            }
            
            
            //            ref?.removeObserver(withHandle: index)
            
            
            self.observeWeaponsSubject()
            
            }, withCancel: nil)
        
        
    }
    
    
    
    func observeWeaponsSubject()  {
        
        self.weaponDTOs.removeAll()

        for weapon in weaponItems {
            let id = weapon.weapons_id.map({ "\($0)" }) ?? ""
            let ref = Database.database().reference().child("RaidCalculator").child("Weapons").child(id)
            var _index = UInt(NSNotFound)
            _index = ref.observe( .value, with: { [weak self] (snapshot) in
                guard let self = self else { return }
                ref.removeObserver(withHandle: _index)
                if let value = snapshot.value {
                    if let dictionary = value as? [String : Any]  {
                        
                        let weapons = Weapons(dictionary: dictionary)
                        
                        self.filteredItems(weapon: weapons, subjectValue: weapon)
                        //
                        //                        print(self.compound.count)
                        //                        print(self.filteredItemsDtOs.count)
                        
                        //self.dict = Set(self.arrayCleaned)
                        
                        let dtoS = WeaponSubjectDTO(weapon: weapons, subject: weapon, items: self.filteredItemsDtOs, dict: self.dict)
                        
                        
                        self.weaponDTOs.append(dtoS)
                        
                        self.weaponDTOs.sort { (lhs: WeaponSubjectDTO, rhs: WeaponSubjectDTO) -> Bool in
                            // you can have additional code here
                            return lhs.weapon.id! < rhs.weapon.id!
                        }
                        
                        DispatchQueue.main.async {
                            self.weaponTableView.reloadData()
                        }
                        
                        
                        
                        //                        for weapon in dictionary {
                        //                            if let weaponDict = weapon.value as? String {
                        ////                                let weapon = Weapons(dictionary: weaponDict)
                        //                                self.weapon.append(weaponDict)
                        //
                        //
                        //                            }
                        //                        }
                        
                    }
                    
                    
                }
                
                }, withCancel: nil)
            
            
            
        }
        
    }
    
    fileprivate func filteredItems(weapon: Weapons, subjectValue: WeaponsSubject) {
        
        
        dict.removeAll()
        
        filteredItemsDtOs = itemsDtOs.filter({ (items) -> Bool in
            return items.weapons.weapons_id == weapon.id
        })
        
        
        for itemsValue in filteredItemsDtOs {
            for compoundValues in compoundItemsDtOs {
                
                if itemsValue.items.id == compoundValues.compound.items_id {
                    
                    let compoundDtos = Compound(imageUrl: compoundValues.items.imageUrl!, valueSum: (compoundValues.compound.value_compound! * Double(itemsValue.weapons.value!) * Double(subjectValue.value!)))
                    
                    dict[compoundValues.items.id!] = compoundDtos
                    
                }
            }
            
        }
        
        
        for dictValues in dict {
            
            for compoundValues in compoundItemsDtOs {
                
                if dictValues.key == compoundValues.compound.items_id {
                    
                    dict[compoundValues.items.id!] = Compound(imageUrl: compoundValues.items.imageUrl!, valueSum: (dictValues.value.valueSum * compoundValues.compound.value_compound!) + (dict[compoundValues.items.id!]?.valueSum ?? 0))
                    
                }
            }
            
        }
        
    }
    
    //    private func uniq<S: Sequence, T: Hashable> (source: S) -> [T] where S.Iterator.Element == T {
    //        var buffer = [T]() // возвращаемый массив
    //        var added = Set<T>() // набор - уникальные значения
    //        for elem in source {
    //            if !added.contains(elem) {
    //                buffer.append(elem)
    //                added.insert(elem)
    //            }
    //        }
    //        return buffer
    //    }
    
    
    
    fileprivate func observeItemsWeapons() {
        
        let refItems = Database.database().reference().child("RaidCalculator").child("ItemsWeapons")
        var _index = UInt(NSNotFound)
        _index = refItems.observe( .value, with: { [weak self] (snapshot) in
            
            
            guard let self = self else { return }
            refItems.removeObserver(withHandle: _index)
            if let value = snapshot.value {
                
                if let dictionary = value as? [Any] {
                    
                    for weaponItems in dictionary {
                        if let weaponItemsDict = weaponItems as? [String: Any] {
                            let weaponItems = ItemsWeapons(dictionary: weaponItemsDict)
                            //self.weaponsItems.append(weaponItems)
                            self.observeItems(weaponItems: weaponItems)
                            // self.observeItemsCompound(items: weaponItems)
                            
                            
                        }
                        
                    }
                    
                }
            }
            
            }, withCancel: nil)
        
        
    }
    
    fileprivate func observeItems(weaponItems: ItemsWeapons) {
        
        itemsDtOs.removeAll()
        
        var _index = UInt(NSNotFound)
        
        let ref = Database.database().reference().child("RaidCalculator").child("Items").child(String(weaponItems.items_id!))
        
        _index = ref.observe( .value, with: { [weak self]  (snapshot) in
            
            //  print(snapshot)
            ref.removeObserver(withHandle: _index)
            guard let self = self else { return }
            
            if let value = snapshot.value {
                if let dictionary = value as? [String: Any] {
                    let items = Items(dictionary: dictionary)
                    
                    let dto = ItemsWeaponsDTO(items: items, weapons: weaponItems)
                    self.itemsDtOs.append(dto)
                    
                    
                }
            }
            
            
            }, withCancel: nil)
        
    }
    
    
    fileprivate func observeItemsCompound() {
        
        var _index = UInt(NSNotFound)
        
        let refItems = Database.database().reference().child("RaidCalculator").child("ItemsCompound")
        
        _index = refItems.observe( .value, with: { [weak self] (snapshot) in
            
            
            guard let self = self else { return }
            
            refItems.removeObserver(withHandle: _index)
            
            if let value = snapshot.value {
                if let dictionary = value as? [Any] {
                    for compound in dictionary {
                        if let compoundDict  = compound as? [String: Any] {
                            let items = ItemsCompound(dictionary: compoundDict)
                            //  self.compound.append(items)
                            self.observeItemsForCompound(compoundItems: items)
                        }
                        
                    }
                }
            }
            
            
            }, withCancel: nil)
        
    }
    
    
    fileprivate func observeItemsForCompound(compoundItems: ItemsCompound) {
        
        itemsDtOs.removeAll()
        var _index = UInt(NSNotFound)
        let ref = Database.database().reference().child("RaidCalculator").child("Items").child(String(compoundItems.items_compound_id!))
        
        _index = ref.observe( .value, with: { [weak self]  (snapshot) in
            
            guard let self = self else { return }
            ref.removeObserver(withHandle: _index)
            if let value = snapshot.value {
                if let dictionary = value as? [String: Any] {
                    let items = Items(dictionary: dictionary)
                    
                    let dto = ItemsCompoundDTO(items: items, compound: compoundItems)
                    self.compoundItemsDtOs.append(dto)
                    
                }
            }
            
            
            }, withCancel: nil)
        
    }
    
    
    
    //    func observeItemsWeapons(id: Int) {
    //
    //        weaponsItems.removeAll()
    //
    //        let refItems = Database.database().reference().child("RaidCalculator").child("ItemsWeapons").queryOrdered(byChild: "weapons_id").queryEqual(toValue: id)
    //
    //        let group = DispatchGroup()
    //        group.enter()
    //
    //        refItems.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
    //
    //            guard let self = self else { return }
    //
    //            if let value = snapshot.value {
    //
    //                if let dictionary = value as? [Any] {
    //                    for weaponItems in dictionary {
    //                        if let weaponItemsDict = weaponItems as? [String: Any] {
    //                            let weaponItems = ItemsWeapons(dictionary: weaponItemsDict)
    //
    //                            self.weaponsItems.append(weaponItems)
    //                            // self.observeItemsMain(itemsWeapons: weaponItems)
    //
    //                        }
    //                    }
    //
    //                }
    //            }
    //
    //            //  self.observeItemsMain()
    //            group.leave()
    //            }, withCancel: nil)
    //
    //        group.notify(queue: DispatchQueue.main) {
    //            print(self.weaponsItems.count)
    //
    //        }
    //
    //
    //    }
    
    
    //     private func weaponItemsArraySorted() {
    //
    //
    //            sortedItems = weaponItemsTest.sorted {
    //                var isSorted = false
    //             if let first = $0.items.id, let second = $1.items.id {
    //                    isSorted = first < second
    //                }
    //                return isSorted
    //            }
    //
    //             self.insideCollectionRaidView.reloadData()
    //
    //        }
    
    
    @objc func tapStepper(_ stepper: UIStepper) {
        labelStepper.text = String(Int(stepper.value))
        //
        //        //let stepperValue = Int(stepper.value)
        //        let indexPath = IndexPath(row: 1, section: 0)
        //        if let cell = weaponTableView.cellForRow(at: indexPath) as? WeaponTableViewCell {
        //            //анрапнуть
        //
        //            cell.valueLabel.text = String(Int(cell.valueLabel.text!)! * 2)
        //            // yourValueArray[index] = stepperValue
        //
        //        }
        
        
        
        reload(tableView: weaponTableView)
        
    }
    
    
    
    func reload(tableView: UITableView) {
        
        DispatchQueue.main.async {
            //let contentOffset = tableView.contentOffset
            self.weaponDTOs.removeAll()
            tableView.reloadData()
            //            tableView.layoutIfNeeded()
            //            tableView.setContentOffset(contentOffset, animated: true)
            //
            //
            
        }
        
        
        
    }
    
    
    @objc func tapSegmentControl(segment: UISegmentedControl) -> Void {
        switch segment.selectedSegmentIndex {
        case 0:
            subjectType = segment.titleForSegment(at: segment.selectedSegmentIndex)!
            subjectArrayFiltering(type: subjectType)
            weaponItems.removeAll()
            weaponDTOs.removeAll()
            //            subjectCollectionView.reloadData()
            reload(tableView: weaponTableView)
        case 1:
            subjectType = segment.titleForSegment(at: segment.selectedSegmentIndex)!
            subjectArrayFiltering(type: subjectType)
            weaponItems.removeAll()
            weaponDTOs.removeAll()
            //             subjectCollectionView.reloadData()
            reload(tableView: weaponTableView)
        case 2:
            subjectType = segment.titleForSegment(at: segment.selectedSegmentIndex)!
            subjectArrayFiltering(type: subjectType)
            weaponItems.removeAll()
            weaponDTOs.removeAll()
            //             subjectCollectionView.reloadData()
            reload(tableView: weaponTableView)
            
            
        case 3:
            subjectType = segment.titleForSegment(at: segment.selectedSegmentIndex)!
            subjectArrayFiltering(type: subjectType)
            weaponItems.removeAll()
            weaponDTOs.removeAll()
            //             subjectCollectionView.reloadData()
            reload(tableView: weaponTableView)
        default:
            break
        }
        
    }
    
    @objc func addSublectsItems() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    @objc func addWeaponVC() {
        let addWeapon = AddWeaponVC()
        
        addWeapon.subjectId = subjectId
        
        navigationController?.pushViewController(addWeapon, animated: true)
    }
    
    
    private func addSubjectImageToFirebaseStorage(selectedImage : UIImage) {
        
        let imgName = NSUUID().uuidString
        let ref = Storage.storage().reference().child("RaidCalculator").child("Subject").child("\(imgName).jpeg")
        
        if let uploadData = selectedImage.jpegData(compressionQuality: 0.2) {
            ref.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print(error!.localizedDescription)
                }
                
                ref.downloadURL { (url, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                    }
                    
                    self.sendRaidCalculatorSubjectImageUrl(imageUrl: (url?.absoluteString)!)
                }
                
                
            }
        }
        
    }
    
    
    private func sendRaidCalculatorSubjectImageUrl(imageUrl: String)  {
        
        let value: [String: AnyObject] = ["imageUrl": imageUrl as AnyObject]
        
        sendRaidCalculatorItemsToFirebase(value: value)
        
    }
    
    
    private func sendRaidCalculatorItemsToFirebase(value : [String: AnyObject]) {
        
        let ref = Database.database().reference().child("RaidCalculator").child("Subject")
        let childRef = ref.childByAutoId()
        
        var values = ["id": childRef.key, "type": subjectType] as [String : AnyObject]
        
        value.forEach({values[$0] = $1})
        
        childRef.updateChildValues(values) { (error, ref) in
            
            if error != nil {
                print(error!)
                return
            }
            
            
        }
    }
    
    private func observeSubjectRaidCalculator() {
        
        var _index = UInt(NSNotFound)
        
        let ref = Database.database().reference().child("RaidCalculator").child("Subject")
        
        _index = ref.observe( .value , with: { [weak self] (snapshot) in
            
            ref.removeObserver(withHandle: _index)
            
            guard let self = self else { return }
            // print(snapshot)
            
            //            let array = snapshot.value
            //                .flatMap({ $0 as? [String: Any] })?
            //                .values
            //                .compactMap({ $0 as? [String: Any] })
            //                .map({ Subject(dictionary: $0) })
            ////                .filter({ $0.type == self.subjectType })
            //            self.subjectImageView = array ?? []
            //            self.subjectCollectionView.reloadData()
            //                .flatMap({ $0.values })
            //                .flatMap({ $0 as? [String: Any] })
            //                .
            if let value = snapshot.value {
                if let dictionary = value as? [Any] {
                    for item in dictionary {
                        if let subDict = item as? [String : Any] {
                            let subject = Subject(dictionary: subDict)
                            self.subjectImageView.append(subject)
                        }
                    }
                    
                }
            }
            
            self.subjectArrayFiltering(type: self.subjectType)
            
            
            }, withCancel: nil)
        
    }
    
    private func subjectArrayFiltering(type: String) {
        
        subjectArrayFilter = subjectImageView
            .filter({ (subject) -> Bool in
                return subject.type == type
            })
            .sorted(by: { $0.id ?? 0 < $1.id ?? 0  })
        
        
        self.subjectCollectionView.reloadData()
        
        
    }
    
    //    private func weaponItemsFiltering(subject_id: Int) {
    //
    //        weaponItemsFilter = weaponItems.filter({ (weapon_id) -> Bool in
    //            return weapon_id.subject_id == subject_id
    //        })
    //
    //
    //
    //       reload(tableView: weaponTableView)
    //
    //    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addWeapon = segue.destination as! AddWeaponVC
        addWeapon.subjectId = subjectId
    }
    
    //
    //    override var preferredStatusBarStyle: UIStatusBarStyle {
    //        return .lightContent
    //    }
}


//MARK: raidSubjectsTableView

extension RaidCalculatorVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return adBannerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return adBannerView.frame.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var returnValue = Int()
        
        if weaponDTOs.count == 0 {
            returnValue = 1
        } else if weaponDTOs.count > 0 {
            returnValue = weaponDTOs.count
        }
        
        return returnValue
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var returnSize = CGFloat()
        
        if weaponDTOs.count == 0 {
            returnSize = 45
        } else if weaponDTOs.count > 0 {
            returnSize = 160
        }
        
        return returnSize
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        if weaponDTOs.count > 0 {
            let cellWeapor = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WeaponTableViewCell
            
            //   weaponItemsFilter.insert(Weapon(dictionary: [:]), at: Int(arc4random_uniform(UInt32(weaponItemsFilter.count))))
            
            cellWeapor.weaponItemsTest = weaponDTOs[indexPath.row].items
            cellWeapor.compound = weaponDTOs[indexPath.row].compound
            
            let url = URL(string: weaponDTOs[indexPath.row].weapon.imageUrl!)
            
            cellWeapor.raidImageView.af.cancelImageRequest()
            cellWeapor.raidImageView.af.setImage(withURL: url!, cacheKey: weaponDTOs[indexPath.row].weapon.imageUrl!)
            
            cellWeapor.stepperValue = stepperCalc.value
            
            if let value = weaponDTOs[indexPath.row].subject.value {
                cellWeapor.valueLabel.text = String(Int(value) * Int(stepperCalc.value))
                
            }
            
            
            //  cellWeapor.insideCollectionRaidView.reloadData()
            
            cell = cellWeapor
            
        } else if weaponDTOs.count == 0 {
            let emptyCell = tableView.dequeueReusableCell(withIdentifier: emptyId, for: indexPath) as! EmptyTableViewCell
            cell = emptyCell
        } 
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //отступ ячеек
        let verticalPadding: CGFloat = 5
        
        let maskLayer = CALayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding / 2)
        cell.layer.mask = maskLayer
        
        
    }
    
    
}


//MARK: raidSubjectsCollectionView

extension RaidCalculatorVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subjectArrayFilter.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 100.0, height: self.subjectCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdCollectionView, for: indexPath) as! SubjectCollectionViewCell
        
        //cell.subjectImageView.image = UIImage(named: subjectImageView[indexPath.row])
        cell.subjectArray = subjectArrayFilter[indexPath.row]
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return (collectionView.indexPathsForSelectedItems?.count ?? 0) < subjectArrayFilter.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        stepperCalc.isHidden = false
        stepperCalc.value = 1
        labelStepper.text = String(Int(stepperCalc.value))
        labelStepper.isHidden = false
        
        weaponDTOs.removeAll()
    
        weaponTableView.reloadData()
        
        if let id = subjectArrayFilter[indexPath.row].id {
            //weaponItemsFiltering(subject_id: id)
           //
                weaponItems.removeAll()
            observeWeapon(subject: id)
        }
      
        
       // reload(tableView: weaponTableView)
        
        
        if !purchaseRustHelpRemoveAds {
            if interstitial.isReady {
                interstitial = createAndLoadInterstitial()
                
            }
        }
    }
    
    
}

extension RaidCalculatorVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageForPicker: UIImage?
        
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageForPicker = originalImage
        } else if let editingImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageForPicker = editingImage
        }
        
        if let image = selectedImageForPicker {
            self.addSubjectImageToFirebaseStorage(selectedImage: image)
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension RaidCalculatorVC: GADBannerViewDelegate, GADInterstitialDelegate {
    
    // MARK: - GADBannerViewDelegate methods
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
        
        // Reposition the banner ad to create a slide down effect
        let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height)
        bannerView.transform = translateTransform
        
        UIView.animate(withDuration: 0.5) {
            bannerView.transform = CGAffineTransform.identity
        }
        
        
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error.localizedDescription)
        
    }
    
    // MARK: - Help methods
    
    private func createAndLoadInterstitial() -> GADInterstitial? {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-9023638698585769/5251204135")
        
        guard let interstitial = interstitial else {
            return nil
        }
        
        let request = GADRequest()
        //request.testDevices = ["PUT HERE THE ID", kGADSimulatorID]
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers =
            [ "2077ef9a63d2b398840261c8221a0c9b" ]
        
        interstitial.load(request)
        interstitial.delegate = self
        
        return interstitial
    }
    
    // MARK: - GADInterstitialDelegate methods
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("Interstitial loaded successfully")
        ad.present(fromRootViewController: self)
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        print("Fail to receive interstitial")
    }
    
}

extension RaidCalculatorVC {
    
    func setupComponents()  {
        
        navigationItem.title = "Raid Calculator"
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 134/255, green: 149/255, blue: 106/255, alpha: 1.0)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 72/255, green: 71/255, blue: 66/255, alpha: 1.0)
        //add
        //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSublectsItems))
        //  navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWeaponVC))
        
        //MARK: setup  raidSubjectsTableView
        view.addSubview(weaponTableView)
        
        weaponTableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        weaponTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        weaponTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        weaponTableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -180).isActive = true
        
        weaponTableView.delegate = self
        weaponTableView.dataSource = self
        
        weaponTableView.tableFooterView = UIView(frame: .zero)
        
        weaponTableView.register(WeaponTableViewCell.self, forCellReuseIdentifier: cellId)
        weaponTableView.register(EmptyTableViewCell.self, forCellReuseIdentifier: emptyId)
        
        
        //MARK: setup stepper
        let stepperView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = UIColor(red: 218/255, green: 84/255, blue: 63/255, alpha: 1.0)
            return view
            
        }()
        
        view.addSubview(stepperView)
        
        stepperView.topAnchor.constraint(equalTo: weaponTableView.bottomAnchor).isActive = true
        stepperView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stepperView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stepperView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        stepperView.addSubview(stepperCalc)
        
        stepperCalc.centerYAnchor.constraint(equalTo: stepperView.centerYAnchor).isActive = true
        stepperCalc.centerXAnchor.constraint(equalTo: stepperView.centerXAnchor).isActive = true
        //        stepperCalc.topAnchor.constraint(equalTo: stepperView.topAnchor, constant: 2).isActive = true
        //        stepperCalc.bottomAnchor.constraint(equalTo: stepperView.bottomAnchor, constant: -2).isActive = true
        //
        stepperView.addSubview(labelStepper)
        labelStepper.leftAnchor.constraint(equalTo: stepperCalc.rightAnchor, constant: 10).isActive = true
        labelStepper.centerYAnchor.constraint(equalTo: stepperView.centerYAnchor).isActive = true
        labelStepper.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        //MARK: setup raidSubjectsCollectionView
        
        view.addSubview(subjectCollectionView)
        subjectCollectionView.topAnchor.constraint(equalTo: stepperView.bottomAnchor).isActive = true
        subjectCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        subjectCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        // subjectCollectionView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        
        
        subjectCollectionView.delegate = self
        subjectCollectionView.dataSource = self
        
        subjectCollectionView.register(SubjectCollectionViewCell.self, forCellWithReuseIdentifier: cellIdCollectionView)
        
        //MARK: setup segmentControll
        let segmentView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor =  UIColor(red: 57/255, green: 55/255, blue: 51/255, alpha: 1.0)
            return view
            
        }()
        
        view.addSubview(segmentView)
        segmentView.topAnchor.constraint(equalTo: subjectCollectionView.bottomAnchor).isActive = true
        segmentView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        segmentView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        segmentView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        segmentView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        
        // let items = ["Двери", "Стены", "Окна", "Другое"]
        let items = [NSLocalizedString("Doors", comment: ""), NSLocalizedString("Walls", comment: ""), NSLocalizedString("Windows", comment: ""), NSLocalizedString("Other", comment: "")]
        
        let segmentControl = UISegmentedControl(items: items)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.backgroundColor =  UIColor(red: 57/255, green: 55/255, blue: 51/255, alpha: 1.0)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.addTarget(self, action: #selector(tapSegmentControl), for: .valueChanged)
        
        segmentView.addSubview(segmentControl)
        segmentControl.centerYAnchor.constraint(equalTo: segmentView.centerYAnchor).isActive = true
        segmentControl.centerXAnchor.constraint(equalTo: segmentView.centerXAnchor).isActive = true
        segmentControl.trailingAnchor.constraint(equalTo: segmentView.trailingAnchor).isActive = true
        segmentControl.leadingAnchor.constraint(equalTo: segmentView.leadingAnchor).isActive = true
        
    }
    
}

//extension Array
// {
//    func uniqueValues<V:Equatable>( value:(Element)->V) -> [Element]
//    {
//        var result:[Element] = []
//        for element in self
//        {
//            if !result.contains(where: { value($0) == value(element) })
//            {
//                result.append(element)
//
//            }
//        }
//        return result
//    }
//
//}
