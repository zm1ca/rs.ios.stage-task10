//
//  GameVC.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 26.08.21.
//

import UIKit

class GameVC: UIViewController {
    
    var currentPosition = 0
    
    var playerScores = [(name: String, score: Int)]()
    var turns        = [(String, Int)]()
    var timerIsOn = true
    
    private let generator = UINotificationFeedbackGenerator()
    let diceView = DiceView()
    
    let headerView = HeaderView(title: "Game",
                                leftBarButton: BarButton(title: "New Game"),
                                rightBarButton: BarButton(title: "Results"))
    
    let diceButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "dice_4"), for: .normal)
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(diceButtonTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let playPauseButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "play"), for: .normal)
        btn.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let undoButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "undo"), for: .normal)
        btn.addTarget(self, action: #selector(undoButtonTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.adjustsImageWhenHighlighted = false
        return btn
    }()
    
    let incrementButtons = [-10, -5, -1, +5, +10].map { IncrementButton(value: $0, fontSize: 25) }
    let plusOneButton    = IncrementButton(value: 1, fontSize: 40)
    
    let nextButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "next"), for: .normal)
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(scrollToNextPlayer), for: .touchUpInside)
        btn.adjustsImageWhenHighlighted = false
        return btn
    }()
    
    let previousButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "previous"), for: .normal)
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(scrollToPreviousPlayer), for: .touchUpInside)
        return btn
    }()
    
    let timeLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.text      = "00:00"
        lbl.font      = UIFont(name: "Nunito-ExtraBold", size: 28)
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
        cv.isScrollEnabled = false
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
        configureTargetsForIncrementButtons()
        layoutUI()
        updateArrowButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureButtonsAppearance()
    }
    
    
    //MARK: - Public
    func configure(with playerNames: [String]) {
        turns.removeAll()
        playerScores.removeAll()
        playerNames.forEach { playerScores.append(($0, 0)) }
        collectionView.reloadData()
    }
    
    
    // MARK: - Configurations for Buttons
    private func configureBarButtons() {
        headerView.leftBarButton?.addTarget(self, action: #selector(newGameButtonTapped), for: .touchUpInside)
        headerView.rightBarButton?.addTarget(self, action: #selector(resultsButtonTapped), for: .touchUpInside)
    }
    
    private func configureButtonsAppearance() {
        for button in incrementButtons {
            button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
            button.layer.cornerRadius = button.bounds.width / 2
        }
        plusOneButton.layer.cornerRadius = plusOneButton.bounds.width / 2
    }
    
    private func configureTargetsForIncrementButtons() {
        var buttons = incrementButtons
        buttons.append(plusOneButton)
        buttons.forEach {
            $0.addTarget(self, action: #selector(incrementButtonTapped), for: .touchUpInside)
        }
    }
    
    
    // MARK: - Action Methods
    @objc private func diceButtonTapped() {
        diceView.isHidden = false
        diceView.diceImageView.image = UIImage(named: "dice_\(Int.random(in: 1...6))")
        diceView.shakeDice()
        generator.notificationOccurred(.success)
    }
    
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
    
    @objc private func undoButtonTapped() {
        guard let turnToRevert = turns.popLast() else { return }
        currentPosition = playerScores.map { $0.0 }.firstIndex(of: turnToRevert.0) ?? 0
        playerScores[currentPosition].1 -= turnToRevert.1
        collectionView.reloadItems(at: [IndexPath(row: currentPosition, section: 0)])
        scrollToCurrentPosition()
    }
    
    @objc private func newGameButtonTapped() {
        let newGameVC      = NewGameVC()
        newGameVC.parentVC = self
        let navVC = UINavigationController(rootViewController: newGameVC)
        navVC.isNavigationBarHidden = true
        present(navVC, animated: true)
    }
    
    @objc private func resultsButtonTapped() {
        let resultsVC          = ResultsVC()
        resultsVC.parentVC     = self
        resultsVC.playerScores = playerScores.sorted { $0.score == $1.score ? ($0.name < $1.name) : ($0.score > $1.score) }
        
        resultsVC.turns        = turns
        let navVC = UINavigationController(rootViewController: resultsVC)
        navVC.isNavigationBarHidden = true
        present(navVC, animated: true)
    }
    
    @objc private func incrementButtonTapped(sender: IncrementButton) {
        let upd = (playerScores[currentPosition].name, playerScores[currentPosition].score + sender.value!)
        playerScores.remove(at: currentPosition)
        playerScores.insert(upd, at: currentPosition)
        collectionView.reloadItems(at: [IndexPath(row: currentPosition, section: 0)])
        turns.append((playerScores[currentPosition].name, sender.value!))
    }
    
    
    // MARK: - Layout
    private func layoutUI() {
        let stackView = incrementButtonsStackView()
        headerView.addSubviewAndConstraintByDefault(at: view)
        headerView.addSubviews(diceButton)
        
        view.addSubviews(timeLabel, collectionView, playPauseButton, undoButton, plusOneButton, stackView, nextButton, previousButton, diceView)
        diceView.pinToEdges(of: view)
        NSLayoutConstraint.activate([
            diceButton.heightAnchor.constraint(equalToConstant: 30),
            diceButton.widthAnchor.constraint(equalToConstant: 30),
            diceButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            diceButton.centerYAnchor.constraint(equalTo: headerView.titleLabel.centerYAnchor),
            
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
            
            nextButton.heightAnchor.constraint(equalToConstant: 30),
            nextButton.widthAnchor.constraint(equalTo: nextButton.heightAnchor),
            nextButton.centerYAnchor.constraint(equalTo: plusOneButton.centerYAnchor),
            nextButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            
            previousButton.heightAnchor.constraint(equalToConstant: 30),
            previousButton.widthAnchor.constraint(equalTo: previousButton.heightAnchor),
            previousButton.centerYAnchor.constraint(equalTo: plusOneButton.centerYAnchor),
            previousButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: plusOneButton.topAnchor, constant: -28),
            collectionView.heightAnchor.constraint(equalToConstant: 300),
            
            timeLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12), //fix: place between safe area and top of collection view
            timeLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
    
    private func incrementButtonsStackView() -> UIStackView {
        let sv = UIStackView(arrangedSubviews: incrementButtons)
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis         = .horizontal
        sv.spacing      = 15
        return sv
    }

}
