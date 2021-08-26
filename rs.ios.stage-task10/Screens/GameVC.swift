//
//  GameVC.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 26.08.21.
//

import UIKit

class GameVC: UIViewController {
    
    var playerScores = [(String, Int)]()
    
    let timeLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Nunito-ExtraBold", size: 28)
        lbl.textColor = .white
        lbl.text = "00:00"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let collectionView: UICollectionView = {
        let flowLayout                = UICollectionViewFlowLayout()
        flowLayout.sectionInset       = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 60)
        flowLayout.itemSize           = CGSize(width: UIScreen.main.bounds.width - 120, height: 300)
        flowLayout.minimumLineSpacing = 20
        flowLayout.scrollDirection    = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.register(PlayerScoreCell.self, forCellWithReuseIdentifier: PlayerScoreCell.reuseID)
        cv.backgroundColor = .RSBackground
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Game"
        view.backgroundColor = .RSBackground
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        configureBarButtons()
        layoutUI()
    }
    
    
    //MARK: - Public
    func configure(with playerNames: [String]) {
        playerScores.removeAll()
        for name in playerNames {
            playerScores.append((name, 0))
        }
    }
    
    
    // MARK: - Configurations for Bar Buttons
    private func configureBarButtons() {
        let backButton = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(newGameButtonTapped))
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.leftBarButtonItem = backButton
        
        let resultsButton = UIBarButtonItem(title: "Results", style: .plain, target: self, action: #selector(resultsButtonTapped))
        self.navigationItem.rightBarButtonItem = resultsButton
    }
    
    @objc private func newGameButtonTapped() {
        let newGameVC      = NewGameVC()
        newGameVC.parentVC = self
        let navVC = UINavigationController(rootViewController: newGameVC)
        present(navVC, animated: true)
    }
    
    @objc private func resultsButtonTapped() {
        let resultsVC      = ResultsVC()
        resultsVC.parentVC = self
        let navVC = UINavigationController(rootViewController: resultsVC)
        present(navVC, animated: true)
    }
    
    
    // MARK: - Configurations
    private func layoutUI() {
        view.addSubview(timeLabel)
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 29),
            timeLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 40),
            collectionView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }

}

// MARK: - Collection View Delegate and Data Source
extension GameVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlayerScoreCell.reuseID, for: indexPath) as! PlayerScoreCell
        cell.set(with: playerScores[indexPath.row].0, and: playerScores[indexPath.row].1)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        playerScores.count
    }
}
