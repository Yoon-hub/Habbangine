//
//  MovieAddViewModel.swift
//  Habbangine
//
//  Created by 윤제 on 6/7/24.
//

import UIKit

import RxSwift
import RxRelay

final class MovieAddViewModel: ViewModelable {
    
    enum Action {
        case imageWasSelected(UIImage)
        case tapDeleteImage(IndexPath)
    }

    enum State {
        case updateImageList([UIImage])
    }
    
    var imageList = BehaviorRelay<[UIImage]>(value: [])
    
    var output: Observable<State> {
        outputSubject
    }
    
    private var outputSubject = PublishSubject<State>()
    
    func input(_ action: Action) {
        switch action {
        case .imageWasSelected(let image):
            let imageList = self.imageList.value
            self.imageList.accept(imageList + [image])
            outputSubject.onNext(.updateImageList(self.imageList.value))
        case .tapDeleteImage(let indexPath):
            var imageList = self.imageList.value
            imageList.remove(at: indexPath.row)
            self.imageList.accept(imageList)
            outputSubject.onNext(.updateImageList(imageList))
        }
    }
}

