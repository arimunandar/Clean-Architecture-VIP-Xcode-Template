//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//  Modify By:  * Ari Munandar
//              * arimunandar.dev@gmail.com
//              * https://github.com/arimunandar

import Foundation
import UIKit

//================================================================================================
// Common App Router Service
//================================================================================================

enum PresentType {
    case root
    case push
    case present
    case presentWithNavigation
    case modal
    case modalWithNavigation
}

protocol IRouter {
    var module: UIViewController? { get }
}

extension UIViewController {
    static func initialModule<T: IRouter>(module: T) -> UIViewController {
        guard let _module = module.module else { fatalError() }
        return _module
    }
    
    func navigate(type: PresentType = .push, module: IRouter, completion: ((_ module: UIViewController) -> Void)? = nil) {
        guard let _module = module.module else { fatalError() }
        switch type {
        case .root:
            if _module is UITabBarController {
                UIApplication.shared.delegate?.window??.setRootViewController(_module, options: .init(direction: .fade, style: .easeInOut))
            } else {
                UIApplication.shared.delegate?.window??.setRootViewController(
                    UINavigationController(rootViewController: _module),
                    options: .init(
                        direction: .fade,
                        style: .easeInOut
                    )
                )
            }
            completion?(_module)
        case .push:
            if let navigation = self.navigationController {
                navigation.pushViewController(_module, animated: true)
                completion?(_module)
            }
        case .present:
            self.present(_module, animated: true, completion: {
                completion?(_module)
            })
        case .presentWithNavigation:
            let nav = UINavigationController(rootViewController: _module)
            self.present(nav, animated: true, completion: {
                completion?(_module)
            })
        case .modal:
            _module.modalTransitionStyle = .crossDissolve
            _module.modalPresentationStyle = .overFullScreen
            
            self.present(_module, animated: true, completion: {
                completion?(_module)
            })
        case .modalWithNavigation:
            let nav = UINavigationController(rootViewController: _module)
            nav.modalPresentationStyle = .overFullScreen
            nav.modalTransitionStyle = .crossDissolve
            self.present(nav, animated: true, completion: {
                completion?(_module)
            })
        }
    }
    
    func dismiss(to: IRouter? = nil, _ completion: (() -> Void)? = nil) {
        if self.navigationController != nil {
            self.navigationController?.dismiss(animated: true, completion: {
                completion?()
                return
            })
            
            if let module = to?.module, let viewControllers = self.navigationController?.viewControllers {
                if let _vc = viewControllers.filter({ type(of: $0) == type(of: module) }).first {
                    self.navigationController?.popToViewController(_vc, animated: true)
                }
            } else {
                self.navigationController?.popViewController(animated: true)
            }
            completion?()
        } else {
            self.dismiss(animated: true, completion: {
                completion?()
            })
        }                
    }
    
    func backToRoot(_ completion: (() -> Void)? = nil) {
        self.navigationController?.popToRootViewController(animated: true)
        completion?()
    }
}

extension UIViewController {
    private struct UniqueIdProperies {
        static var pickerDelegate: IDataPickerDelegate?
        static var previousViewController: UIViewController?
    }
    
    // MARK: - Picker Delegate Properties
    
    weak var dataPickerDelegate: IDataPickerDelegate? {
        get {
            return objc_getAssociatedObject(self, &UniqueIdProperies.pickerDelegate) as? IDataPickerDelegate
        } set {
            if let unwrappedValue = newValue {
                objc_setAssociatedObject(self, &UniqueIdProperies.pickerDelegate, unwrappedValue as IDataPickerDelegate?, .OBJC_ASSOCIATION_ASSIGN)
            }
        }
    }
    
    var previousViewController: UIViewController? {
        get {
            return objc_getAssociatedObject(self, &UniqueIdProperies.previousViewController) as? UIViewController
        } set {
            if let unwrappedValue = newValue {
                objc_setAssociatedObject(self, &UniqueIdProperies.previousViewController, unwrappedValue as UIViewController?, .OBJC_ASSOCIATION_ASSIGN)
            }
        }
    }
    
    static func newController(withView view: UIView, frame: CGRect) -> UIViewController {
        view.frame = frame
        let controller = UIViewController()
        controller.view = view
        return controller
    }
}

//================================================================================================
// Common Extension
//================================================================================================

extension UIApplication {
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            let top = self.topViewController(nav.visibleViewController)
            return top
        }
        
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                let top = self.topViewController(selected)
                return top
            }
        }
        
        if let presented = base?.presentedViewController {
            let top = self.topViewController(presented)
            return top
        }
        return base
    }
}

public extension UIWindow {
    /// Transition Options
    struct TransitionOptions {
        /// Curve of animation
        ///
        /// - linear: linear
        /// - easeIn: ease in
        /// - easeOut: ease out
        /// - easeInOut: ease in - ease out
        public enum Curve {
            case linear
            case easeIn
            case easeOut
            case easeInOut
            
            /// Return the media timing function associated with curve
            internal var function: CAMediaTimingFunction {
                let key: String!
                switch self {
                case .linear: key = CAMediaTimingFunctionName.linear.rawValue
                case .easeIn: key = CAMediaTimingFunctionName.easeIn.rawValue
                case .easeOut: key = CAMediaTimingFunctionName.easeOut.rawValue
                case .easeInOut: key = CAMediaTimingFunctionName.easeInEaseOut.rawValue
                }
                return CAMediaTimingFunction(name: CAMediaTimingFunctionName(rawValue: key!))
            }
        }
        
        /// Direction of the animation
        ///
        /// - fade: fade to new controller
        /// - toTop: slide from bottom to top
        /// - toBottom: slide from top to bottom
        /// - toLeft: pop to left
        /// - toRight: push to right
        public enum Direction {
            case fade
            case toTop
            case toBottom
            case toLeft
            case toRight
            
            /// Return the associated transition
            ///
            /// - Returns: transition
            internal func transition() -> CATransition {
                let transition = CATransition()
                transition.type = CATransitionType.push
                switch self {
                case .fade:
                    transition.type = CATransitionType.fade
                    transition.subtype = nil
                case .toLeft:
                    transition.subtype = CATransitionSubtype.fromLeft
                case .toRight:
                    transition.subtype = CATransitionSubtype.fromRight
                case .toTop:
                    transition.subtype = CATransitionSubtype.fromTop
                case .toBottom:
                    transition.subtype = CATransitionSubtype.fromBottom
                }
                return transition
            }
        }
        
        /// Background of the transition
        ///
        /// - solidColor: solid color
        /// - customView: custom view
        public enum Background {
            case solidColor(_: UIColor)
            case customView(_: UIView)
        }
        
        /// Duration of the animation (default is 0.20s)
        public var duration: TimeInterval = 0.20
        
        /// Direction of the transition (default is `toRight`)
        public var direction: TransitionOptions.Direction = .toRight
        
        /// Style of the transition (default is `linear`)
        public var style: TransitionOptions.Curve = .linear
        
        /// Background of the transition (default is `nil`)
        public var background: TransitionOptions.Background?
        
        /// Initialize a new options object with given direction and curve
        ///
        /// - Parameters:
        ///   - direction: direction
        ///   - style: style
        public init(direction: TransitionOptions.Direction = .toRight, style: TransitionOptions.Curve = .linear) {
            self.direction = direction
            self.style = style
        }
        
        public init() {}
        
        /// Return the animation to perform for given options object
        internal var animation: CATransition {
            let transition = self.direction.transition()
            transition.duration = self.duration
            transition.timingFunction = self.style.function
            return transition
        }
    }
    
    /// Change the root view controller of the window
    ///
    /// - Parameters:
    ///   - controller: controller to set
    ///   - options: options of the transition
    func setRootViewController(_ controller: UIViewController, options: TransitionOptions = TransitionOptions()) {
        var transitionWnd: UIWindow?
        if let background = options.background {
            transitionWnd = UIWindow(frame: UIScreen.main.bounds)
            switch background {
            case .customView(let view):
                transitionWnd?.rootViewController = UIViewController.newController(withView: view, frame: transitionWnd!.bounds)
            case .solidColor(let color):
                transitionWnd?.backgroundColor = color
            }
            transitionWnd?.makeKeyAndVisible()
        }
        
        // Make animation
        self.layer.add(options.animation, forKey: kCATransition)
        self.rootViewController = controller
        self.makeKeyAndVisible()
        
        if let wnd = transitionWnd {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1 + options.duration) {
                wnd.removeFromSuperview()
            }
        }
    }
}

//================================================================================================
// Common Protocol Delegate
//================================================================================================

protocol IDataPickerDelegate: class {
    func didDataPicker<T>(_ data: T?)
}
