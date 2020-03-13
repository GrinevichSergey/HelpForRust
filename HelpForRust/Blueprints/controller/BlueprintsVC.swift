//
//  BlueprintsVC.swift
//  HelpForRust
//
//  Created by Сергей Гриневич on 03/02/2020.
//  Copyright © 2020 Grinevich Sergey. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds



class BlueprintsVC: UIViewController, UIGestureRecognizerDelegate {
    
    var filtAmmoGroup = [AmmoGroup]()
    var ammoGroup = [AmmoGroup]()
    var sortedAmmoGroup = [AmmoGroup]()
    var timer: Timer?
    var numbersItemCells: [String] = []
    var levelTag = 0
    var valueLevel_ = "Level_1"
    
    
    fileprivate let padding : CGFloat = 5
    let adBanner = "bannerCell"
    
    var interstitial: GADInterstitial!
    var purchaseRustHelpRemoveAds = UserDefaults.standard.bool(forKey: "purchaseRustHelpRemoveAds")
    
    var defaults = UserDefaults.standard
    var myarray = [String: [String]]()
    var valueColor = [String]()
    //    var value2 = [String]()
    //    var value3 = [String]()
    
    var isSelected = Bool()
    var longPressed = false
    var refreshControll = UIRefreshControl()
    
    
    override func viewWillAppear(_ animated: Bool) {

     //  interstitial = createAndLoadInterstitial()
    
        setupView()
        
       
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-9023638698585769/5251204135")
        
        let request = GADRequest()
        interstitial.load(request)
        
        // myarray = defaults.stringArray(forKey: "SavedStringArray") ?? [String]()
        
        myarray = defaults.object(forKey: "SavedStringArray") as? [String: [String]] ?? [String: [String]]()
        
        observeExercisesGroup(valueLevel: valueLevel_)
        
        setupCollectionViewLayot()
        
        adBannerView.load(GADRequest())
        
        print(myarray)
        
    }
    
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        adBannerView.adUnitID = "ca-app-pub-9023638698585769/4959252606"
       // adBannerView.delegate = self
        adBannerView.rootViewController = self
        
        return adBannerView
    }()
    
    
    lazy var seg_control: UISegmentedControl = {
        let items_segCtrl = ["Level 1", "Level 2", "Level 3"]
        var seg_ctrl = UISegmentedControl(items: items_segCtrl)
        seg_ctrl.layer.cornerRadius = 5.0
        seg_ctrl.selectedSegmentIndex = 0
        seg_ctrl.backgroundColor = UIColor(red: 57/255, green: 55/255, blue: 51/255, alpha: 1.0)
        seg_ctrl.tintColor = UIColor.white
        seg_ctrl.addTarget(self, action: #selector(segmentAction), for: .valueChanged)
        seg_ctrl.translatesAutoresizingMaskIntoConstraints = false
        return seg_ctrl
    }()
    
    lazy var nameBlueprintsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let nameBlueprintsLabel = NSLocalizedString("Click on the blueprint", comment: "")
        label.text = nameBlueprintsLabel
        label.textColor = .white
        label.font = UIFont(name: "Roboto-Regular", size: 16)
        return label
    }()
    
    
    lazy var label_Value2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Roboto-Regular", size: 14)
        
        label.textColor = .white
        return label
    }()
    
    
    lazy var label_Value1: UILabel = {
        var label_v1 = UILabel()
        label_v1.textAlignment = NSTextAlignment.center
        label_v1.text = "Value 1"
        label_v1.textColor = .black
        label_v1.translatesAutoresizingMaskIntoConstraints = false
        return label_v1
    }()
    
    
    
    lazy var dischargeBtn : UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor =  UIColor(red: 57/255, green: 55/255, blue: 51/255, alpha: 1.0)
        let dischargeBtnText = NSLocalizedString("Clear", comment: "")
        btn.setTitle(dischargeBtnText, for: .normal)
        btn.titleLabel?.textColor = .white
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 5
        
        btn.addTarget(self, action: #selector(dischargeBtnSender), for: .touchUpInside)
        return btn
        
        
    }()
    
    fileprivate lazy var chanceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont(name: "Roboto-Regular", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    fileprivate func setupCollectionViewLayot() {
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            
            layout.sectionInset = .init(top: padding, left: padding, bottom: padding, right: padding)
            //  layout.minimumLineSpacing = 50
            
        }
    }
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let vc = UICollectionView(frame: .zero, collectionViewLayout: layout)
        vc.translatesAutoresizingMaskIntoConstraints = false
        vc.register(BlueprintsCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        vc.register(headerBannerReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "bannerCell")
        
        return vc
    }()
    
    
    fileprivate let panelControl: UIView = {
        let pC = UIView(frame: .zero)
        pC.translatesAutoresizingMaskIntoConstraints = false
        return pC
    }()
    
    
    func observeExercisesGroup(valueLevel: String) {
        //
        ammoGroup.removeAll()
        
        let ref = Database.database().reference().child("Blueprints").child("Level").child(valueLevel)
        ref.observe( .value, with: { [weak self] (snapshot) in
            
            guard let self = self else { return }
            
            if let value = snapshot.value {
                
                if let dictionary = value as? [String: Any] {
                    for blueprints in dictionary {
                        if let blueDict = blueprints.value as? [String: Any] {
                            let myAmmoGroup = AmmoGroup(dictionary: blueDict)
                            self.ammoGroup.append(myAmmoGroup)
                        }
                    }
                    
                }
            }
        
        
            //обновление
         
           // self.attempReloadofCollection()
   
          
            
            self.bluePrintsArraySorted()
           
            
        }, withCancel: nil)
        
        
        
    }
    
    private func bluePrintsArraySorted() {
        
        
        sortedAmmoGroup = ammoGroup.sorted {
            var isSorted = false
            if let first = $0.id, let second = $1.id {
                isSorted = first < second
            }
            return isSorted
        }
        
        
         self.collectionView.reloadData()
         self.chanceObserver(lavel: self.valueLevel_)
       // self.attempReloadofCollection()
        
        
    }
    
    //длительное нажатие collectionview
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        
        //        numbersItemCells.removeAll()
        
        if gestureReconizer.state != UIGestureRecognizer.State.ended {
            
            return
        }
        let p = gestureReconizer.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: p)
        if let index = indexPath {
            let cell = collectionView.cellForItem(at: index) as! BlueprintsCollectionViewCell
            
            
            
            label_Value2.text = cell.value
            
            let color = cell.contentView.backgroundColor
            
            if color == .red {
                
                cell.contentView.backgroundColor = .clear
                cell.bg.alpha = 1.0
                
                if let index = myarray[valueLevel_]?.firstIndex(of: cell.id) {
                    myarray[valueLevel_]?.remove(at: index)
                }
                
    
                let defaults = UserDefaults.standard
                defaults.set(myarray, forKey: "SavedStringArray")
                chanceObserver(lavel: valueLevel_)
                
                 print("delete")
                
            } else {
                
                cell.contentView.backgroundColor = .red
                cell.bg.alpha = 0.75
                
                valueColor = myarray[valueLevel_] ?? []
                
                valueColor.append(cell.id)
                
                myarray[valueLevel_] = valueColor
                
                //   myarray[valueLevel_]?.append(cell.id)
                
                let defaults = UserDefaults.standard
                defaults.set(myarray, forKey: "SavedStringArray")
                
                chanceObserver(lavel: valueLevel_)
                
                print("completed")
            }
            
            print(myarray)
            
            
        } else {
            print("Could not find index path")
        }
        
    }
    
    @objc func segmentAction(_ segmentedControl: UISegmentedControl) {
        switch (segmentedControl.selectedSegmentIndex) {
            
            
        case 0:
            
            valueLevel_ = "Level_1"
            observeExercisesGroup(valueLevel: valueLevel_)
           // collectionView.reloadData()
          
        case 1:
            
            valueLevel_ = "Level_2"
            observeExercisesGroup(valueLevel: valueLevel_)
           //  collectionView.reloadData()
 
        case 2:
            
            valueLevel_ = "Level_3"
            observeExercisesGroup(valueLevel: valueLevel_)
          //   collectionView.reloadData()
            
        default:
            
            break
        }
    }
    
    fileprivate func chanceObserver(lavel : String) {
        
        let totalCount = sortedAmmoGroup.count
        var value = Float()
        var studiedCount = myarray[lavel]?.count ?? 0
        //  print(totalCount)
        // print(studiedCount)
        studiedCount -= 1
        value = (1 / (Float(totalCount) - Float(studiedCount))) * 100
        let result = String(format: "%.2f", value)
        let chanceLabelText = NSLocalizedString("Chance - ", comment: "")
        
        switch lavel {
            
        case "Level_1":

            chanceLabel.text = "\(chanceLabelText) \(result)%"
            
        case "Level_2":
          
            chanceLabel.text = "\(chanceLabelText) \(result)%"
            
        case "Level_3":

            chanceLabel.text = "\(chanceLabelText) \(result)%"
            
        default:
            break
        }

    }
    
    
    //обновление по свайпу вверх
    @objc func reloadCollectionView(sender: UIRefreshControl ) {
        
        if sortedAmmoGroup.count > 0 {
            self.observeExercisesGroup(valueLevel: self.valueLevel_)
            sender.endRefreshing()
        } else {
            sender.endRefreshing()
        }
        
        
        if TestConnectionNetwork.isConnectedNetwork() == true {
            adBannerView.load(GADRequest())
        }
        
      
        
    }
    
    
    //сброс изученных
    @objc func dischargeBtnSender() {
        
        let alert = UIAlertController(title: NSLocalizedString("Attention", comment: "attention1") /*"Внимание!"*/, message: NSLocalizedString("Clear the list of learned blueprints?", comment: "clear the list of learned blueprints?") /*"Очистить список изученных чертежей?"*/, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.cancel)  { (_) in
            
            self.myarray.removeValue(forKey: self.valueLevel_)
            let defaults = UserDefaults.standard
            defaults.set(self.myarray, forKey: "SavedStringArray")
            
            //self.resetDefaults()
            self.observeExercisesGroup(valueLevel: self.valueLevel_)
            
            
            print("clear")
            
        }
        let noAction = UIAlertAction(title: "No", style: UIAlertAction.Style.default) { (_) in
            alert.dismiss(animated: false, completion: nil)
            print("dismiss")
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    //обновление
    private func attempReloadofCollection() {
        self.timer?.invalidate()
        //0.1
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector:  #selector(self.handlerReloadTable), userInfo: nil, repeats: false)
    }
    
    @objc func handlerReloadTable(){
        
        DispatchQueue.main.async {
            
            self.collectionView.reloadData()
            self.chanceObserver(lavel: self.valueLevel_)
        }
        
    }
    
    
    
    @objc func infoNavBarTap() {
        
        let alert = UIAlertController(title: NSLocalizedString("Attention", comment: "attention2") /*"Внимание!"*/, message: NSLocalizedString("A short click on the blueprint will show you the information. Long press - add the blueprint as learned.", comment: "short click blablabla"), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) { (_) in
            alert.dismiss(animated: false, completion: nil
            )
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func addBlueprints() {
        
        let addBlueprints = AddBlueprintsVC()
        addBlueprints.lavel = valueLevel_
        navigationController?.pushViewController(addBlueprints, animated: true)
    }
    
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: "SavedStringArray")
            myarray.removeAll()
        }
    }
    
    
    
}

//MARK: collection view
extension BlueprintsVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: adBanner, for: indexPath)
        
        headerView.addSubview(adBannerView)
        adBannerView.translatesAutoresizingMaskIntoConstraints = false
        adBannerView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        adBannerView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        
        return headerView
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return .init(width: view.frame.width, height: 50)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 65, height: 65)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

              return sortedAmmoGroup.count

      
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //  print(self.ammoGroup.count)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BlueprintsCollectionViewCell
        
        cell.contentView.backgroundColor = .clear
        
        cell.valueLevelPublic = valueLevel_
        
        cell.bg.image = UIImage(named: "test.png")
        
        //выбрасывает
     
        cell.furnaceInfoArray = sortedAmmoGroup[indexPath.row]
        
        if let colorValue = myarray[valueLevel_] {
            for i in colorValue {
                if i == sortedAmmoGroup[indexPath.row].id {
            
                    cell.contentView.backgroundColor = .red
                    cell.bg.alpha = 0.75
                
                }
                
            }
        }
        
        
        
        return cell
        
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)  {
        
        if let name = sortedAmmoGroup[indexPath.row].name
        {
            nameBlueprintsLabel.text = name
        }
        
        if  let value = sortedAmmoGroup[indexPath.row].Value_1 {
            label_Value2.text = "x\(value)"
        }
        
        if !purchaseRustHelpRemoveAds {
            
            if interstitial.isReady {
                interstitial.present(fromRootViewController: self)

            }
        }

        
        
        
        
    }
    
    
    
    
    
}

extension UIBarButtonItem {
    
    static func menuButton(_ target: Any?, action: Selector, imageName: String) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        
        button.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        return menuBarItem
    }
}

//MARK : Banner
extension BlueprintsVC: GADBannerViewDelegate, GADInterstitialDelegate {

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
//        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers =
//            [ "2077ef9a63d2b398840261c8221a0c9b" ]

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


//setup ui
extension BlueprintsVC {
    
    func setupView(){
        
        navigationItem.title = "Blueprints"
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 134/255, green: 149/255, blue: 106/255, alpha: 1.0)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.barTintColor = UIColor(red: 72/255, green: 71/255, blue: 66/255, alpha: 1.0)
        
       // navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBlueprints))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(infoNavBarTap), imageName: "info")
        
        
        view.addSubview(collectionView)
        
        view.addSubview(panelControl)
        
        panelControl.backgroundColor =  UIColor(red: 72/255, green: 71/255, blue: 66/255, alpha: 1.0)
        
        panelControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        panelControl.heightAnchor.constraint(equalToConstant: 120).isActive = true
        panelControl.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        panelControl.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        panelControl.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        
        
        collectionView.backgroundColor = UIColor(red: 56/255, green: 54/255, blue: 49/255, alpha: 1.0)
        
        
        collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: panelControl.topAnchor).isActive = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //long press collectionView
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        
        self.collectionView.addGestureRecognizer(lpgr)
        
        
        panelControl.addSubview(nameBlueprintsLabel)
        nameBlueprintsLabel.topAnchor.constraint(equalTo: panelControl.topAnchor, constant: 5).isActive = true
        nameBlueprintsLabel.centerXAnchor.constraint(equalTo: panelControl.centerXAnchor).isActive = true
        
        let view1 : UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(red: 72/255, green: 71/255, blue: 66/255, alpha: 1.0)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let image1: UIImageView = {
            let image = UIImageView()
            //image.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
            image.translatesAutoresizingMaskIntoConstraints = false
            image.image = UIImage(named: "workbench1")
            
            return image
            
        }()
        
        let label_Value1: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "Roboto-Regular", size: 14)
            label.text = "x75"
            label.textColor = .white
            return label
        }()
        
        let view2 : UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(red: 72/255, green: 71/255, blue: 66/255, alpha: 1.0)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let image2: UIImageView = {
            let image = UIImageView()
            //image.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
            image.translatesAutoresizingMaskIntoConstraints = false
            image.image = UIImage(named: "research.table")
            return image
            
        }()
        
        
        panelControl.addSubview(view1)
        panelControl.addSubview(view2)
        
        view1.topAnchor.constraint(equalTo: nameBlueprintsLabel.bottomAnchor, constant: 2).isActive = true
        view1.leftAnchor.constraint(equalTo: panelControl.leftAnchor).isActive = true
        view1.widthAnchor.constraint(equalTo: panelControl.widthAnchor, multiplier: CGFloat(0.5)).isActive = true
        view1.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        view1.addSubview(image1)
        image1.centerYAnchor.constraint(equalTo: view1.centerYAnchor).isActive = true
        image1.centerXAnchor.constraint(equalTo: view1.centerXAnchor).isActive = true
        image1.heightAnchor.constraint(equalToConstant: 20).isActive = true
        image1.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        view1.addSubview(label_Value1)
        label_Value1.leftAnchor.constraint(equalTo: image1.rightAnchor, constant: 3).isActive = true
        label_Value1.centerYAnchor.constraint(equalTo: image1.centerYAnchor).isActive = true
        label_Value1.rightAnchor.constraint(equalTo: view1.rightAnchor).isActive = true
        // label1.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        view2.addSubview(image2)
        image2.centerYAnchor.constraint(equalTo: view2.centerYAnchor).isActive = true
        //??
        image2.centerXAnchor.constraint(equalTo: view2.centerXAnchor, constant: -25).isActive = true
        image2.heightAnchor.constraint(equalToConstant: 20).isActive = true
        image2.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        view2.topAnchor.constraint(equalTo: nameBlueprintsLabel.bottomAnchor, constant: 2).isActive = true
        view2.rightAnchor.constraint(equalTo: panelControl.rightAnchor).isActive = true
        view2.widthAnchor.constraint(equalTo: panelControl.widthAnchor, multiplier: CGFloat(0.5)).isActive = true
        view2.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        view2.addSubview(label_Value2)
        label_Value2.leftAnchor.constraint(equalTo: image2.rightAnchor, constant: 3).isActive = true
        label_Value2.centerYAnchor.constraint(equalTo: image2.centerYAnchor).isActive = true
        label_Value2.rightAnchor.constraint(equalTo: view2.rightAnchor).isActive = true
        
        panelControl.addSubview(dischargeBtn)
        dischargeBtn.centerXAnchor.constraint(equalTo: panelControl.centerXAnchor).isActive = true
        dischargeBtn.topAnchor.constraint(equalTo: view1.bottomAnchor, constant: 3).isActive = true
        dischargeBtn.heightAnchor.constraint(equalToConstant: 25).isActive = true
        dischargeBtn.widthAnchor.constraint(equalToConstant: 115).isActive = true
        
        
        panelControl.addSubview(chanceLabel)
        chanceLabel.leftAnchor.constraint(equalTo: dischargeBtn.rightAnchor, constant: 20).isActive = true
        chanceLabel.centerYAnchor.constraint(equalTo: dischargeBtn.centerYAnchor).isActive = true
        
        
        
        panelControl.addSubview(seg_control)
        // seg_control.topAnchor.constraint(equalTo: panelControl.topAnchor, constant: 75).isActive = true
        seg_control.leadingAnchor.constraint(equalTo: panelControl.leadingAnchor).isActive = true
        seg_control.trailingAnchor.constraint(equalTo: panelControl.trailingAnchor).isActive = true
        seg_control.bottomAnchor.constraint(equalTo: panelControl.bottomAnchor).isActive = true
        
        
        
        
        //refresh
        refreshControll.addTarget(self, action: #selector(reloadCollectionView), for: .valueChanged)
        collectionView.refreshControl = refreshControll
        
       
    }
    
    
}