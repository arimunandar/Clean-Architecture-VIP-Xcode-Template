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

enum SampleRoute: IRouter {
    /*
     If you want passing with parameters
     you just add like this:
     
     case login(parameter: Any)
     
     you can use: String, Int, [String: Any], etc..
    */
    case login
}

extension SampleRoute {
    var module: UIViewController? {
        /*
         Setup module with parameters like:
         
         switch self {
         case .login(let parameters):
            return LoginConfiguration.setup(parameters: parameters)
         }
         
         */
        switch self {
        case .login:
            return LoginConfiguration.setup()
    }
}
