import UIKit

final class HomeViewController: UIViewController {
    @IBOutlet fileprivate weak var cellsCountLabel: UILabel!
    @IBOutlet fileprivate weak var selectedCellTextLabel: UILabel!
    @IBOutlet fileprivate weak var selectedCellImageView: UIImageView!
    
    var dataSourceArray = [ViewData]()
    
    lazy fileprivate var menuViewController: MenuViewController? = {
        return self.createMenuViewControleer()
    }()
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewData()
    }
    
    //MARK: IBActions
    @IBAction func removeCellButtonPressed(_ sender: UIButton) {
        if dataSourceArray.count <= 1 { return }
        dataSourceArray.removeLast()
        cellsCountLabel.text = "\(dataSourceArray.count)"
    }
    
    @IBAction func addCellButtonPressed(_ sender: UIButton) {
        if dataSourceArray.count >= Constants.maximumNumberOfCells { return }
        addViewData()
    }
    
    @IBAction func showMenuButtonPressed(_ sender: UIButton) {
        guard let viewController = menuViewController else { return }
        viewController.dataSourceArray = dataSourceArray
        present(viewController, animated: true, completion: nil)
    }
    
    //MARK: Methods
    private func addViewData() {
        let cellName = Constants.cellsNamesArray[dataSourceArray.count]
        let viewData = ViewData(number: Constants.cellsNamesArray.count, text: cellName, imageName: cellName)
        dataSourceArray.append(viewData)
        cellsCountLabel.text = "\(dataSourceArray.count)"
    }
    
    private func createMenuViewControleer() -> MenuViewController {
        let controller = MenuViewController()
        controller.dataSourceArray = dataSourceArray
        controller.cellTextColor = .darkGray
        controller.backgroundImage = UIImage(named: "Background")
        
        controller.complitionHandler = { [weak self] viewData in
            self?.selectedCellTextLabel.text = viewData.text
            
            if let unwrappedImageName = viewData.imageName {
                self?.selectedCellImageView.image = UIImage(named: unwrappedImageName)
            } else if let unwrappedImageURLName = viewData.imageURLString {
                guard let placeholderName = viewData.imagePlaceholderName else {
                    let url = URL(string: unwrappedImageURLName)
                    self?.selectedCellImageView.sd_setImage(with: url)
                    return
                }
                let placeholder = UIImage(named: placeholderName)
                let url = URL(string: unwrappedImageURLName)
                self?.selectedCellImageView.sd_setImage(with: url, placeholderImage: placeholder)
            }
        }
        return controller
    }
}
