//
//  HabbangineTests.swift
//  HabbangineTests
//
//  Created by 윤제 on 6/5/24.
//

import UIKit
import RxSwift
import RxCocoa
import Quick
import Nimble
import RxNimble

@testable import Habbangine

final class MovieAddViewModel_Tests: QuickSpec {
    override class func spec() {
        var viewModel: MovieAddViewModel!
        var viewController: ViewControllerMock<MovieAddViewModel>!
        let timeout: TimeInterval = 3
        
        func setUp() {
            viewModel = MovieAddViewModel()
            viewController = ViewControllerMock(viewModel: viewModel)
        }
        
        describe("MovieAddViewModel에서") {
            beforeEach { setUp() }
            
            context("사진이 선택되면") {
                beforeEach { viewModel.input(.imageWasSelected(UIImage(systemName: "pencil")!)) }
                
                it("사진 리스트에 추가") {
                    expect(viewModel.imageList.value.count)
                        .toEventually(equal(1))
                }
                
                it("사진 리스트 ViewController에 전달") {
                    let expected = MovieAddViewModel.State.updateImageList([UIImage(systemName: "pencil")!])
                    
                    expect(viewController.stateObservable)
                        .first(timeout: timeout)
                        .toNot(equal(expected))
                }
            }
        }
    }
}
