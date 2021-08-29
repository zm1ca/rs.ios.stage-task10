//
//  ResultsVC+TableView.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 27.08.21.
//

import UIKit

extension ResultsVC: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Configurations
    func configureTurnsTableView() {
        tableView.register(TurnCell.self,   forCellReuseIdentifier: TurnCell.reuseID)
        tableView.register(HeaderCell.self, forCellReuseIdentifier: HeaderCell.reuseID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate           = self
        tableView.dataSource         = self
        tableView.tableFooterView    = UIView()
        tableView.backgroundColor    = .RSTable
        tableView.layer.cornerRadius = 15
        tableView.separatorColor     = .RSSeparator
        tableView.allowsSelection    = false
    }
    
    //MARK: Delegaate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        turns.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return configuredHeaderCell(for: tableView, at: indexPath)
        } else {
            return configuredTurnCell(for: tableView, at: indexPath)
        }
    }
    
    private func configuredHeaderCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HeaderCell.reuseID, for: indexPath) as! HeaderCell
        cell.set(title: "Turns")
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cell.bounds.size.width * 2)
        return cell
    }
    
    private func configuredTurnCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TurnCell.reuseID, for: indexPath) as! TurnCell
        let playerName = turns[indexPath.row - 1].0
        let score      = turns[indexPath.row - 1].1
        cell.set(name: playerName, score: score)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        54
    }
    
}
