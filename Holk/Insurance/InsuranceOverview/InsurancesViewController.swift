//
//  InsurancesViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-11.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

final class InsurancesViewController: UIViewController {
    // MARK: - Public variables
    var storeController: StoreController

    weak var coordinator: InsuranceCoordinator?
    // MARK: - Private variables
    private enum Section: Int, CaseIterable {
        case insurance
        case addMore
    }
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    private let layout = DynamicHeightCollectionFlowLayout()
    private let pageControl = UIPageControl()

    init(storeController: StoreController) {
        self.storeController = storeController

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var numberOfInsurances = 2
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .clear
        view.layoutMargins = .zero

        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        pageControl.numberOfPages = numberOfInsurances + 1
        pageControl.currentPageIndicatorTintColor = Color.mainForegroundColor
        pageControl.pageIndicatorTintColor = Color.secondaryBackgroundColor
        pageControl.translatesAutoresizingMaskIntoConstraints = false

        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.register(InsuranceCollectionViewCell.self, forCellWithReuseIdentifier: InsuranceCollectionViewCell.identifier)
        collectionView.register(InsuranceAddMoreCell.self, forCellWithReuseIdentifier: InsuranceAddMoreCell.identifier)

        view.addSubview(collectionView)
        view.addSubview(pageControl)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),

            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension InsurancesViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case Section.insurance.rawValue: return numberOfInsurances
        case Section.addMore.rawValue: return 1
        default: return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
                case Section.insurance.rawValue:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                        InsuranceCollectionViewCell.identifier, for: indexPath)
                    // TODO: Configure this
                    if let insuranceTableViewCell = cell as? InsuranceCollectionViewCell {
        //                insuranceTableViewCell.configureCell(pro)
                    }
                    return cell
                case Section.addMore.rawValue:
                    return collectionView.dequeueReusableCell(withReuseIdentifier:
                    InsuranceAddMoreCell.identifier, for: indexPath)
                default:
                    return UICollectionViewCell()
                }
    }

    
}

extension InsurancesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case Section.addMore.rawValue:
            numberOfInsurances += 1
            pageControl.numberOfPages = numberOfInsurances + 1
            pageControl.currentPage = 0
            collectionView.reloadData()
        case Section.insurance.rawValue:
            let insurance = Insurance(id: "1", insuranceProvider: "1", insuranceType: "1", issuerReference: "", ssn: "", startDate: Date(), endDate: Date(), username: "")
            coordinator?.showInsurnaceDetail(insurance)
        default:
            return
        }
    }

    // TODO: Update this
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewCenter = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))

        if let indexPath = collectionView.indexPathForItem(at: scrollViewCenter) {
            switch indexPath.section {
            case Section.addMore.rawValue:
                pageControl.currentPage = numberOfInsurances + 1
            default:
                pageControl.currentPage = indexPath.item
            }
        }
    }
}
