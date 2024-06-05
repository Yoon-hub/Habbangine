//
//  Presentable.swift
//  Habbangine
//
//  Created by 윤제 on 6/4/24.
//  Copyright © 2024 HabbangineOrg. All rights reserved.
//

import Foundation

import RxSwift

protocol Presentable {
    associatedtype ViewModelType: ViewModelable
    
    var viewModel: ViewModelType {get}
    var stateObservable: Observable<ViewModelType.State> {get}
    
    func handleOutput(_ state: ViewModelType.State)
}
