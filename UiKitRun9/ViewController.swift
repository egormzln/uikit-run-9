//
//  ViewController.swift
//  UiKitRun9
//
//  Created by Егор Мизюлин on 27.11.2024.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let collectionView: UICollectionView
    private let cellWidth: CGFloat = 200
    private let spacing: CGFloat = 16
    private let leftMargin: CGFloat = 20
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        setupNavBar()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: cellWidth, height: 350)
            layout.minimumLineSpacing = spacing
            layout.sectionInset = .init(top: 0, left: leftMargin, bottom: 0, right: leftMargin)
        }
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setupNavBar() {
        navigationItem.title = "Collection"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemBlue
        cell.layer.cornerRadius = 12
        return cell
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let _ = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let cellWidthWithSpacing = cellWidth + spacing
        let proposedOffset = targetContentOffset.pointee.x
        let targetIndex = round((proposedOffset - leftMargin) / cellWidthWithSpacing)
        
        let maxIndex = CGFloat(collectionView.numberOfItems(inSection: 0) - 1)
        let clampedIndex = max(0, min(maxIndex, targetIndex))
        
        let adjustedOffset = clampedIndex * cellWidthWithSpacing
        targetContentOffset.pointee = CGPoint(x: adjustedOffset, y: 0)
    }
}
