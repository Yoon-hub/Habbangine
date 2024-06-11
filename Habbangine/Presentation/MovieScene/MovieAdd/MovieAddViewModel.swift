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
    
    enum ErrorMessage: Error {
        case imageIsEmpty
        case titleIsEmpty
        case contentIsEmpty
    }
    
    enum Action {
        case imageWasSelected(UIImage)
        case tapDeleteImage(IndexPath)
        case tapSaveButton(String?, String?, Date)
    }

    enum State {
        case updateImageList([UIImage])
        case toastSaveInvalid(String)
    }
    
    struct Dependency {
        let movieDataService: MovieDataServiceProtocol
    }
    
    let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
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
        case .tapSaveButton(let title, let content, let date):
            checkSaveInvalid(title, content, date)
        default:
            break
        }
    }
}

extension MovieAddViewModel {
    
    private func checkSaveInvalid(_ title: String?, _ content: String?,_ date: Date) {
        guard !imageList.value.isEmpty else {
            outputSubject.onNext(.toastSaveInvalid(ErrorMessage.imageIsEmpty.errorDescription!))
            return
        }
        
        guard let title, !title.isEmpty else {
            outputSubject.onNext(.toastSaveInvalid(ErrorMessage.titleIsEmpty.errorDescription!))
            return
        }
        
        guard let content, !content.isEmpty else {
            outputSubject.onNext(.toastSaveInvalid(ErrorMessage.contentIsEmpty.errorDescription!))
            return
        }
        
        saveMovie(title, content, date)
    }
    
    private func saveMovie(_ title: String, _ content: String,_ date: Date) {
        let imageDatas: [Data] = imageList.value.compactMap { $0.jpegData(compressionQuality: 0.5) }
        
        let movie = MovieBuilder()
            .setImages(imageDatas)
            .setTitle(title)
            .setContent(content)
            .setDate(date)
            .build()
        
        Task {
            await self.dependency.movieDataService.insertMovie(movie: movie)
        }
    }
}


// MARK: - LocalizedError
extension MovieAddViewModel.ErrorMessage: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .imageIsEmpty:
            return NSLocalizedString("이미지가 없습니다.\n이미지를 추가해 주세요", comment: "")
        case .titleIsEmpty:
            return NSLocalizedString("제목이 없습니다.\n제목을 추가해 주세요", comment: "")
        case .contentIsEmpty:
            return NSLocalizedString("내용이 없습니다.\n내용을 추가해 주세요.", comment: "")
        }
    }
}
