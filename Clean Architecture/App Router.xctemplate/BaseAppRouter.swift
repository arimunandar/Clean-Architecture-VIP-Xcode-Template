//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//  Modify By:  * Ari Munandar
//              * arimunandar.dev@gmail.com
//              * https://github.com/arimunandar
//              * https://www.youtube.com/channel/UC7jr8DR06tcVR0QKKl6cSNA?view_as=subscriber

import Foundation
import UIKit

enum PresentType {
    case root
    case push
    case present
    case presentWithNavigation
    case modal
    case modalWithNavigation
}

class BaseAppRouter: IAppRouter {
    private var window: UIWindow?
    private var navigationStack: [UINavigationController?] = []
    private var navigation: UINavigationController? {
        if navigationStack.count > 1 {
            return navigationStack.last as? UINavigationController
        }
        return navigationStack.first as? UINavigationController
    }

    private var products: [String: (_ appRouter: IAppRouter) -> IModule]!
    private var onPresented: (() -> Void)?
    private var onDismissed: (() -> Void)?
    private var presentTypes: [PresentType] = []
    private var presentType: PresentType {
        if presentTypes.count > 1 {
            return presentTypes.last ?? .push
        }
        return presentTypes.first ?? .push
    }

    init(window: UIWindow?, products: [String: (_ appRouter: IAppRouter) -> IModule]) {
        self.window = window
        self.products = products
    }
    
    func getModule(module: Module) -> UIViewController? {
        return getModule(module: module, parameters: [:])
    }
    
    func getModule(module: Module, parameters: [String : Any]) -> UIViewController? {
        if let product = products[module.routePath] {
            let module = product(self)
            return module.createView(parameters: parameters)
        }
        return nil
    }

    func presentModule(
        module: Module,
        type: PresentType
    ) {
        presentModule(
            module: module,
            parameters: [:],
            type: type,
            onPresented: nil,
            onDismissed: nil
        )
    }

    func presentModule(
        module: Module,
        parameters: [String: Any],
        type: PresentType
    ) {
        presentModule(
            module: module,
            parameters: parameters,
            type: type,
            onPresented: nil,
            onDismissed: nil
        )
    }

    func presentModule(
        module: Module,
        parameters: [String: Any],
        type: PresentType,
        onPresented: (() -> Void)?
    ) {
        presentModule(
            module: module,
            parameters: parameters,
            type: type,
            onPresented: onPresented,
            onDismissed: nil
        )
    }

    func presentModule(
        module: Module,
        parameters: [String: Any],
        type: PresentType,
        onDismissed: (() -> Void)?
    ) {
        presentModule(
            module: module,
            parameters: parameters,
            type: type,
            onPresented: nil,
            onDismissed: onDismissed
        )
    }

    func presentModule(
        module: Module,
        parameters: [String: Any],
        type: PresentType,
        onPresented: (() -> Void)?,
        onDismissed: (() -> Void)?
    ) {
        self.onPresented = onPresented
        self.onDismissed = onDismissed
        presentTypes.append(type)

        if let product = products[module.routePath] {
            let module = product(self)
            module.presentView(parameters: parameters)
        }
    }

    func presentView(
        view: UIViewController,
        animetedDisplay: Bool,
        animatedDismiss: Bool
    ) {
        presentView(
            view: view,
            animetedDisplay: animetedDisplay,
            animatedDismiss: animatedDismiss,
            completion: nil
        )
    }

    func presentView(
        view: UIViewController,
        animetedDisplay: Bool,
        animatedDismiss: Bool,
        completion: (() -> Void)?
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.onPresented?()
        }

        guard let root = window?.rootViewController else {
            if presentType == .root {
                if view is UITabBarController || view is UIPageViewController {
                    window?.rootViewController = view
                } else {
                    let navigation = UINavigationController(rootViewController: view)
                    navigationStack.append(navigation)
                    window?.rootViewController = navigation
                }
            }
            return
        }

        switch root {
        case is UITabBarController:
            guard let navigation = (root as? UITabBarController)?.selectedViewController?.navigationController else { return }
            navigationStack.append(navigation)
        default:
            break
        }

        switch presentType {
        case .root:
            navigation?.setViewControllers([view], animated: false)
        case .push:
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

    func dismissViewController(animeted: Bool) {
        if isPresentedType() {
            if navigationStack.count > 1 {
                navigationStack.removeLast()
            }

            _ = navigation?.dismiss(animated: animeted, completion: onDismissed)
        } else {
            _ = navigation?.popViewController(animated: animeted)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.onDismissed?()
            }
        }

        if presentTypes.count > 1 {
            presentTypes.removeLast()
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
