//
//  ILCMessageEditController.swift
//  LCMessageModule
//
//  Created by lei on 2022/10/14.
//

import Foundation

protocol ILCMessageEditController:NSObjectProtocol {
    
    func mainView() -> UIView
    
    func mainVC() -> UIViewController
    
    func reloadData()
    
}
