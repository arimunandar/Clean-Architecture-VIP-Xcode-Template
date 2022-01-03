//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ Stockbit - ARI MUNANDAR. All rights reserved.

import Foundation
import AppsRouter

public enum ___VARIABLE_productName:identifier___Products: AppModule {
    case HomeModule

    public var productName: String {
        return "___VARIABLE_productName:identifier___Products"
    }

    public var routePath: String {
        switch self {
        case .HomeModule:
            return "/vip/home"
        }
    }
}