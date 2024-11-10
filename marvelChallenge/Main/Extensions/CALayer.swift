
import UIKit

extension CALayer {
    
    func setBorder() {
        self.borderWidth = 1
        self.borderColor = UIColor.lightGray.cgColor
        self.cornerRadius = 5
        self.masksToBounds = true
    }
}
