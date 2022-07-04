//
//  PostDetailCVLayout.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/05/18.
//

import UIKit

extension PostDetailVC {
    internal func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            if sectionNumber == 0 {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(UIScreen.main.bounds.width), heightDimension: .absolute(UIScreen.main.bounds.width))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.visibleItemsInvalidationHandler = { items, contentOffset, environment in
                    let currentPage = Int(max(0, round(contentOffset.x / environment.container.contentSize.width)))
                    self.pageControl.currentPage = currentPage
                }
                return section
            } else {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(315))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(315))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                let section = NSCollectionLayoutSection(group: group)
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(85))
                let header =
                NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: PostDetailUserHeader.className, alignment: .topLeading)
                section.boundarySupplementaryItems = [header]
                section.orthogonalScrollingBehavior = .none
                return section
            }
        }
    }
}
