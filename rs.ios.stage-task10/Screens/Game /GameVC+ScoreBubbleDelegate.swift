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
        guard value != 0 else { return }
        playerScores[currentPosition].score += value
        collectionView.reloadItems(at: [IndexPath(row: currentPosition, section: 0)])
        turns.append(Turn(name: playerScores[currentPosition].name, position: currentPosition, score: value))
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}

