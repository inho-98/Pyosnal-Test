//
//  ShopNavigationCollectionViewCell.swift
//  PyonsnalTest
//
//  Created by 김인호 on 2023/06/17.
//

import UIKit

final class ShopNavigationCollectionViewCell: UICollectionViewCell {
    static let identifier: String = .init(describing: ShopNavigationCollectionViewCell.self)
    
    private let shopButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        contentView.addSubview(shopButton)
        
        NSLayoutConstraint.activate([
            shopButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            shopButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            shopButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            shopButton.topAnchor.constraint(equalTo: contentView.topAnchor),
        ])
    }
    
    func setupButtonImage(_ image: String) {
        shopButton.setImage(.init(named: "\(image)"), for: .normal)
        shopButton.setImage(.init(named: "\(image).fill"), for: .selected)
    }
}
