//
//  ViewController.swift
//  MenuSlideTop
//
//  Created by Kai on 7/21/17.
//  Copyright © 2017 vinova. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MenuSlideTopViewDelegate {
    
    @IBOutlet weak var menu: MenuSlideTopView!

    let cvMenuViewController: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.clear
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        
        return cv
    }()
    
    var listItem = ["Phim Hanh Dong", "Phim Kiem Hiep", "Phim Tam Ly Tinh Cam", "Phim Le","Phim Thuyet Minh" , "Phim 18+", "Phim Hai Huoc", "Phim For Kid"]
    
    
    let cellId = "UICollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(cvMenuViewController)
        cvMenuViewController.anchor(menu.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        var listCategory = [STCategory]()
        for item in listItem {
            listCategory.append(STCategory(title: item, isSelected: false))
        }
        listCategory[0].isSelected = true
        
        
        
        //---
        menu.listItem = listCategory
        menu.delegate = self
        
        configureCollection()
    }
    
    
    func itemMenuSelected(index: Int) {
       let indexPath = IndexPath(item: index, section: 0)
        cvMenuViewController.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    
}

//MARK: handle Collection view
extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func configureCollection(){
        cvMenuViewController.register(MenuSlideTopViewCell.self , forCellWithReuseIdentifier: cellId)
        cvMenuViewController.delegate = self
        cvMenuViewController.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuSlideTopViewCell
        cell.lbTitle.text = "Cell \(indexPath.item)"
        
        if indexPath.item % 2 == 0 {
            cell.backgroundColor = .green
        } else {
            cell.backgroundColor = .gray
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width , height: collectionView.frame.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = Int(targetContentOffset.pointee.x / self.view.frame.width )
        menu.scrollToIndex(index: index)
        
    }
    
    
}
