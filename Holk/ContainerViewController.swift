//
//  ContainerViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2020-05-11.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
//    var collectionView = UICollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()

        let sections = [Self.makeHintSection()]
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) in
            return sections[sectionIndex]
        }

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            view.topAnchor.constraint(equalTo: collectionView.topAnchor),
            view.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
        ])
    }

    private static func makeHintSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//        group.interItemSpacing = .fixed(8)
        let hintSection = NSCollectionLayoutSection(group: group)
        hintSection.orthogonalScrollingBehavior = .groupPaging
//        hintSection.interGroupSpacing = 8
//        hintSection.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
        return hintSection
    }
}

extension ContainerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let colors = [UIColor.green, UIColor.blue, UIColor.red]
        cell.backgroundColor = colors[indexPath.item]
        return cell
    }
}
