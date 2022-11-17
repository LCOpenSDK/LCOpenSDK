//
//  ILCMessageListController.swift
//  LCMessageModule
//
//  Created by lei on 2022/10/10.
//

import Foundation
import UIKit

protocol ILCMessageListController:NSObjectProtocol {
    
    func mainView() -> UIView?
    
    func mainVC() -> UIViewController?
    
    func reloadData()
    
    func endRefresh()
    
    func showNoMoreData()
    
    func showEmptyView()
    
    func showErrorView()
}
