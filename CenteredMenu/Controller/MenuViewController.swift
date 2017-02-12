import UIKit

final class MenuViewController: UIViewController {
    var dataSourceArray = [ViewData]()
    var shouldShowAnimation = true
    var backgroundImage: UIImage?
    var cellTextColor: UIColor?
    var complitionHandler: ((_ viewData: ViewData) -> ())?
    
    fileprivate var collectionView: UICollectionView!
    fileprivate var cellWidth: CGFloat = 0
    fileprivate var isFirstAppearance = true
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isFirstAppearance {
            isFirstAppearance = false
            return
        }
        
        shouldShowAnimation = true
        collectionView?.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shouldShowAnimation = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let width = collectionView?.bounds.width else { return }
        let insertWidth = width - (Constants.defaultCellInset * 2)
        let summuryCellsWidth = insertWidth - Constants.cellsMinimumInteritemSpacing * (CGFloat(Constants.numberOfItemsInRow) - 1)
        cellWidth = summuryCellsWidth / CGFloat(Constants.numberOfItemsInRow)
    }

    //MARK: UI update
    private func createCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing =  Constants.cellsMinimumInteritemSpacing
        collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        view.addSubview(collectionView)
        let viewsDictionary = ["view" : collectionView]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: viewsDictionary))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: viewsDictionary))
        
        collectionView.register(MenuCollectionViewCell.nib, forCellWithReuseIdentifier: MenuCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let backgroundView = UIImageView(frame: collectionView.bounds)
        backgroundView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissAnimated))
        backgroundView.addGestureRecognizer(tapGesture)
        collectionView.backgroundView = backgroundView
        
        guard let image = backgroundImage else {
            backgroundView.backgroundColor = .white
            return
        }
        backgroundView.image = image
    }

    func dismissAnimated() {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: UICollectionViewDataSource
extension MenuViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSourceArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.identifier, for: indexPath) as? MenuCollectionViewCell else {
            return MenuCollectionViewCell()
        }
        cell.viewData = dataSourceArray[indexPath.item]
        
        if shouldShowAnimation {
            cell.performCellAnimation()
        }
        
        return cell
    }
}

//MARK: UICollectionViewDelegate
extension MenuViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MenuCollectionViewCell else { return false }
        
        UIView.animate(withDuration: Constants.tapAnimationDuration, animations: { _ in
            cell.transform = CGAffineTransform(scaleX: Constants.highlightScaleFactor, y: Constants.highlightScaleFactor)
        }) 
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MenuCollectionViewCell else { return }
        
        UIView.animate(withDuration: Constants.tapAnimationDuration, animations: { _ in
            cell.transform = CGAffineTransform.identity
        }) 
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MenuCollectionViewCell else { return }
       
        UIView.animate(withDuration: Constants.tapAnimationDuration, animations: { _ in
            cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { (Bool) -> () in
            UIView.animate(withDuration: Constants.tapAnimationDuration, animations: { _ in
                cell.transform = CGAffineTransform.identity
            }, completion: { [weak self] (Bool) -> () in
                self?.perform(#selector(self?.dismissAnimated), with: nil, afterDelay: Constants.tapAnimationDuration)
                guard let complition = self?.complitionHandler, let dataSourceArray = self?.dataSourceArray else { return }
                complition(dataSourceArray[indexPath.item])
            })
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MenuCollectionViewCell else { return }
        
        UIView.animate(withDuration: Constants.tapAnimationDuration, animations: { _ in
            cell.transform = CGAffineTransform.identity
        }) 
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension MenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height:  Constants.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        let numberOfFullRows = numberOfItems / Constants.numberOfItemsInRow
        let rowsCount = numberOfItems %  Constants.numberOfItemsInRow != 0 ? numberOfFullRows + 1 : numberOfFullRows
        let totalHeight = CGFloat(rowsCount) * Constants.cellHeight + CGFloat(rowsCount - 1) * Constants.cellsMinimumInteritemSpacing
        let topInset = (collectionView.bounds.height - totalHeight) / 2
        let finalTopInset = topInset > Constants.defaultCellInset ? topInset : Constants.defaultCellInset
        
        return UIEdgeInsetsMake(finalTopInset, Constants.defaultCellInset, 0, Constants.defaultCellInset)
    }
}
