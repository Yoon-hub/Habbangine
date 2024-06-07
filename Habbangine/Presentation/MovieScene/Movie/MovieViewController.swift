//
//  MovieViewController.swift
//  Habbangine
//
//  Created by 윤제 on 5/30/24.
//  Copyright © 2024 HabbangineOrg. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

final class MovieViewController: CommonViewController<MovieViewModel> {
    
    // MARK: - View Life Cycle
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func set() {
        super.set()
        bind()
    }
    
    override func handleOutput(_ state: MovieViewModel.State) {
        
    }
    
    override func setNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: nil)
        self.navigationController?.navigationBar.tintColor = UIColor(named: "mainColor")
    }
}

// MARK: - RxBinding
extension MovieViewController {
    private func bind() {
        self.navigationItem.rightBarButtonItem?.rx.tap
            .bind { [weak self] in
                self?.moveToMoviewAdd()
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - View Transition
extension MovieViewController {
    private func moveToMoviewAdd() {
        let movieAddView = MovieAddView()
        let movieAddViewModel = MovieAddViewModel()
        
        let movieAddViewController = MovieAddViewController(movieAddView: movieAddView, viewModel: movieAddViewModel)
        self.navigationController?.pushViewController(movieAddViewController, animated: true)
    }
}
