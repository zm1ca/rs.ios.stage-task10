//
//  GameVC.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 26.08.21.
//

import UIKit

class GameVC: UIViewController {
    
    var currentPosition = 0 {
        didSet {
            updateNavStackViewOffset()
            timerView.reset()
            centralizeNavScrollView()
        }
    }
    var playerScores    = [(name: String, score: Int)]()
    var turns           = [(name: String, position: Int, score: Int)]()
    let generator       = UINotificationFeedbackGenerator()
    
    
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
    
    let navStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis      = .horizontal
        sv.spacing   = 5
        sv.alignment = .center
        sv.distribution = .equalCentering
        return sv
    }()
    
    let scrollView = UIScrollView()

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
        
        configureButtonTargets()
        configureTargetsForIncrementButtons()
        layoutUI()
        updateArrowButtons()
        timerView.reset()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        #warning("Most of calls are excessive. Consider changing placement.")
        centralizeNavScrollView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureButtonsAppearance()
    }
    
    
    //MARK: - API
    func setUpNewGame(with playerNames: [String]) {
        currentPosition = 0
        scrollToCurrentPosition()
        timerView.reset()
        turns.removeAll()
        playerScores.removeAll()
        playerNames.forEach { playerScores.append(($0, 0)) }
        collectionView.reloadData()
        populateNavScrollView()
    }
    
    private func populateNavScrollView() {
        for view in navStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        for name in playerScores.map({ $0.name }) {
            let label = SingleLetterLabel(with: name)
            self.navStackView.addArrangedSubview(label)
            label.widthAnchor.constraint(equalToConstant: 20).isActive = true
        }
        updateNavStackViewOffset()
    }
    
    func updateNavStackViewOffset() {
        for index in 0..<playerScores.map({ $0.name }).count {
            let label = self.navStackView.arrangedSubviews[index] as! SingleLetterLabel
            label.textColor = (index == currentPosition) ? .RSSelectedWhite : .RSTable
        }
    }
    
    
    // MARK: - Configurations for Buttons
    private func configureButtonTargets() {
        headerView.leftBarButton?.addTarget(self, action: #selector(newGameButtonTapped), for: .touchUpInside)
        headerView.rightBarButton?.addTarget(self, action: #selector(resultsButtonTapped), for: .touchUpInside)
        diceButton.addTarget(self, action: #selector(diceButtonTapped),   for: .touchUpInside)
        undoButton.addTarget(self, action: #selector(undoButtonTapped),   for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(scrollToNextPlayer), for: .touchUpInside)
        prevButton.addTarget(self, action: #selector(scrollToPrevPlayer), for: .touchUpInside)
    }
    
    private func configureButtonsAppearance() {
        for button in scoreButtons {
            button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
            button.layer.cornerRadius = button.bounds.width / 2
        }
        plusOneButton.layer.cornerRadius = plusOneButton.bounds.width / 2
    }
    
    private func configureTargetsForIncrementButtons() {
        var buttons = scoreButtons
        buttons.append(plusOneButton)
        buttons.forEach {
            $0.addTarget(self, action: #selector(incrementButtonTapped), for: .touchUpInside)
        }
    }
    
    
    // MARK: - Action Methods
    @objc private func diceButtonTapped() {
        let diceView = DiceView()
        view.addSubview(diceView)
        diceView.pinToEdges(of: view)
        diceView.diceImageView.image = UIImage(named: "dice_\(Int.random(in: 1...6))")
        diceView.shakeDice()
        generator.notificationOccurred(.success)
    }
    
    @objc private func undoButtonTapped() {
        guard let turnToRevert = turns.popLast() else { return }
        currentPosition = turnToRevert.position
        playerScores[currentPosition].score -= turnToRevert.score
        collectionView.reloadItems(at: [IndexPath(row: currentPosition, section: 0)])
        scrollToCurrentPosition()
    }
    
    @objc private func newGameButtonTapped() {
        let newGameVC      = NewGameVC()
        newGameVC.parentVC = self
        newGameVC.playerNames = playerScores.map { $0.name }
        let navVC = UINavigationController(rootViewController: newGameVC)
        navVC.isNavigationBarHidden = true
        present(navVC, animated: true)
    }
    
    @objc private func resultsButtonTapped() {
        guard turns.count != 0 else { presentAlert(); return }
        
        let resultsVC          = ResultsVC()
        resultsVC.parentVC     = self
        resultsVC.playerScores = playerScores.sorted { $0.score == $1.score ? ($0.name < $1.name) : ($0.score > $1.score) }
        
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
        let upd = (playerScores[currentPosition].name, playerScores[currentPosition].score + sender.value!)
        playerScores.remove(at: currentPosition)
        playerScores.insert(upd, at: currentPosition)
        collectionView.reloadItems(at: [IndexPath(row: currentPosition, section: 0)])
        turns.append((playerScores[currentPosition].name, currentPosition, sender.value!))
    }
    
    private func centralizeNavScrollView() {
        let scrollViewCenter = (scrollView.bounds.width - 15) / 2
        scrollView.setContentOffset(CGPoint(x: currentPosition * 25 - Int(scrollViewCenter), y: 0), animated: true)
    }
    
    
    // MARK: - Layout
    private func layoutUI() {
        let buttonsStackView = incrementButtonsStackView()
        headerView.placeByDefault(at: view)
        headerView.addSubviews(diceButton)
        view.addSubviews(scrollView, timerView, collectionView, undoButton, navStackView, plusOneButton, buttonsStackView, nextButton, prevButton)
        configureNavStackView()
        
        NSLayoutConstraint.activate([
            diceButton.heightAnchor.constraint(equalToConstant: 30),
            diceButton.widthAnchor.constraint(equalToConstant: 30),
            diceButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            diceButton.centerYAnchor.constraint(equalTo: headerView.titleLabel.centerYAnchor),
            
            undoButton.heightAnchor.constraint(equalToConstant: 20),
            undoButton.widthAnchor.constraint(equalToConstant: 15),
            undoButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            undoButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            
            scrollView.heightAnchor.constraint(equalToConstant: 30),
            scrollView.centerYAnchor.constraint(equalTo: undoButton.centerYAnchor, constant: 3),
            scrollView.leadingAnchor.constraint(equalTo: undoButton.trailingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -74),
            
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
        ])
    }
    
    private func configureNavStackView() {
        scrollView.addSubview(navStackView)
        navStackView.pinToEdges(of: scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = false
    }
    
    private func incrementButtonsStackView() -> UIStackView {
        let sv = UIStackView(arrangedSubviews: scoreButtons)
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis    = .horizontal
        sv.spacing = 15
        return sv
    }
}
