//
//  raidSubjectsTableViewCell.swift
//  HelpForRust
//
//  Created by Сергей Гриневич on 16/12/2019.
//  Copyright © 2019 Grinevich Sergey. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage
import Alamofire

class WeaponTableViewCell: UITableViewCell {
    
//    var weaponDtos: WeaponSubjectDTO? {
//        didSet {
//            //observeItemsWeapons()
//        }
//    }
//
    
    
    var section = [NSLocalizedString("Basic items", comment: ""), NSLocalizedString("Compound items", comment: "")]
    
    fileprivate let headerId = "headerId"
    fileprivate let cellMainId = "cellMainId"
    fileprivate let cellCompoundId = "cellCompoundId"
    
    public var weapon_id = Int()
    
    override func prepareForReuse() {
        self.raidImageView.image = nil
    }
    
    var weaponItemsTest = [ItemsWeaponsDTO]()
    var sortedItems = [ItemsWeaponsDTO]()
    var itemsCompound  = [ItemsCompoundDTO]()
    var weaponsItems = [ItemsWeapons]()
    var stepperValue = Double()
    var ImageCache = [String:UIImage]()

    
    lazy var containerInsideView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        return view
    }()
    
    lazy var insideCollectionRaidView: UICollectionView = {
        let layot = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layot)
        layot.scrollDirection = .vertical
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor =  UIColor(red: 68/255, green: 67/255, blue: 63/255, alpha: 1.0)
        return collectionView
    }()
    
    //    var mainTextLabel : UILabel = {
    //        var label = UILabel()
    //        label.translatesAutoresizingMaskIntoConstraints = false
    //        label.text = "Основные предметы"
    //        label.textAlignment = .center
    //        return label
    //    }()
    //
    
    var raidImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor(red: 137/255, green: 148/255, blue: 110/255, alpha: 1.0)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
        
    }()
    
    
    let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "Roboto-Bold", size: 16)
        return label
        
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        // backgroundColor = UIColor(red: 68/255, green: 67/255, blue: 63/255, alpha: 1.0)
        //MARK: constraint ImageView
        addSubview(raidImageView)
        
        raidImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        raidImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        raidImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        raidImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        raidImageView.addSubview(valueLabel)
        valueLabel.rightAnchor.constraint(equalTo: raidImageView.rightAnchor, constant: -10).isActive = true
        valueLabel.bottomAnchor.constraint(equalTo: raidImageView.bottomAnchor, constant: -5).isActive = true
        
        
        
        
        //MARK : containerView
        addSubview(containerInsideView)
        containerInsideView.leftAnchor.constraint(equalTo: raidImageView.rightAnchor).isActive = true
        containerInsideView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        containerInsideView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerInsideView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        //MARK: mainLabel
        //        containerInsideView.addSubview(mainTextLabel)
        //
        //        mainTextLabel.topAnchor.constraint(equalTo: containerInsideView.topAnchor).isActive = true
        //        mainTextLabel.leftAnchor.constraint(equalTo: containerInsideView.leftAnchor).isActive = true
        //        mainTextLabel.centerXAnchor.constraint(equalTo: containerInsideView.centerXAnchor).isActive = true
        
        //MARK: Inside CollectionView
        containerInsideView.addSubview(insideCollectionRaidView)
        insideCollectionRaidView.topAnchor.constraint(equalTo: containerInsideView.topAnchor).isActive = true
        insideCollectionRaidView.leftAnchor.constraint(equalTo: containerInsideView.leftAnchor).isActive = true
        insideCollectionRaidView.rightAnchor.constraint(equalTo: containerInsideView.rightAnchor).isActive = true
        insideCollectionRaidView.bottomAnchor.constraint(equalTo: containerInsideView.bottomAnchor).isActive = true
        
        
        insideCollectionRaidView.delegate = self
        insideCollectionRaidView.dataSource = self
        
        insideCollectionRaidView.register(CompoundCollectionViewCell.self, forCellWithReuseIdentifier: cellCompoundId)
        
        insideCollectionRaidView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: cellMainId)
        
        insideCollectionRaidView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

extension WeaponTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout {
    
    //количество разделов
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return section.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var returnValue = Int()
        
        if section == 0 {
            returnValue = weaponItemsTest.count
        } else if section == 1 {
            returnValue = itemsCompound.count
        }
        
        return returnValue
    }
    
    //2 ячейки
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        
        let cellMain = collectionView.dequeueReusableCell(withReuseIdentifier: cellMainId, for: indexPath) as! MainCollectionViewCell
        //
        let cellCompound = collectionView.dequeueReusableCell(withReuseIdentifier: cellCompoundId, for: indexPath) as! CompoundCollectionViewCell
        
        let section = indexPath.section
        
        if section == 0 {
            
        
            let url = URL(string: weaponItemsTest[indexPath.row].items.imageUrl!)
            
            cellMain.mainImageView.af.cancelImageRequest()
            cellMain.mainImageView.af.setImage(withURL: url!, cacheKey: weaponItemsTest[indexPath.row].items.imageUrl!)
            
            if let value = weaponItemsTest[indexPath.row].weapons.value, let valueItems = valueLabel.text {
                cellMain.mainTextLabel.text = String(value * (Int(valueItems) ?? 0))
            }
            
            cell = cellMain
            
        } else if section == 1 {
            
            for itemsValue in weaponItemsTest {
                
                if itemsValue.items.id == itemsCompound[indexPath.row].compound.items_id {
                    if let value = itemsCompound[indexPath.row].compound.value_compound, let valueItems = valueLabel.text  {
                        cellCompound.labelCompound.text = String(value * (itemsValue.weapons.value ?? 0) * (Int(valueItems) ?? 0))
                        
                    }
                }

            }
           
            
            let url = URL(string: itemsCompound[indexPath.row].items.imageUrl!)
            
            cellCompound.compoundImageView.af.cancelImageRequest()
            cellCompound.compoundImageView.af.setImage(withURL: url!, cacheKey: itemsCompound[indexPath.row].items.imageUrl!)
            

            cell = cellCompound
            
        }
        
        return cell
        
    }
    
    
    
    
    
    
    //размер ячеек коллекции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 85.0, height: 25.0)
        
    }
    
    
    //заголовок коллекции
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! HeaderView
        
        header.mainTextLabel.text = section[(indexPath.section)]
        
        return header
        
        
    }
    
    //размер заголовка коллекции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: containerInsideView.frame.width, height: 20)
    }
    
    
}


extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}