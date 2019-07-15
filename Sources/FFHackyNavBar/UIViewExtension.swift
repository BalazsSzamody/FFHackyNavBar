import UIKit

extension UIView {
    func getFirst(_ condition: (UIView) -> Bool) -> UIView? {
        var view: UIView? = nil
        for v in subviews {
            if condition(v) {
                view = v
            } else {
                view = v.getFirst(condition)
            }
            if view != nil {
                break
            }
        }
        return view
    }
}
