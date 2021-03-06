//
//  GameVC.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 26.08.21.
//

import UIKit

class GameVC: UIViewController {
    
    var currentPosition = 0 {
        willSet { applyValueFromScoreBubble() }
        didSet  { updateUI() }
    }
    var playerScores = [PlayerScore]()
    var turns        = [Turn]()
    
    var playerNames: [String] {
        playerScores.map({ $0.name })
    }
    
    
    //MARK: Views
    let headerView = HeaderView(title: "Game",
                                leftBarButton: BarButton(title: "New Game"),
                                rightBarButton: BarButton(title: "Results"))
    let timerView     = TimerView()
    let diceButton    = RSButton(imageName: "dice_4")
    let undoButton    = RSButton(imageName: "undo")
    let nextButton    = RSButton(imageName: "next")
    let prevButton    = RSButton(imageName: "previous")
    let scoreButtons  = [-10, -5, -1, +5, +10].map { IncrementButton(value: $0, fontSize: 25) }
    let plusOneButton = IncrementButton(value: 1, fontSize: 40)
    let scoreBubble   = ScoreBubble()
    let minibar       = MinibarScrollView()

    let collectionView: UICollectionView = {
        let flowLayout                = UICollectionViewFlowLayout()
        flowLayout.sectionInset       = UIEdgeInsets(top: 0, left: UIConstants.sideInset, bottom: 0, right: UIConstants.sideInset)
        flowLayout.itemSize           = CGSize(width: UIConstants.playerCellWidth, height: UIConstants.playerCellHeight)
        flowLayout.minimumLineSpacing = 20
        flowLayout.scrollDirection    = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.register(PlayerScoreCell.self, forCellWithReuseIdentifier: PlayerScoreCell.reuseID)
        cv.backgroundColor = .RSBackground
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isPagingEnabled = false
        return cv
    }()

    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Game"
        view.backgroundColor = .RSBackground
        
        collectionView.delegate   = self
        collectionView.dataSource = self
        scoreBubble.delegate      = self
        
        configureButtonTargets()
        configureTargetsForIncrementButtons()
        layoutUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveData), name: .applicationWillResignActive, object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        minibar.focus(at: currentPosition)
        scrollToCurrentPosition()
        
        if !flag {
            flag = true
            timerView.reset()
            timerView.startTime = startTime
            timerView.pauseTime = pauseTime
            timerView.start()
        }
    }
    
    
    //MARK: - API
    func setUpNewGame(with playerNames: [String]) {
        currentPosition = 0
        timerView.reset()
        timerView.start()
        turns.removeAll()
        playerScores.removeAll()
        playerNames.forEach { playerScores.append(PlayerScore(name: $0, score: 0)) }
        collectionView.reloadData()
        minibar.resetNavScrollView(with: playerNames)
    }
    
    //Damn crutch
    var startTime: TimeInterval?
    var pauseTime: TimeInterval?
    var flag = false
    
    func loadGame(from gameState: GameState) {
        currentPosition     = gameState.currentPosition
        playerScores        = gameState.playerScores
        turns               = gameState.turns
        
        //Damn crutch
        startTime = gameState.startTime
        pauseTime = gameState.pauseTime

        collectionView.reloadData()
        let playerNames = playerScores.map { $0.name }
        minibar.resetNavScrollView(with: playerNames)
        minibar.updateAppearance(for: playerNames, focusedOn: currentPosition)
    }
    
    @objc private func saveData() {
        timerView.pause()
        let state = GameState(playerScores: playerScores,
                              turns: turns,
                              currentPosition: currentPosition,
                              startTime: timerView.startTime,
                              pauseTime: timerView.pauseTime)
        if let data = try? JSONEncoder().encode(state) {
            UserDefaults.standard.set(data, forKey: "PlayerScores")
        }
    }
    
    
    // MARK: Buttons Configuration
    private func configureButtonTargets() {
        headerView.leftBarButton?.addTarget(self, action: #selector(newGameButtonTapped), for: .touchUpInside)
        headerView.rightBarButton?.addTarget(self, action: #selector(resultsButtonTapped), for: .touchUpInside)
        diceButton.addTarget(self, action: #selector(diceButtonTapped), for: .touchUpInside)
        undoButton.addTarget(self, action: #selector(undoButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(arrowButtonTapped),   for: .touchUpInside)
        prevButton.addTarget(self, action: #selector(arrowButtonTapped),   for: .touchUpInside)
    }
    
    private func configureTargetsForIncrementButtons() {
        var buttons = scoreButtons
        buttons.append(plusOneButton)
        buttons.forEach {
            $0.addTarget(self, action: #selector(incrementButtonTapped), for: .touchUpInside)
        }
    }
    
    private func incrementButtonsStackView() -> UIStackView {
        let sv = UIStackView(arrangedSubviews: scoreButtons)
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis    = .horizontal
        sv.spacing = 15
        return sv
    }
    
    // MARK: - Action Methods
    @objc private func diceButtonTapped() {
        applyValueFromScoreBubble()
        let diceView = DiceView()
        view.addSubview(diceView)
        diceView.pinToEdges(of: view)
        diceView.diceImageView.image = UIImage(named: "dice_\(Int.random(in: 1...6))")
        diceView.shakeDice()
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    @objc private func undoButtonTapped() {
        guard !scoreBubble.isPresented else {
            _ = scoreBubble.reset()
            return
        }

        guard let turnToRevert = turns.popLast() else { return }
        currentPosition = turnToRevert.position
        playerScores[currentPosition].score -= turnToRevert.score
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        collectionView.reloadItems(at: [IndexPath(row: currentPosition, section: 0)])
    }
    
    @objc private func newGameButtonTapped() {
        applyValueFromScoreBubble()
        let newGameVC = NewGameVC()
        newGameVC.playerNames = playerScores.map { $0.name }
        let navVC = UINavigationController(rootViewController: newGameVC)
        navVC.isNavigationBarHidden = true
        present(navVC, animated: true)
    }
    
    @objc private func resultsButtonTapped() {
        applyValueFromScoreBubble()
        guard turns.count != 0 else { presentAlert(); return }
        
        let resultsVC          = ResultsVC()
        resultsVC.playerScores = playerScores
        
        resultsVC.turns        = turns
        let navVC = UINavigationController(rootViewController: resultsVC)
        navVC.isNavigationBarHidden = true
        present(navVC, animated: true)
    }
    
    private func presentAlert() {
        let alertVC = UIAlertController(title: "Nothing to present! 🙄", message: "Results will be computed after at least one turn registered.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Fair enough 👌", style: .cancel) {_ in
            self.dismiss(animated: true)
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
    
    @objc private func incrementButtonTapped(sender: IncrementButton) {
        scoreBubble.addValue(sender.value!)
    }
    
    @objc func arrowButtonTapped(sender: RSButton) {
        currentPosition = sender.imageName!.starts(with: "next")
            ? currentPosition + 1
            : currentPosition - 1
    }
    
    
    //MARK: Update UI
    private func updateUI() {
        adjustCurrentPositionToFitBorders()
        minibar.updateAppearance(for: playerNames, focusedOn: currentPosition)
        updateArrowButtonsAppearance()
        scrollToCurrentPosition()
        
        timerView.reset()
        timerView.start()
    }
    
    private func adjustCurrentPositionToFitBorders() {
        guard playerScores.count > 1 else { return }

        let lastPage = playerScores.count - 1
        if currentPosition < 0 {
            currentPosition = lastPage
        } else if (currentPosition > lastPage) {
            currentPosition = 0
        }
    }
    
    private func updateArrowButtonsAppearance() {
        let nextButtonImageName = (currentPosition == playerScores.count - 1) ? "next_last" : "next"
        nextButton.setImage(UIImage(named: nextButtonImageName), for: .normal)

        let previousButtonImageName = (currentPosition == 0) ? "previous_last" : "previous"
        prevButton.setImage(UIImage(named: previousButtonImageName), for: .normal)
    }
    
    
    // MARK: - Layout
    private func layoutUI() {
        let buttonsStackView = incrementButtonsStackView()
        headerView.placeByDefault(at: view)
        headerView.addSubviews(diceButton)
        view.addSubviews(minibar, timerView, collectionView, undoButton, plusOneButton, buttonsStackView, nextButton, prevButton, scoreBubble)
        
        NSLayoutConstraint.activate([
            diceButton.heightAnchor.constraint(equalToConstant: 30),
            diceButton.widthAnchor.constraint(equalToConstant: 30),
            diceButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            diceButton.centerYAnchor.constraint(equalTo: headerView.titleLabel.centerYAnchor),
            
            undoButton.heightAnchor.constraint(equalToConstant: 30),
            undoButton.widthAnchor.constraint(equalToConstant: 30),
            undoButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            undoButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            
            minibar.heightAnchor.constraint(equalToConstant: 30),
            minibar.centerYAnchor.constraint(equalTo: undoButton.centerYAnchor, constant: 3),
            minibar.leadingAnchor.constraint(equalTo: undoButton.trailingAnchor, constant: 16),
            minibar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -74),
            
            buttonsStackView.bottomAnchor.constraint(equalTo: undoButton.topAnchor, constant: -22),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            plusOneButton.heightAnchor.constraint(equalToConstant: 90),
            plusOneButton.widthAnchor.constraint(equalToConstant: 90),
            plusOneButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            plusOneButton.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -20),
            
            nextButton.heightAnchor.constraint(equalToConstant: 30),
            nextButton.widthAnchor.constraint(equalTo: nextButton.heightAnchor),
            nextButton.centerYAnchor.constraint(equalTo: plusOneButton.centerYAnchor),
            nextButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            
            prevButton.heightAnchor.constraint(equalToConstant: 30),
            prevButton.widthAnchor.constraint(equalTo: prevButton.heightAnchor),
            prevButton.centerYAnchor.constraint(equalTo: plusOneButton.centerYAnchor),
            prevButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: plusOneButton.topAnchor, constant: -28),
            collectionView.heightAnchor.constraint(equalToConstant: UIConstants.playerCellHeight),
            
            timerView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -16),
            timerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            timerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            timerView.heightAnchor.constraint(equalToConstant: 25),
            
            scoreBubble.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(UIConstants.sideInset + 16)),
            scoreBubble.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            scoreBubble.widthAnchor.constraint(equalToConstant: UIConstants.playerCellWidth * 0.3)
        ])
    }
}
