//
//  AppHomeViewController.swift
//  PyonsnalTest
//
//  Created by 김인호 on 2023/06/04.
//

import ModernRIBs
import UIKit

protocol AppHomePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class AppHomeViewController: UIViewController, AppHomePresentable, AppHomeViewControllable {
    
    weak var listener: AppHomePresentableListener?
    private let images: [String] = ["전체.fill", "CU", "GS25", "이마트24", "7eleven"]
    private let mockProducts: [String] = Array(repeating: "", count: 30)
    private var innerScrollLastOffsetY: CGFloat = 0
    private var currentPage: Int = 0 {
        didSet {
            bindPage(from: oldValue, to: currentPage)
        }
    }
    
    private let containerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.layoutMargins = .init(top: 11, left: 16, bottom: 11, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "차별화 상품 둘러보기"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()

    private let alertButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(.init(named: "on"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private lazy var shopNavigationCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: configureCollectionViewLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            ShopNavigationCollectionViewCell.self,
            forCellWithReuseIdentifier: ShopNavigationCollectionViewCell.identifier
        )
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        
        return collectionView
    }()
    
    private let pageViewController: PageViewController = .init(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPageViewController()
        configureLayout()
        configurePageViewController()
        currentPage = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func bindPage(from oldValue: Int, to newValue: Int) {
        let direction: UIPageViewController.NavigationDirection = oldValue < newValue ? .forward : .reverse
        
        pageViewController.changeViewController(
            index: newValue,
            direction: direction,
            animated: true
        )
        
        shopNavigationCollectionView.selectItem(
            at: IndexPath(item: currentPage, section: 0),
            animated: true,
            scrollPosition: .centeredHorizontally
        )
    }

    private func setupPageViewController() {
        containerScrollView.delegate = self
    }
    
    private func configureLayout() {
        view.addSubview(containerScrollView)
        containerScrollView.addSubview(contentView)
        contentView.addSubview(headerStackView)
        contentView.addSubview(shopNavigationCollectionView)

        headerStackView.addArrangedSubview(headerLabel)
        headerStackView.addArrangedSubview(alertButton)
        
        let contentViewHeight = contentView.heightAnchor.constraint(equalTo: containerScrollView.frameLayoutGuide.heightAnchor)
        contentViewHeight.isActive = true
        contentViewHeight.priority = .defaultLow

        NSLayoutConstraint.activate([
            containerScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: containerScrollView.widthAnchor),
            contentView.leadingAnchor.constraint(equalTo: containerScrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: containerScrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: containerScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: containerScrollView.bottomAnchor),
            
            headerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerStackView.topAnchor.constraint(equalTo: contentView.topAnchor),

            alertButton.heightAnchor.constraint(equalTo: headerLabel.heightAnchor),

            shopNavigationCollectionView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor),
            shopNavigationCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            shopNavigationCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            shopNavigationCollectionView.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    private func configurePageViewController() {
        addChild(pageViewController)
        contentView.addSubview(pageViewController.view)
        
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: shopNavigationCollectionView.bottomAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        pageViewController.didMove(toParent: self)
        pageViewController.viewControllers?
            .compactMap({ $0 as? ProductsViewController })
            .forEach { [weak self] in
                $0.productCollectionView.delegate = self
            }
        pageViewController.pageDelegate = self
    }
    
    private func setupViews() {
        tabBarItem = UITabBarItem(
            title: "홈",
            image: .init(named: "홈"),
            selectedImage: .init(named: "홈.fill")
        )
        
        view.backgroundColor = .systemGray6
        view.backgroundColor = .init(red: 245/255, green: 245/255, blue: 245/255, alpha: 0)
    }
    
    private func configureCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        return layout
    }
    
    private func configureProductCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(top: 12, left: 16, bottom: 0, right: 16)
        
        return layout
    }
}

//MARK: - UICollectionViewDataSource
extension AppHomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ShopNavigationCollectionViewCell.identifier,
            for: indexPath
        ) as? ShopNavigationCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.setupButtonImage(images[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == shopNavigationCollectionView {
            currentPage = indexPath.item
        }
    }

}

//MARK: - UICollectionViewDelegateFlowLayout
extension AppHomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let imageSize: CGSize = UIImage(named: images[indexPath.row])!.size
        
        return imageSize
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        let itemSizes = ImageKind.allCases.reduce(CGFloat(0)) { partialResult, imageKind in
            partialResult + imageKind.image!.size.width
        }
        let result = (collectionView.frame.width - itemSizes) / CGFloat(images.count - 1)
        
        return result
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
        
    }
}

//MARK: - UICollectionViewDelegate
extension AppHomeViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = pageViewController.currentViewController?.productCollectionView else { return }
        
        let outerScroll = scrollView == containerScrollView
        let innerScroll = !outerScroll
        let downScroll = scrollView.panGestureRecognizer.translation(in: scrollView).y < 0
        let upScroll = !downScroll
        let outerScrollMaxOffset = headerStackView.frame.height
        
        print(collectionView.contentOffset.y)
        
        if innerScroll && upScroll {
            //안쪽을 위로 스크롤할때 바깥쪽 스크롤뷰의 contentOffset을 0으로 줄이기
            guard containerScrollView.contentOffset.y > 0 else { return }
            
            let maxOffsetY = max(containerScrollView.contentOffset.y - (innerScrollLastOffsetY - scrollView.contentOffset.y), 0)
            print("바깥 스크롤뷰: \(containerScrollView.contentOffset.y), 안쪽 마지막:\(innerScrollLastOffsetY), 안쪽 오프셋:\(scrollView.contentOffset.y)")
            let offsetY = min(maxOffsetY, outerScrollMaxOffset)
            print("maxOffset: \(maxOffsetY), offsetY: \(offsetY)")
            
            containerScrollView.contentOffset.y = offsetY
            collectionView.contentOffset.y = innerScrollLastOffsetY
        }
        
        if innerScroll && downScroll {
            //안쪽을 아래로 스크롤할때 바깥쪽 먼저 아래로 스크롤
            guard containerScrollView.contentOffset.y < outerScrollMaxOffset else { return }
  
            let minOffsetY = min(containerScrollView.contentOffset.y + scrollView.contentOffset.y - innerScrollLastOffsetY ,outerScrollMaxOffset)
            let offsetY = max(minOffsetY, 0)
            
            containerScrollView.contentOffset.y = offsetY
            collectionView.contentOffset.y = innerScrollLastOffsetY
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView != containerScrollView {
            innerScrollLastOffsetY = scrollView.contentOffset.y
            print("lastOffset: \(innerScrollLastOffsetY)")
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView != containerScrollView {
            innerScrollLastOffsetY = scrollView.contentOffset.y
            print("lastOffset: \(innerScrollLastOffsetY)")
        }
    }
}

extension AppHomeViewController: PageViewControllerDelegate {
    func didChangePage(_ viewController: ProductsViewController) {
        viewController.productCollectionView.delegate = self
        innerScrollLastOffsetY = viewController.productCollectionView.contentOffset.y
        
    }
}

enum ImageKind: String, CaseIterable {
    case cu = "CU"
    case gs25 = "GS25"
    case sevenEleven = "7eleven"
    case emart24 = "이마트24"
    case all = "전체"

    var image: UIImage? {
        return .init(named: rawValue)
    }
    
    var selectedImage: UIImage? {
        return .init(named: "\(rawValue).fill")
    }
    
    var index: Int {
        switch self {
        case .all:
            return 0
        case .cu:
            return 1
        case .gs25:
            return 2
        case .emart24:
            return 3
        case .sevenEleven:
            return 4
        }
    }
}
