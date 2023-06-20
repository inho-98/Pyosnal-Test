//
//  ProductsViewController.swift
//  PyonsnalTest
//
//  Created by 김인호 on 2023/06/17.
//

import UIKit

final class ProductsViewController: UIViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, String>
    
    enum Section {
        case main
    }
    
    private var dataSource: DataSource?
    private let mockProducts: [String] = [1,2,3,4,5,6,7,8,9,0,11,12,13,14,15,16].map { String($0) }
    
    private(set) lazy var productCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: configureCollectionViewLayout()
        )
//        collectionView.delegate = self
        collectionView.register(
            ProductCell.self,
            forCellWithReuseIdentifier: ProductCell.identifier
        )
        collectionView.backgroundColor = .gray
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
        configureDataSource()
        applySnapshot()
    }
    
    private func configureLayout() {
        view.addSubview(productCollectionView)
        
        productCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(171), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(235))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(16)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
//        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 20, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    //applySnapshot, configureDataSource()
    private func configureDataSource() {
        dataSource = DataSource(collectionView: productCollectionView) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProductCell.identifier,
                for: indexPath
            ) as? ProductCell else {
                return UICollectionViewCell()
            }
            
            return cell
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(mockProducts)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func toggleScrollable() {
        productCollectionView.isScrollEnabled = !productCollectionView.isScrollEnabled
    }
}

extension ProductsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
