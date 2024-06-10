//
//  File.swift
//  Habbangine
//
//  Created by 윤제 on 6/7/24.
//

import UIKit
import PhotosUI

import RxSwift
import RxCocoa
import RxRelay
import RxKeyboard

final class MovieAddViewController: CommonViewController<MovieAddViewModel> {
    
    let movieAddView: MovieAddView
    
    let imagePicker = UIImagePickerController()
    
    init(movieAddView: MovieAddView, viewModel: MovieAddViewModel) {
        self.movieAddView = movieAddView
        super.init(viewModel: viewModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func loadView() {
        self.view = movieAddView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func set() {
        super.set()
        bind()
        collectionViewBind()
        keyboardBind()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func setNavigationBar() {
        let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    override func handleOutput(_ state: MovieAddViewModel.State) {
        super.handleOutput(state)
        
        switch state {
        case .updateImageList(let array):
            print("이미지 업데이트")
        case .toastSaveInvalid(let errorMessage):
            showAlert(title: "오류", cotent: errorMessage)
        }
    }
}

// MARK: - RxBinding
extension MovieAddViewController {
    private func bind() {
        movieAddView.imagePlusButton.rx.tap
            .bind { [weak self] in
                self?.openPhotoLibrary()
            }
            .disposed(by: disposeBag)
        
        
        // TextView PlaceHolder
        movieAddView.contentTextView.rx.didBeginEditing
            .bind { [weak self] in
                guard let self else {return}
                if self.movieAddView.contentTextView.text == self.movieAddView.textViewPlaceHolderText {
                    self.movieAddView.contentTextView.text = ""
                    self.movieAddView.contentTextView.textColor = .black
                }
                
            }
            .disposed(by: disposeBag)
        
        movieAddView.contentTextView.rx.didEndEditing
            .bind { [weak self] in
                guard let self else {return}
                
                if self.movieAddView.contentTextView.text == "" {
                    self.movieAddView.contentTextView.text = self.movieAddView.textViewPlaceHolderText
                    self.movieAddView.contentTextView.textColor = .systemGray3
                }
            }
            .disposed(by: disposeBag)
        
        // Save Button Tap
        self.navigationItem.rightBarButtonItem?.rx.tap
            .withUnretained(self) // self를 유지하고 함께 사용
            .map { vc, _ in
                return (vc.movieAddView.titleTextField.text, vc.movieAddView.contentTextView.text)
            }
            .bind { [weak self] title, content in
                guard let self = self else { return }
                self.viewModel.input(.tapSaveButton(title, content))
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - CollectionView
extension MovieAddViewController {
    private func collectionViewBind() {
        viewModel.imageList
            .bind(to: movieAddView.imageCollectionView.rx.items(cellIdentifier: "ImageListCollectionViewCell", cellType: ImageListCollectionViewCell.self)) { index, item, cell in
                cell.bind(image: item)
            }
            .disposed(by: disposeBag)
        
        movieAddView.imageCollectionView.rx.itemSelected
            .bind { [weak self] indexPath in
                self?.viewModel.input(.tapDeleteImage(indexPath))
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Gallery
extension MovieAddViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        for result in results {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                    if let image = image as? UIImage {
                        DispatchQueue.main.async {
                            self?.viewModel.input(.imageWasSelected(image))
                        }
                    }
                }
            }
        }
    }
    
    // 갤러리 열기
    func openPhotoLibrary() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images // 이미지만 선택 가능
        configuration.selectionLimit = 7 // 0은 무제한 선택 가능
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
}

// MARK: - Keyboard
extension MovieAddViewController {
    
    private func keyboardBind() {
        RxKeyboard.instance.visibleHeight
            .drive { [weak self] keyBoardHeight in
                guard let self else { return }
                self.movieAddView.keyBoardActive(keyBoardHeight: keyBoardHeight)
            }
            .disposed(by: disposeBag)
    }
    
    
}
