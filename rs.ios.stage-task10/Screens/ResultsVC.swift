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
        let backButton = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(newGameButtonTapped))
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.leftBarButtonItem = backButton
        
        let resumeButton = UIBarButtonItem(title: "Resume", style: .plain, target: self, action: #selector(resumeButtonTapped))
        self.navigationItem.rightBarButtonItem = resumeButton
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
    
    private func layoutUI() {
        view.addSubview(rankingsTableView)
        view.addSubview(turnsTableView)
        NSLayoutConstraint.activate([
            rankingsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
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


extension ResultsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == rankingsTableView {
            return playerScores.count < 3 ? playerScores.count : 3
        } else {
            return turns.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == rankingsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: RankingsCell.reuseID, for: indexPath) as! RankingsCell
            let playerName = playerScores[indexPath.row].0
            let score      = playerScores[indexPath.row].1
            cell.set(rank: indexPath.row + 1, for: playerName, with: score)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TurnCell.reuseID, for: indexPath) as! TurnCell
            let playerName = turns[indexPath.row].0
            let score      = turns[indexPath.row].1
            cell.set(name: playerName, score: score)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
}




