//
//  Module.swift
//  ARTDEVCommon
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ARI MUNANDAR. All rights reserved.
//  Modify By:  * Ari Munandar
//              * arimunandar.dev@gmail.com
//              * https://github.com/arimunandar
//              * https://www.youtube.com/channel/UC7jr8DR06tcVR0QKKl6cSNA?view_as=subscriber

import Foundation
import UIKit

public protocol IModule {
    func presentView(parameters: [String: Any])
    func createView(parameters: [String: Any]) -> UIViewController?
}

public protocol Module {
    var routePath: String { get }
}
