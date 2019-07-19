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
import Swinject
import UIKit

enum PresentType {
    case root
    case push
    case rootPush
    case present
    case modal
    case presentWithNavigation
    case modalWithNavigation
    case bottomSheet
}

class AppRoute {
    static let share = AppRoute().setup()
    private var navigationController: UINavigationController?
    var assembler: Assembler?
    private weak var appDelegate = UIApplication.shared.delegate
    
    fileprivate func setup() -> AppRoute {
        self.assembler = Assembler()
        self.assembler?.apply(assemblies: [])
        return self
    }
    
    func getModule<T: UIViewController>(with module: T.Type, with parameter: [String: Any] = [:]) -> T {
        guard let _module = AppRoute.share.assembler?.resolver.resolve(module, argument: parameter) else {
            return UIViewController() as! T
        }
        return _module
    }
    
    func presentModule<T: UIViewController>(
        with presentType: PresentType = .push,
        from parent: UIViewController? = UIApplication.shared.keyWindow?.rootViewController,
        to module: T.Type,
        with parameter: [String: Any] = [:],
        _ completion: (() -> Void)? = nil
    ) {
        let top = UIApplication.topViewController()
        self.navigationController = top?.navigationController
        
        guard let _module = AppRoute.share.assembler?.resolver.resolve(module, argument: parameter) else { return }
        
        switch presentType {
        case .root:
            if _module is UITabBarController {
                self.appDelegate?.window??.setRootViewController(_module, options: .init(direction: .fade, style: .easeInOut))
            } else {
                self.appDelegate?.window??.setRootViewController(
                    UINavigationController(rootViewController: _module),
                    options: .init(
                        direction: .fade,
                        style: .easeInOut
                    )
                )
                self.navigationController = self.appDelegate?.window??.rootViewController as? UINavigationController
            }
            completion?()
        case .rootPush:
            self.navigationController?.setViewControllers([_module], animated: true)
        case .push:
            _module.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(_module, animated: true)
            completion?()
        case .present:
            self.navigationController?.present(_module, animated: true, completion: completion)
        case .modal:
            _module.modalPresentationStyle = .overFullScreen
            _module.modalTransitionStyle = .crossDissolve
            self.navigationController?.present(_module, animated: true, completion: completion)
        case .presentWithNavigation:
            let nav = UINavigationController(rootViewController: _module)
            self.navigationController?.present(nav, animated: true, completion: completion)
        case .modalWithNavigation:
            let nav = UINavigationController(rootViewController: _module)
            nav.modalPresentationStyle = .overFullScreen
            nav.modalTransitionStyle = .crossDissolve
            self.navigationController?.present(nav, animated: true, completion: completion)
        case .bottomSheet:
            break
        }
    }
    
    func dismissModule(_ completion: (() -> Void)? = nil) {
        _ = UIApplication.topViewController()?.dismiss(animated: true, completion: completion)
    }
    
    func popModule(_ completion: (() -> Void)? = nil) {
        _ = UIApplication.topViewController()?.navigationController?.popToRootViewController(animated: true)
        completion?()
    }
    
    func popRootModule(_ completion: (() -> Void)? = nil) {
        _ = UIApplication.topViewController()?.navigationController?.popToRootViewController(animated: true)
        completion?()
    }
}

extension UIApplication {
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            let top = topViewController(nav.visibleViewController)
            return top
        }

        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                let top = topViewController(selected)
                return top
            }
        }

        if let presented = base?.presentedViewController {
            let top = topViewController(presented)
            return top
        }
        return base
    }
}