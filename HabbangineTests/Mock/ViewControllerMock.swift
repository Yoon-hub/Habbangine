//
//  ViewControllerMock.swift
//  HabbangineTests
//
//  Created by 윤제 on 6/7/24.
//

import UIKit

import RxCocoa
import RxSwift
@testable import Habbangine

final class ViewControllerMock<T: ViewModelable>: Presentable {
    typealias ViewModelType = T
    
    var viewModel: ViewModelType
    var stateObservable: Observable<ViewModelType.State> {
        stateRelay
    }
    
    private let stateRelay = ReplaySubject<ViewModelType.State>.createUnbounded()
    
    init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        
        viewModel.output
            .observe(on: MainScheduler.instance)
            .bind(to: stateRelay)
    }
}

extension MovieAddViewModel.State: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.updateImageList(lhsCount), .updateImageList(rhsCount)):
            return lhsCount == rhsCount
        case let (.toastSaveInvalid(lhsCount), .toastSaveInvalid(rhsCount)):
            return lhsCount == rhsCount
        default:
            return false
        }
    }
}

