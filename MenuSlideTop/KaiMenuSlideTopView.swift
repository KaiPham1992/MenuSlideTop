//
//  KaiMenuSlideTopView.swift
//  MenuSlideTop
//
//  Created by Kai on 7/21/17.
//  Copyright © 2017 vinova. All rights reserved.
//

import UIKit

protocol MenuSlideTopViewDelegate: class  {
    func itemMenuSelected(index: Int)
}

class MenuSlideTopView: UIView {
    let cvMenu: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.clear
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.red
        
        return cv
    }()
    
    let vHorizotal: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    let cellId = "MenuSlideTopViewCell"
    
    var listItem = [AnyObject]() {
        didSet{
            cvMenu.reloadData()
        }
    }
    
    let colorSelected = UIColor.blue
    let colorNormal = UIColor.yellow
    
    var delegate: MenuSlideTopViewDelegate?
    
    func setUpView(){
        addSubview(cvMenu)
        cvMenu.fillSuperview()
        cvMenu.addSubview(vHorizotal)
        
        //---
        configureCollection()
    }
}
//MARK: handle Collection view
extension MenuSlideTopView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func configureCollection(){
        cvMenu.register(MenuSlideTopViewCell.self , forCellWithReuseIdentifier: cellId)
        cvMenu.delegate = self
        cvMenu.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return listItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuSlideTopViewCell
        cell.item = listItem[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let itemStr = listItem[indexPath.item] as? STCategory {
            let wid = estimateWidth(customFont: UIFont.boldSystemFont(ofSize: 15), str: itemStr.title) + 20
            if indexPath.item == 0 && vHorizotal.frame.width == 0 {
                vHorizotal.frame = CGRect(x: 0, y: cvMenu.frame.height - 10 , width: wid, height: 10)
            }
            
            return CGSize(width: wid, height: collectionView.frame.height)
        }
        
        return CGSize(width: 0, height: 0)
    }
    
     func estimateWidth(customFont: UIFont, str: String) -> CGFloat {
        let size = CGSize(width: 1000, height: customFont.lineHeight)
        let option = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
        let estimateFrame = NSString(string: str).boundingRect(with: size, options: option, attributes: [NSFontAttributeName: customFont], context: nil)
        
        return estimateFrame.width
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        scrollToIndex(index: indexPath.item)
        delegate?.itemMenuSelected(index: indexPath.item)
    }
    
    func scrollToIndex(index: Int) {
        //get cell selected
        let indexPath = IndexPath(item: index, section: 0)
        guard let cellScroll = cvMenu.cellForItem(at: indexPath) as? MenuSlideTopViewCell else { return }
      
        
        UIView.animate(withDuration: 0.5) {
            //-- scroll view horizontal
            self.vHorizotal.frame = CGRect(x: self.vHorizotal.frame.minX, y: self.vHorizotal.frame.minY, width: cellScroll.frame.width, height: self.vHorizotal.frame.height)
            self.vHorizotal.center.x = cellScroll.center.x
            
            //-- scroll collction view
            self.cvMenu.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            //-- set color nomal for all item in screen
            //-- indexPathsForVisibleItems get indexPath all item in screen
            let listIndexPathVisible = self.cvMenu.indexPathsForVisibleItems
            for indexPath in listIndexPathVisible {
                if let cell = self.cvMenu.cellForItem(at: indexPath) as? MenuSlideTopViewCell {
                    cell.lbTitle.textColor = self.colorNormal
                }
            }
            
            //-- set color selected for current cell
            cellScroll.lbTitle.textColor = self.colorSelected
            
            //--
            guard let listCategory = self.listItem as? [STCategory] else { return }
            for i in 0...listCategory.count - 1 {
                listCategory[i].isSelected = false
            }
            listCategory[index].isSelected = true
        }
    }
    
    
    
}

//MARK: MenuSlideTopViewCell

class MenuSlideTopViewCell: UICollectionViewCell {
    let lbTitle: UILabel = {
        let lb = UILabel()
        lb.text = "Title Category"
        lb.textColor = UIColor.white
        lb.font =  UIFont.boldSystemFont(ofSize: 15)
        lb.textAlignment = .center
        
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    //set value for cell menu , when have a category
    
    var item: AnyObject?{
        didSet{
            if let cate = item as? STCategory {
                lbTitle.text = cate.title
                lbTitle.textColor = cate.isSelected == true ? UIColor.blue : UIColor.yellow
            }
        }
    }
    
    
    func setUpView(){
        addSubview(lbTitle)
        lbTitle.fillSuperview()
    }
}

class STCategory {
    var title: String = ""
    var isSelected: Bool = false
    
    init(title: String, isSelected: Bool) {
        self.title = title
        self.isSelected = isSelected
    }
}

