//
//  NewGameVC+PlayerAaddable.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 29.08.21.
//

import UIKit

extension NewGameVC: PlayerAddable {
    func addPlayer(named name: String) {
        playerNames.append(name)
        view.setNeedsLayout()
        tableView.reloadData()
        startButton.isEnabled = true
        startButton.alpha     = 1
    }
}
