import UIKit

extension UICollectionViewCell {
    func performCellAnimation() {
        let startPoint = randomPoint()
        transform = CGAffineTransform(translationX: startPoint.x, y: startPoint.y)
        alpha = 0
        
        UIView.animate(withDuration: Constants.cellAnimationDuration,
                       delay: Constants.cellAnimationDelay,
                       usingSpringWithDamping: Constants.cellAnimationDamping,
                       initialSpringVelocity: Constants.cellAnimationVelocity,
                       options: .curveEaseInOut,
                       animations: { [weak self] _ in
                        self?.transform = CGAffineTransform.identity
                        self?.alpha = 1
        })
    }
    
    private func randomPoint() -> CGPoint {
        let bounds = UIScreen.main.bounds
        let screenWidth = UInt32(bounds.width)
        let screenHeight = UInt32(bounds.height)
        
        let randomY = arc4random_uniform(screenHeight) + UInt32(Constants.boundsDeviation)
        
        if randomY >= screenHeight {
            let randomX = arc4random_uniform(screenWidth)
            return CGPoint(x: CGFloat(randomX), y: CGFloat(randomY))
        }
        
        let randomX = arc4random_uniform(2) == 1 ? Int32(screenWidth) + Constants.boundsDeviation : -Constants.boundsDeviation
        return CGPoint(x: CGFloat(randomX), y: CGFloat(randomY))
    }
}
