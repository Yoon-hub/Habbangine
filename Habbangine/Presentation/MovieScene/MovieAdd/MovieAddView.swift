//
//  MovieAddView.swift
//  Habbangine
//
//  Created by 윤제 on 6/7/24.
//

import UIKit

import PinLayout

final class MovieAddView: UIView {
    
    let imageCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        
        layout.itemSize = CGSize(width: 72, height: 72)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageListCollectionViewCell.self, forCellWithReuseIdentifier: "ImageListCollectionViewCell")
        return collectionView
    }()
    
    let imagePlusButton = UIButton().then {
        $0.tintColor = .systemGray4
        $0.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray5.cgColor
        $0.layer.cornerRadius = 10
    }
    
    let titleTextField = UITextField().then {
        $0.placeholder = "title"
    }
    
    let datePicker = UIDatePicker(frame: .zero).then {
        $0.datePickerMode = .date
    }
    
    let contentTextField = UITextView().then {
        $0.font = UIFont.systemFont(ofSize: 15)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        set()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configure()
    }
    
    private func set() {
        [imagePlusButton, imageCollectionView, titleTextField, datePicker, contentTextField].forEach { self.addSubview($0) }
    }
    
    private func configure() {
        
        imagePlusButton.pin
            .top(104)
            .left(16)
            .size(68)
        
        imageCollectionView.pin
            .vCenter(to: imagePlusButton.edge.vCenter)
            .after(of: imagePlusButton)
            .marginLeft(16)
            .right(16)
            .height(104)
        
        datePicker.pin
            .below(of: imageCollectionView)
            .marginTop(24)
            .right(16)
            .height(40)
            .width(78)
        
        titleTextField.pin
            .below(of: imageCollectionView)
            .before(of: datePicker)
            .marginTop(24)
            .marginRight(12)
            .left(16)
            .height(40)
        
        contentTextField.pin
            .below(of: titleTextField)
            .marginTop(16)
            .horizontally(16)
            .bottom(16)
        
    }
}
