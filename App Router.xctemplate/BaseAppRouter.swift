//
//  BaseAppRouter.swift
//  ARTDEVCommon
//
//  Created by Ari Munandar on 20/03/20.
//  Copyright (c) 2020 ARI MUNANDAR. All rights reserved.
//  Modify By:  * Ari Munandar
//              * arimunandar.dev@gmail.com
//              * https://github.com/arimunandar
//              * https://www.youtube.com/channel/UC7jr8DR06tcVR0QKKl6cSNA?view_as=subscriber

import Foundation
import UIKit

public class BaseAppRouter: IAppRouter {
    var window: UIWindow?
    private var navigationStack: [UINavigationController?] = []
    private var navigation: UINavigationController? {
        if navigationStack.count > 1 {
            return navigationStack.last as? UINavigationController
        }
        return navigationStack.first as? UINavigationController
    }
    
    private var moduleStack: [String: ((_ parameters: [String: Any]) -> Void)?] = [:]
    public var modules: [String: (_ appRouter: IAppRouter) -> IModule]!
    private var onPresented: (() -> Void)?
    private var onDismissed: ((_ parameters: [String: Any]) -> Void)?
    private var presentTypes: [PresentType] = []
    private var presentType: PresentType {
        if presentTypes.count > 1 {
            return presentTypes.last ?? .push
        }
        return presentTypes.first ?? .push
    }
}

public extension BaseAppRouter {
    func getModule(module: Module) -> UIViewController? {
        return getModule(module: module, parameters: [:])
    }
    
    func getModule(module: Module, parameters: [String: Any]) -> UIViewController? {
        if let module = modules[module.routePath] {
            let module = module(self)
            return module.createView(parameters: parameters)
        }
        return nil
    }
    
    func presentModule(module: Module) {
        presentModule(module: module, parameters: [:], type: .push, onPresented: nil, onDismissed: nil)
    }
    
    func presentModule(module: Module, parameters: [String: Any]) {
        presentModule(module: module, parameters: parameters, type: .push, onPresented: nil, onDismissed: nil)
    }
    
    func presentModule(module: Module, type: PresentType) {
        presentModule(module: module, parameters: [:], type: type, onPresented: nil, onDismissed: nil)
    }
    
    func presentModule(module: Module, onPresented: (() -> Void)?) {
        presentModule(module: module, parameters: [:], type: .push, onPresented: onPresented, onDismissed: nil)
    }
    
    func presentModule(module: Module, onDismissed: (([String: Any]) -> Void)?) {
        presentModule(module: module, parameters: [:], type: .push, onPresented: nil, onDismissed: onDismissed)
    }
    
    func presentModule(module: Module, parameters: [String: Any], type: PresentType) {
        presentModule(module: module, parameters: parameters, type: type, onPresented: nil, onDismissed: nil)
    }
    
    func presentModule(module: Module, parameters: [String: Any], onPresented: (() -> Void)?) {
        presentModule(module: module, parameters: parameters, type: .push, onPresented: onPresented, onDismissed: nil)
    }
    
    func presentModule(module: Module, parameters: [String: Any], onDismissed: (([String: Any]) -> Void)?) {
        presentModule(module: module, parameters: parameters, type: .push, onPresented: nil, onDismissed: onDismissed)
    }
    
    func presentModule(module: Module, type: PresentType, onPresented: (() -> Void)?) {
        presentModule(module: module, parameters: [:], type: type, onPresented: onPresented, onDismissed: nil)
    }
    
    func presentModule(module: Module, type: PresentType, onDismissed: (([String: Any]) -> Void)?) {
        presentModule(module: module, parameters: [:], type: type, onPresented: nil, onDismissed: onDismissed)
    }
    
    func presentModule(module: Module, onPresented: (() -> Void)?, onDismissed: (([String: Any]) -> Void)?) {
        presentModule(module: module, parameters: [:], type: .push, onPresented: onPresented, onDismissed: onDismissed)
    }
    
    func presentModule(module: Module, parameters: [String: Any], type: PresentType, onPresented: (() -> Void)?) {
        presentModule(module: module, parameters: parameters, type: type, onPresented: onPresented, onDismissed: nil)
    }
    
    func presentModule(module: Module, parameters: [String: Any], type: PresentType, onDismissed: (([String: Any]) -> Void)?) {
        presentModule(module: module, parameters: parameters, type: type, onPresented: nil, onDismissed: onDismissed)
    }
    
    func presentModule(module: Module, type: PresentType, onPresented: (() -> Void)?, onDismissed: (([String: Any]) -> Void)?) {
        presentModule(module: module, parameters: [:], type: type, onPresented: onPresented, onDismissed: onDismissed)
    }
    
    func presentModule(module: Module, parameters: [String: Any], type: PresentType, onPresented: (() -> Void)?, onDismissed: (([String: Any]) -> Void)?) {
        presentTypes.append(type)
        if let forModule = UIApplication.topViewController()?.moduleId {
            moduleStack[forModule] = onDismissed
        }
        
        if let module = modules[module.routePath] {
            let module = module(self)
            module.presentView(parameters: parameters)
        }
    }
    
    func presentView(view: UIViewController) {
        presentView(view: view, animated: true, completion: nil)
    }
    
    func presentView(view: UIViewController, animated: Bool) {
        presentView(view: view, animated: animated, completion: nil)
    }
    
    func presentView(view: UIViewController, completion: (() -> Void)?) {
        presentView(view: view, animated: true, completion: completion)
    }
    
    func presentView(view: UIViewController, animated: Bool, completion: (() -> Void)?) {
        print("MODULE ID: ", view.moduleId)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.onPresented?()
        }
        
        guard window?.rootViewController != nil else {
            if presentType == .root {
                if view is UITabBarController || view is UIPageViewController {
                    window?.rootViewController = view
                    guard let navigation = (view as? UITabBarController)?.selectedViewController as? UINavigationController else { return }
                    navigationStack.append(navigation)
                } else {
                    let navigation = UINavigationController(rootViewController: view)
                    navigationStack.append(navigation)
                    window?.rootViewController = navigation
                }
            }
            return
        }
        
        switch presentType {
        case .root:
            navigation?.setViewControllers([view], animated: false)
        case .push:
            view.hidesBottomBarWhenPushed = true
            navigation?.pushViewController(view, animated: true)
        case .present:
            view.modalPresentationStyle = .fullScreen
            navigation?.present(view, animated: true, completion: nil)
        case .presentWithNavigation:
            let nav = UINavigationController(rootViewController: view)
            nav.modalPresentationStyle = .fullScreen
            navigation?.present(nav, animated: true, completion: nil)
            navigationStack.append(nav)
        case .modal:
            view.modalPresentationStyle = .overFullScreen
            view.modalTransitionStyle = .crossDissolve
            navigation?.present(view, animated: true, completion: nil)
        case .modalWithNavigation:
            let nav = UINavigationController(rootViewController: view)
            nav.modalPresentationStyle = .overFullScreen
            nav.modalTransitionStyle = .crossDissolve
            navigation?.present(nav, animated: true, completion: nil)
            navigationStack.append(nav)
        }
    }
    
    func dismiss() {
        dismiss(module: nil, animated: true, parameters: [:])
    }
    
    func dismiss(module: Module) {
        dismiss(module: module, animated: true, parameters: [:])
    }
    
    func dismiss(animated: Bool) {
        dismiss(module: nil, animated: animated, parameters: [:])
    }
    
    func dismiss(parameters: [String: Any]) {
        dismiss(module: nil, animated: true, parameters: parameters)
    }
    
    func dismiss(module: Module, animated: Bool) {
        dismiss(module: module, animated: animated, parameters: [:])
    }
    
    func dismiss(module: Module, parameters: [String: Any]) {
        dismiss(module: module, animated: true, parameters: parameters)
    }
    
    func dismiss(animated: Bool, parameters: [String: Any]) {
        dismiss(module: nil, animated: animated, parameters: parameters)
    }
    
    func dismiss(module: Module?, animated: Bool, parameters: [String: Any]) {
        if let _module = module {
            if let vc = navigation?.viewControllers.filter({ $0.moduleId == _module.routePath }).first {
                onDismissed = moduleStack[_module.routePath] ?? nil
                navigation?.popToViewController(vc, animated: animated)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    self?.onDismissed?(parameters)
                }
            }
        } else {
            if let _dismiss = moduleStack.values.first {
                onDismissed = _dismiss
            }
            
            if isPresentedType() {
                if navigationStack.count > 1 {
                    navigationStack.removeLast()
                }
                
                _ = navigation?.dismiss(animated: animated, completion: { [weak self] in
                    self?.onDismissed?(parameters)
                })
            } else {
                _ = navigation?.popViewController(animated: animated)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    self?.onDismissed?(parameters)
                }
            }
            
            if presentTypes.count > 1 {
                presentTypes.removeLast()
            }
        }
    }
    
    private func isPresentedType() -> Bool {
        guard let last = presentTypes.last else { fatalError() }
        switch last {
        case .push:
            return false
        default:
            return true
        }
    }
}

private extension UIApplication {
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        return viewController
    }
}

private extension Bundle {
    static func appName() -> String {
        guard let dictionary = Bundle.main.infoDictionary else {
            return ""
        }
        if let version: String = dictionary["CFBundleName"] as? String {
            return version
        } else {
            return ""
        }
    }
}

private extension UIViewController {
    var moduleId: String {
        return Bundle.appName() + "/" + String(describing: type(of: self)).replacingOccurrences(of: "ViewController", with: "")
    }
}