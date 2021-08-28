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
    var turns: [(String, Int)]!
    
    let headerView = HeaderView(title: "Results",
                                leftBarButton: BarButton(title: "New Game"),
                                rightBarButton: BarButton(title: "Resume"))
    
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
    
    
    // MARK: - Configurations
    private func configureRankingsTableView() {
        rankingsTableView.register(RankingsCell.self, forCellReuseIdentifier: RankingsCell.reuseID)
        rankingsTableView.translatesAutoresizingMaskIntoConstraints = false
        rankingsTableView.delegate        = self
        rankingsTableView.dataSource      = self
        rankingsTableView.tableFooterView = UIView()
        rankingsTableView.backgroundColor = .RSBackground
        rankingsTableView.separatorStyle  = .none
        rankingsTableView.isScrollEnabled = false
        rankingsTableView.allowsSelection = false
    }
    
    private func configureTurnsTableView() {
        turnsTableView.register(TurnCell.self, forCellReuseIdentifier: TurnCell.reuseID)
        turnsTableView.translatesAutoresizingMaskIntoConstraints = false
        turnsTableView.delegate           = self
        turnsTableView.dataSource         = self
        turnsTableView.tableFooterView    = UIView()
        turnsTableView.backgroundColor    = .RSTable
        turnsTableView.layer.cornerRadius = 15
        turnsTableView.separatorColor     = .RSSeparator
        turnsTableView.allowsSelection    = false
    }
    
    
    // MARK: - Layout
    private func layoutUI() {
        headerView.addSubviewAndConstraintByDefault(at: view)
        view.addSubviews(rankingsTableView, turnsTableView)
        NSLayoutConstraint.activate([
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




