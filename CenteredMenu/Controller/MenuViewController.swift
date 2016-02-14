//
//  MenuViewController.swift
//  ODCenteredMenu
//
//  Created by Alex on 1/16/16.
//  Copyright © 2016 Alex. All rights reserved.
//

import UIKit

final class MenuViewController: UIViewController {
    let CellsMinimumInteritemSpacing: CGFloat = 8
    let DefaultCellInset: CGFloat = 5
    let NumberOfItemsInRow = 4
    let CellHeight: CGFloat = 74
    
    let TapTransition: CGFloat = 0.8
    let UnTapTransition: CGFloat = 1.3
    let TapAnimationDuration = 0.3
    
    var dataSourceArray: [InfoObject] = []
    var showAnimation: Bool = true
    var backgroundImage: UIImage?
    var cellTextColor: UIColor?
    var complitionHandler: ((infoObject: InfoObject) -> ())?
    
    private var collectionView: UICollectionView?
    private var cellWidth: CGFloat = 0
    private var firstTimeShow = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createCollectionView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        if firstTimeShow == true {
            firstTimeShow = false
            return
        }
        
        showAnimation = true
        collectionView?.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        showAnimation = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let insertWidth = CGRectGetWidth(collectionView!.bounds) - (DefaultCellInset * 2)
        let summuryCellsWidth = insertWidth - CellsMinimumInteritemSpacing * (CGFloat(NumberOfItemsInRow) - 1)
        cellWidth = summuryCellsWidth / CGFloat(NumberOfItemsInRow)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func dismissMenuViewController() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

//UI update
private extension MenuViewController {
    func createCollectionView() {
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = CellsMinimumInteritemSpacing
        collectionView = UICollectionView.init(frame: UIScreen.mainScreen().bounds, collectionViewLayout: layout)
        
        self.view.addSubview(collectionView!)
        let viewsDictionary = ["view" : collectionView!]
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: [], metrics: nil, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: [], metrics: nil, views: viewsDictionary))
        
        collectionView?.registerNib(MenuCollectionViewCell.nib, forCellWithReuseIdentifier: MenuCollectionViewCell.reuseIdentifier)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        
        let backgroundView = UIImageView.init(frame: (collectionView?.bounds)!)
        backgroundView.userInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer.init(target: self, action: Selector("dismissMenuViewController"))
        backgroundView.addGestureRecognizer(tapGesture)
        collectionView?.backgroundView = backgroundView
        
        guard let image = backgroundImage else {
            backgroundView.backgroundColor = .whiteColor()
            return
        }
        backgroundView.image = image
    }
}

extension MenuViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSourceArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MenuCollectionViewCell.reuseIdentifier, forIndexPath: indexPath) as? MenuCollectionViewCell else {
            return MenuCollectionViewCell()
        }
        cell.infoObject = dataSourceArray[indexPath.item]
        
        if showAnimation {
            cell.performCellAnimation()
        }
        
        return cell
    }
}

extension MenuViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? MenuCollectionViewCell else {
            return false
        }
        
        UIView.animateWithDuration(TapAnimationDuration) { _ in
            cell.transform = CGAffineTransformMakeScale(self.TapTransition, self.TapTransition)
        }
        
        return true
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? MenuCollectionViewCell else {
            return
        }
        
        UIView.animateWithDuration(TapAnimationDuration) { _ in
            cell.transform = CGAffineTransformIdentity
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? MenuCollectionViewCell else {
            return
        }
       
        UIView.animateWithDuration(TapAnimationDuration, animations: { _ in
            cell.transform = CGAffineTransformMakeScale(self.TapTransition, self.TapTransition)
            }) { (Bool) -> () in
                UIView.animateWithDuration(self.TapAnimationDuration, animations: { _ in
                    cell.transform = CGAffineTransformIdentity
                    }, completion: { (Bool) -> () in
                        self.performSelector("dismissMenuViewController", withObject: nil, afterDelay: self.TapAnimationDuration)
                        guard let complition = self.complitionHandler else {
                            return
                        }
                        complition(infoObject: self.dataSourceArray[indexPath.item])
                })
        }
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? MenuCollectionViewCell else {
            return
        }
        
        UIView.animateWithDuration(TapAnimationDuration) { _ in
            cell.transform = CGAffineTransformIdentity
        }
    }
}

extension MenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(cellWidth, CellHeight)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let numberOfItems = collectionView.numberOfItemsInSection(0)
        let numberOfFullRows = numberOfItems / NumberOfItemsInRow
        let rowsCount = numberOfItems % NumberOfItemsInRow != 0 ? numberOfFullRows + 1 : numberOfFullRows
        let totalHeight = CGFloat(rowsCount) * CellHeight + CGFloat(rowsCount - 1) * CellsMinimumInteritemSpacing
        let topInset = (CGRectGetHeight(collectionView.bounds) - totalHeight) / 2
        let finalTopInset = topInset > DefaultCellInset ? topInset : DefaultCellInset
        
        return UIEdgeInsetsMake(finalTopInset, DefaultCellInset, 0, DefaultCellInset)
    }
}