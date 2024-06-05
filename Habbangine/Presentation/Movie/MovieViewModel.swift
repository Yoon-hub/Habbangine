//
//  MovieViewModel.swift
//  Habbangine
//
//  Created by 윤제 on 6/5/24.
//

import Foundation

import RxSwift
import RxRelay

final class MoviewViewModel: ViewModelable {

    enum State {
        
    }
    
    enum Action {
        
    }
    
    var output: Observable<State> {
        outputSubject
    }
    
    private var outputSubject = PublishSubject<State>()
    
    func input(_ action: Action) {
        switch action {
        }
    }
}
