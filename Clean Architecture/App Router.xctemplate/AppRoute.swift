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

protocol IAppRouter {
    func getModule(module: Module) -> UIViewController?
    func getModule(module: Module, parameters: [String: Any]) -> UIViewController?
    func presentModule(
        module: Module,
        type: PresentType
    )
    func presentModule(
        module: Module,
        parameters: [String: Any],
        type: PresentType
    )
    func presentModule(
        module: Module,
        parameters: [String: Any],
        type: PresentType,
        onPresented: (() -> Void)?
    )
    func presentModule(
        module: Module,
        parameters: [String: Any],
        type: PresentType,
        onDismissed: (() -> Void)?
    )
    func presentModule(
        module: Module,
        parameters: [String: Any],
        type: PresentType,
        onPresented: (() -> Void)?,
        onDismissed: (() -> Void)?
    )
    func presentView(
        view: UIViewController,
        animetedDisplay: Bool,
        animatedDismiss: Bool
    )
    func presentView(
        view: UIViewController,
        animetedDisplay: Bool,
        animatedDismiss: Bool,
        completion: (() -> Void)?
    )
    func dismissViewController(animeted: Bool)
}

class AppRouter: BaseAppRouter {
    static let share = AppRouter.create()

    private static func create() -> AppRouter {
        let modules: [String: (_ appRouter: IAppRouter) -> IModule] = [
            Product.home.routePath: { HomeModule($0) }, // Just an Example 😎
        ]

        var window: UIWindow?

        if let _window = UIApplication.shared.keyWindow {
            window = _window
        } else {
            window = UIWindow(frame: UIScreen.main.bounds)
        }

        window?.makeKeyAndVisible()

        let router = AppRouter(window: window, products: modules)
        return router
    }
}
