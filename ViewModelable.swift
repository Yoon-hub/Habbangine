//
//  ViewModelable.swift
//  Habbangine
//
//  Created by 윤제 on 6/5/24.
//

import Foundation

import RxSwift

protocol ViewModelable {
    associatedtype Action
    associatedtype State
    
    var output: Observable<State> {get}
    func input(_ action: Action) 
}
