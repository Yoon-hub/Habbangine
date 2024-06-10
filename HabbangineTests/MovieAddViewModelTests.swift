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
            let movieDataService = MovieDataService.shared
            let dependency = MovieAddViewModel.Dependency(movieDataService: movieDataService)
            viewModel = MovieAddViewModel(dependency: dependency)
            viewController = ViewControllerMock(viewModel: viewModel)
        }
        
        describe("MovieAddViewModel에서") {
            beforeEach { setUp() }
            
            context("사진이 picker에서 선택되면") {
                beforeEach { viewModel.input(.imageWasSelected(UIImage(systemName: "pencil")!)) }
                
                it("사진 리스트에 추가") {
                    expect(viewModel.imageList.value.count)
                        .toEventually(equal(1))
                }
                
                it("사진 리스트 ViewController에 전달") {
                    let expected = MovieAddViewModel.State.updateImageList([UIImage(systemName: "pencil")!])
                    
                    expect(viewController.stateObservable)
                        .first(timeout: timeout)
                        .toEventually(equal(expected))
                }
            }
            
            context("사진 삭제를 위해 선택되면") {
                beforeEach {
                    viewModel.input(.imageWasSelected(UIImage(systemName: "pencil")!))
                    viewModel.input(.tapDeleteImage(IndexPath(row: 0, section: 0)))
                }
                
                it("사진 리스트에서 삭제") {
                    expect(viewModel.imageList.value.count)
                        .toEventually(equal(0))
                }
            }
            
            
            context("저장 버튼을 눌렀을 때") {
                beforeEach {
                    viewModel.input(.tapSaveButton("", ""))
                }
                
                it("저장이 불가능한 상황이면 에러메세지 ") {
                    let expected = MovieAddViewModel.State.toastSaveInvalid(MovieAddViewModel.ErrorMessage.imageIsEmpty.errorDescription!)
                    
                    expect(viewController.stateObservable)
                        .first(timeout: timeout)
                        .toEventually(equal(expected))
                    
                }
            }
        }
    }
}
