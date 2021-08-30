//
//  GameVC+ScoreBubbleDelegate.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 29.08.21.
//

import UIKit

extension GameVC: ScoreBubbleDelegate {
    
    func applyValueFromScoreBubble() {
        if scoreBubble.isPresented {
            let lastValue = scoreBubble.reset()
            updateCurrentPlayerCell(with: lastValue)
        }
    }
    
    func switchTurn(adding value: Int) {
        updateCurrentPlayerCell(with: value)
        currentPosition += 1
    }
    
    func updateCurrentPlayerCell(with value: Int) {
        let newPlayerScore = (playerScores[currentPosition].name, playerScores[currentPosition].score + value)
        playerScores.remove(at: currentPosition)
        playerScores.insert(newPlayerScore, at: currentPosition)
        collectionView.reloadItems(at: [IndexPath(row: currentPosition, section: 0)])
        turns.append((playerScores[currentPosition].name, currentPosition, value))
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}

