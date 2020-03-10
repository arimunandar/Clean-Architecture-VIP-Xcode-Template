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

enum Product: Module {
    case home // Just an Example 😎

    var routePath: String {
        switch self {
        case .home:
            return "___PROJECTNAME___/home" // Just an Example 😎
        }
    }
}

protocol IModule {
    func presentView(parameters: [String: Any])
}

protocol Module {
    var routePath: String { get }
}
