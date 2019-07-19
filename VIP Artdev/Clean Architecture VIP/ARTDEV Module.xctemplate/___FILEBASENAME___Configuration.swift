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

class ___VARIABLE_productName:identifier___Configuration {
    static func setup(parameters: [String: Any] = [:]) -> UIViewController {
        let controller = ___VARIABLE_productName:identifier___ViewController()
        let presenter = ___VARIABLE_productName:identifier___Presenter(view: controller)
        let manager = ___VARIABLE_productName:identifier___Manager()
        let interactor = ___VARIABLE_productName:identifier___Interactor(presenter: presenter, manager: manager)
        
        controller.interactor = interactor
        interactor.parameters = parameters
        return controller
    }
}