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
    
    var tableView = UITableView(frame: .zero, style: .plain)

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Results"
        view.backgroundColor = .RSBackground
        configureBarButtons()
        configureTableView()
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
    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.register(RankingsCell.self, forCellReuseIdentifier: RankingsCell.reuseID)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .RSBackground
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
    }
    
    private func layoutUI() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(tableView.numberOfRows(inSection: 0) * 50)),
        ])
    }

}


extension ResultsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        playerScores.count < 3 ? playerScores.count : 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RankingsCell.reuseID, for: indexPath) as! RankingsCell
        let playerName = playerScores[indexPath.row].0
        let score      = playerScores[indexPath.row].1
        cell.set(rank: indexPath.row + 1, for: playerName, with: score)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
}




