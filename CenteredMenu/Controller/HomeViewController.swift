//
//  HomeViewController.swift
//  ODCenteredMenu
//
//  Created by Alex on 1/23/16.
//  Copyright © 2016 Alex. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController {

    let MaximumNumberOfCells = 22
    let cellsNamesArray = ["Alabonneheure", "Bagelstein", "Bicoop", "Biocbon", "Buffalo", "Chipotle", "Clement", "CocciMarket", "Cojean", "Columbus", "Costacoffee", "Elrancho", "ExKi", "FactoryAndCo", "Flunch", "GrandFrais", "Haagendazs", "Hippopotamus", "Huithuit", "Illy", "KFC", "LamieCaline", "Сaissedepargne"]
    
    @IBOutlet private weak var cellsCountLabel: UILabel?
    @IBOutlet private weak var selectedCellTextLabel: UILabel?
    @IBOutlet private weak var selectedCellImageView: UIImageView?
    
    var dataSourceArray : [InfoObject] = []
    lazy private var menuViewController: MenuViewController? = {
        return self.createMenuViewControleer()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addInfoObject()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK: IBActions
private extension HomeViewController {
    @IBAction func removeCellButtonPressed(sender: UIButton) {
        if dataSourceArray.count <= 1 {
            return
        }
        dataSourceArray.removeLast()
        cellsCountLabel?.text = "\(dataSourceArray.count)"
    }
    
    @IBAction func addCellButtonPressed(sender: UIButton) {
        if dataSourceArray.count >= MaximumNumberOfCells {
            return
        }
        addInfoObject()
    }
    
    @IBAction func showMenuButtonPressed(sender: UIButton) {
        guard let viewController = menuViewController else {
            return
        }
        viewController.dataSourceArray = dataSourceArray
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    func addInfoObject() {
        let cellName = cellsNamesArray[dataSourceArray.count]
        let infoObject = InfoObject.init(objectNumber: cellsNamesArray.count, objectText: cellName, objectImageName: cellName)
        dataSourceArray.append(infoObject)
        cellsCountLabel?.text = "\(dataSourceArray.count)"
    }
}

private extension HomeViewController {
    func createMenuViewControleer() -> MenuViewController {
        let menuViewController = MenuViewController.init()
        menuViewController.dataSourceArray = dataSourceArray
        menuViewController.cellTextColor = .darkGrayColor()
        menuViewController.backgroundImage = UIImage.init(named: "Background")
        
        menuViewController.complitionHandler = { infoObject in
            self.selectedCellTextLabel?.text = infoObject.text
            
            if let unwrappedImageName = infoObject.imageName {
                self.selectedCellImageView?.image = UIImage.init(named: unwrappedImageName)
            } else if let unwrappedImageURLName = infoObject.imageURLString {
                if let placeholderName = infoObject.imagePlaceholderName {
                    let placeholder = UIImage.init(named: placeholderName)
                    self.selectedCellImageView?.sd_setImageWithURL(NSURL(string: unwrappedImageURLName), placeholderImage: placeholder)
                    return
                }
                self.selectedCellImageView?.sd_setImageWithURL(NSURL(string:unwrappedImageURLName))
            }
        }
        return menuViewController
    }
}