//
//  CommonViewController.swift
//  Habbangine
//
//  Created by 윤제 on 6/5/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxRelay

class CommonViewController<ViewModel: ViewModelable>: UIViewController, Presentable {

    typealias ViewModelType = ViewModel
    
    let viewModel: ViewModelType
    
    var stateObservable: Observable<ViewModelType.State> {
        stateSubject
    }
    
    let disposeBag = DisposeBag()
    
    private let stateSubject = PublishSubject<ViewModelType.State>()
    
    // MARK: - Init
    init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        set()
    }
    
    func handleOutput(_ state: ViewModelType.State) { }

    // MARK: - Set
    func set() {
        setUI()
        viewModelOutPutbind()
    }
    
    func setUI() {view.backgroundColor = .white}
    
    // MARK: - ViewModel Interaction
    private func viewModelOutPutbind() {
        viewModel.output
            .bind(to: stateSubject)
            .disposed(by: disposeBag)
        
        stateSubject
            .observe(on: MainScheduler.instance)
            .bind(with: self) { s, state in
                s.handleOutput(state)
            }
            .disposed(by: disposeBag)
    }
}
