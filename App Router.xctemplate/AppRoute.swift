//
//  AppRoute.swift
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

public enum PresentType {
    case root
    case push
    case present
    case presentWithNavigation
    case modal
    case modalWithNavigation
}

public protocol IAppRouter {
    // MARK: - Get Module Handler

    func getModule(module: Module) -> UIViewController?
    func getModule(module: Module, parameters: [String: Any]) -> UIViewController?
    
    // MARK: - Present Module Handler

    func presentModule(module: Module)
    func presentModule(module: Module, parameters: [String: Any])
    func presentModule(module: Module, type: PresentType)
    func presentModule(module: Module, onPresented: (() -> Void)?)
    func presentModule(module: Module, onDismissed: (([String: Any]) -> Void)?)
    func presentModule(module: Module, parameters: [String: Any], type: PresentType)
    func presentModule(module: Module, parameters: [String: Any], onPresented: (() -> Void)?)
    func presentModule(module: Module, parameters: [String: Any], onDismissed: (([String: Any]) -> Void)?)
    func presentModule(module: Module, type: PresentType, onPresented: (() -> Void)?)
    func presentModule(module: Module, type: PresentType, onDismissed: (([String: Any]) -> Void)?)
    func presentModule(module: Module, onPresented: (() -> Void)?, onDismissed: (([String: Any]) -> Void)?)
    func presentModule(module: Module, parameters: [String: Any], type: PresentType, onPresented: (() -> Void)?)
    func presentModule(module: Module, parameters: [String: Any], type: PresentType, onDismissed: (([String: Any]) -> Void)?)
    func presentModule(module: Module, type: PresentType, onPresented: (() -> Void)?, onDismissed: (([String: Any]) -> Void)?)
    func presentModule(module: Module, parameters: [String: Any], type: PresentType, onPresented: (() -> Void)?, onDismissed: (([String: Any]) -> Void)?)
    
    // MARK: - Present View Handler

    func presentView(view: UIViewController)
    func presentView(view: UIViewController, animated: Bool)
    func presentView(view: UIViewController, completion: (() -> Void)?)
    func presentView(view: UIViewController, animated: Bool, completion: (() -> Void)?)

    // MARK: - Dismiss Handler

    func dismiss()
    func dismiss(module: Module)
    func dismiss(animated: Bool)
    func dismiss(parameters: [String: Any])
    func dismiss(module: Module, animated: Bool)
    func dismiss(module: Module, parameters: [String: Any])
    func dismiss(animated: Bool, parameters: [String: Any])
    func dismiss(module: Module?, animated: Bool, parameters: [String: Any])
}

public class AppRouter: BaseAppRouter {
    public static let share = AppRouter().create()
    
    private func create() -> AppRouter {
        var window: UIWindow?
        
        if let _window = UIApplication.shared.keyWindow {
            window = _window
        } else {
            window = UIWindow(frame: UIScreen.main.bounds)
        }
        
        window?.makeKeyAndVisible()
        
        let router = AppRouter()
        router.window = window
        return router
    }
}