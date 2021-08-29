//
//  GameVC+ScoreBubbleDelegate.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 29.08.21.
//

import UIKit

extension GameVC: ScoreBubbleDelegate {
    
    func switchTurn(adding value: Int) {
        updateCurrentPlayerCell(with: value)
        scrollToNextPlayer(sender: UIButton())
    }
    
    func updateCurrentPlayerCell(with value: Int) {
        let newPlayerScore = (playerScores[currentPosition].name, playerScores[currentPosition].score + value)
        playerScores.remove(at: currentPosition)
        playerScores.insert(newPlayerScore, at: currentPosition)
        collectionView.reloadItems(at: [IndexPath(row: currentPosition, section: 0)])
        turns.append((playerScores[currentPosition].name, currentPosition, value))
    }
}

