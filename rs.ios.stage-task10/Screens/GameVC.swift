//
//  GameVC.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 26.08.21.
//

import UIKit

class GameVC: UIViewController {
    
    var playerScores = [(String, Int)]()
    var timerIsOn = true
    
    let diceButton: UIButton = {
        let btn = UIButton()
        //btn.backgroundColor = .systemPink
        btn.setImage(UIImage(named: "dice_4"), for: .normal)
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(diceButtonTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    @objc private func diceButtonTapped() {
        print("Dice!")
    }
    
    let playPauseButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "play"), for: .normal)
        btn.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }() //button is too small. consiger tap gestire recognizer on time label
    
    @objc private func playPauseButtonTapped() {
        timerIsOn.toggle()
        if timerIsOn {
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            timeLabel.textColor = .white
        } else {
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            timeLabel.textColor = .RSTable
        }
    }
    
    let undoButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "undo"), for: .normal)
        btn.addTarget(self, action: #selector(undoButtonTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let incrementButtons = [-10, -5, -1, +5, +10].map { IncrementButton(value: $0, fontSize: 25) }
    let plusOneButton    = IncrementButton(value: 1, fontSize: 40)
    
    @objc private func undoButtonTapped() {
        print("undo")
    }
    
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
        collectionView.reloadData()
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
        let resultsVC          = ResultsVC()
        resultsVC.parentVC     = self
        resultsVC.playerScores = playerScores
        let navVC = UINavigationController(rootViewController: resultsVC)
        present(navVC, animated: true)
    }
    
    
    // MARK: - Configurations
    private func layoutUI() {
        navigationController?.navigationBar.addSubview(diceButton)
        view.addSubview(timeLabel)
        view.addSubview(collectionView)
        view.addSubview(playPauseButton)
        view.addSubview(undoButton) //add in one line via EXTENSION
        view.addSubview(plusOneButton)
        
        let stackView = UIStackView(arrangedSubviews: incrementButtons)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis         = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing      = 15
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            diceButton.heightAnchor.constraint(equalToConstant: 30),
            diceButton.widthAnchor.constraint(equalToConstant: 30),
            diceButton.trailingAnchor.constraint(equalTo: navigationController!.navigationBar.trailingAnchor, constant: -20),
            diceButton.centerYAnchor.constraint(equalTo: navigationController!.navigationBar.bottomAnchor, constant: -26),
            
            playPauseButton.heightAnchor.constraint(equalToConstant: 20),
            playPauseButton.widthAnchor.constraint(equalToConstant: 20),
            playPauseButton.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            playPauseButton.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 20),
            
            undoButton.heightAnchor.constraint(equalToConstant: 20),
            undoButton.widthAnchor.constraint(equalToConstant: 15),
            undoButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            undoButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            
            stackView.bottomAnchor.constraint(equalTo: undoButton.topAnchor, constant: -22),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            plusOneButton.heightAnchor.constraint(equalToConstant: 90),
            plusOneButton.widthAnchor.constraint(equalToConstant: 90),
            plusOneButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            plusOneButton.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -20),
            
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: plusOneButton.topAnchor, constant: -28),
            collectionView.heightAnchor.constraint(equalToConstant: 300),
            
            timeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12), //fix: place between safe area and top of collection view
            timeLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ])
        
        for button in incrementButtons {
            button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
            button.layer.cornerRadius = (UIScreen.main.bounds.width - 100) / 10 //crutch
        }
        plusOneButton.layer.cornerRadius = 45
        
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
