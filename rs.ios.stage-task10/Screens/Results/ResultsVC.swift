//
//  ResultsVC.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 26.08.21.
//

import UIKit

class ResultsVC: UIViewController {
    
    weak var parentVC: GameVC!
    var playerScores: [(String, Int)]!
    var turns:        [(String, Int)]!
    
    let headerView = HeaderView(title: "Results",
                                leftBarButton: BarButton(title: "New Game"),
                                rightBarButton: BarButton(title: "Resume"))

    var tableView = UITableView(frame: .zero, style: .plain)
    let collectionView: UICollectionView = {
        let flowLayout                = UICollectionViewFlowLayout()
        flowLayout.sectionInset       = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        flowLayout.itemSize           = CGSize(width: UIScreen.main.bounds.width - 40, height: 150)
        flowLayout.minimumLineSpacing = 40
        flowLayout.scrollDirection    = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.register(RankingsCollectionCell.self, forCellWithReuseIdentifier: RankingsCollectionCell.reuseID)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .RSBackground
        cv.isScrollEnabled = true
        cv.isPagingEnabled = true
        return cv
    }()
    
    let pageControl = UIPageControl()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Results"
        view.backgroundColor      = .RSBackground
        pageControl.numberOfPages = (playerScores.count + 2) / 3
        pageControl.currentPage   = 0
        pageControl.isHidden      = (pageControl.numberOfPages < 2)
        collectionView.delegate   = self
        collectionView.dataSource = self
        configureBarButtons()
        configureTurnsTableView()
        layoutUI()
    }
    
    
    // MARK: - Configurations for Bar Buttons
    private func configureBarButtons() {
        headerView.leftBarButton?.addTarget(self, action: #selector(newGameButtonTapped), for: .touchUpInside)
        headerView.rightBarButton?.addTarget(self, action: #selector(resumeButtonTapped), for: .touchUpInside)
    }
    
    @objc private func newGameButtonTapped() {
        let newGameVC = NewGameVC()
        newGameVC.parentVC = parentVC
        navigationController?.pushViewController(newGameVC, animated: true)
    }
    
    @objc private func resumeButtonTapped() {
        dismiss(animated: true)
    }
    
    
    // MARK: - Layout
    private func layoutUI() {
        headerView.placeByDefault(at: view)
        view.addSubviews(collectionView, tableView, pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 18),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            collectionView.heightAnchor.constraint(equalToConstant: 150),
            
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
    
            tableView.topAnchor.constraint(equalTo: pageControl.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

}




