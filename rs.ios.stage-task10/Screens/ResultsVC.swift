//
//  ResultsVC.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 26.08.21.
//

import UIKit

class ResultsVC: UIViewController {
    
    weak var parentVC: GameVC?
    var playerScores: [(String, Int)]!
    var turns: [(String, Int)] = [("Tim", 20), ("Mike", 0), ("Joshua", -9), ("Ciryll", -12), ("Ann", 19), ("Tracy", 4), ("Nancy", -14), ("Craig", 8), ("Nancy", 14), ("Craig", 8)]
    
    let headerView = HeaderView(title: "Results")
    let newGameButton = BarButton(title: "New Game")
    let resumeButton  = BarButton(title: "Resume")
    
    var rankingsTableView = UITableView(frame: .zero, style: .plain)
    var turnsTableView    = UITableView(frame: .zero, style: .plain)

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Results"
        view.backgroundColor = .RSBackground
        configureBarButtons()
        configureRankingsTableView()
        configureTurnsTableView()
        layoutUI()
    }
    
    
    // MARK: - Configurations for Bar Buttons
    private func configureBarButtons() {
        newGameButton.addTarget(self, action: #selector(newGameButtonTapped), for: .touchUpInside)
        resumeButton.addTarget(self, action: #selector(resumeButtonTapped), for: .touchUpInside)
    }
    
    @objc private func newGameButtonTapped() {
        let newGameVC = NewGameVC()
        newGameVC.parentVC = parentVC
        navigationController?.pushViewController(newGameVC, animated: true)
    }
    
    @objc private func resumeButtonTapped() {
        dismiss(animated: true)
    }
    
    
    // MARK: - Configurations
    private func configureRankingsTableView() {
        rankingsTableView.translatesAutoresizingMaskIntoConstraints = false
        rankingsTableView.delegate   = self
        rankingsTableView.dataSource = self
        rankingsTableView.register(RankingsCell.self, forCellReuseIdentifier: RankingsCell.reuseID)
        rankingsTableView.tableFooterView = UIView()
        rankingsTableView.backgroundColor = .RSBackground
        rankingsTableView.separatorStyle = .none
        rankingsTableView.isScrollEnabled = false
        rankingsTableView.allowsSelection = false
    }
    
    private func configureTurnsTableView() {
        turnsTableView.translatesAutoresizingMaskIntoConstraints = false
        turnsTableView.delegate   = self
        turnsTableView.dataSource = self
        turnsTableView.register(TurnCell.self, forCellReuseIdentifier: TurnCell.reuseID)
        turnsTableView.tableFooterView = UIView()
        turnsTableView.backgroundColor = .RSTable
        turnsTableView.layer.cornerRadius = 15
        turnsTableView.separatorColor = .RSSeparator
    }
    
    
    // MARK: - Layout
    private func layoutUI() {
        view.addSubview(headerView)
        headerView.addSubview(newGameButton)
        headerView.addSubview(resumeButton)
        view.addSubview(rankingsTableView)
        view.addSubview(turnsTableView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            headerView.heightAnchor.constraint(equalToConstant: 90),

            newGameButton.bottomAnchor.constraint(equalTo: headerView.titleLabel.topAnchor, constant: -12),
            newGameButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            
            resumeButton.bottomAnchor.constraint(equalTo: headerView.titleLabel.topAnchor, constant: -12),
            resumeButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            
            rankingsTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 18),
            rankingsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            rankingsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            rankingsTableView.heightAnchor.constraint(equalToConstant: CGFloat(rankingsTableView.numberOfRows(inSection: 0) * 50)),
            
            turnsTableView.topAnchor.constraint(equalTo: rankingsTableView.bottomAnchor, constant: 25),
            turnsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            turnsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            turnsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

}




