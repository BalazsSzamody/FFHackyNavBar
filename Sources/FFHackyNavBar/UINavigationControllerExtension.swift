//
//  UINavigationControllerExtension.swift
//  
//
//  Created by Balazs Szamody on 15/7/19.
//

import UIKit

public extension UINavigationBar {
    enum HackyError: Error {
        case componentNotFound(Component)
        
        var localizedDescription: String {
            switch self {
            case .componentNotFound(let component):
                return String(describing: component) + " not found in UINavigationBar"
            }
        }
    }
    enum Component {
        case barBackground
        case visualEffectView
        case imageView
        case custom(((UIView) -> Bool))
        
        var condition: (UIView) -> Bool {
            switch self {
            case .custom(let condition):
                return condition
            case .imageView:
                return { $0 is UIImageView }
            default:
                return { String(describing: $0).contains(self.name) }
            }
        }
        
        var name: String {
            switch self {
            case .barBackground:
                return "_UIBarBackground"
            case .visualEffectView:
                return "UIVisualEffectView"
            default:
                return ""
            }
        }
    }
    
    func component(_ type: Component) -> UIView? {
        return getFirst(type.condition)
    }
    
    func insertImageView(with image: UIImage? = nil) throws -> UIImageView {
        guard let barBG = component(.barBackground) else {
            throw HackyError.componentNotFound(.barBackground)
        }
        let imageView = UIImageView(image: image)
        barBG.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: barBG.leadingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: barBG.topAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: barBG.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: barBG.bottomAnchor).isActive = true
        return imageView
    }
}

public extension UINavigationController {
    enum Fade {
        case fadeIn
        case fadeOut
        
        internal var bool: Bool {
            switch self {
            case .fadeIn:
                return true
            case .fadeOut:
                return false
            }
        }
        
        public static var duration: TimeInterval = 0.3
    }
    
    @discardableResult
    func setupCustomBackgroundImage(_ image: UIImage) throws -> UIImageView {
        return try navigationBar.insertImageView(with: image)
    }
    
    func fade(type: Fade, animated: Bool = true) {
        guard animated else {
            makeVisible(type.bool)
            return
        }
        UIView.animate(withDuration: Fade.duration) {
            self.makeVisible(type.bool)
        }
    }
    
    private func makeVisible(_ isVisible: Bool) {
        
    }
    
//    func juju() {
//        navigationBar.backgroundColor = .white
//        guard let bgView = navigationBar.getFirst({ String(describing: $0).contains("_UIBarBackground") }) else {
//            return
//        }
//        let imageView = UIImageView(image: UIImage(named: "backgroundBgSplash"))
//        bgView.addSubview(imageView)
//        bgView.clipsToBounds = true
//        imageView.widthAnchor.constraint(equalTo: bgView.widthAnchor, multiplier: 1).isActive = true
//        imageView.heightAnchor.constraint(equalTo: bgView.heightAnchor, multiplier: 1).isActive = true
//        bgView.bringSubviewToFront(imageView)
//        let visualView = navigationBar.getFirst({ String(describing: $0).contains("UIVisualEffectView") })
//        visualView?.removeFromSuperview()
//        //        navBar.clipsToBounds = true
//        navigationBar.layoutIfNeeded()
//    }
}
