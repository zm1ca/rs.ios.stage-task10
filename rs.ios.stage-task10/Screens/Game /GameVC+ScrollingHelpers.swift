//
//  GameVC+ScrollingHelpers.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 27.08.21.
//

import UIKit

extension GameVC {
    
    //MARK: - Scrolling
    @objc func scrollToNextPlayer(sender: Any) {
        currentPosition += 1
        let condition = (sender is UIButton) ? !reachedRightBorder() : true
        scrollToCurrentPosition(if: condition)
    }
    
    @objc func scrollToPreviousPlayer(sender: Any) {
        currentPosition -= 1
        let condition = (sender is UIButton) ? !reachedLeftBorder() : true
        scrollToCurrentPosition(if: condition)
    }
    
    private func scrollToCurrentPosition(if condition: Bool) {
        if condition { scrollToCurrentPosition() }
        updateArrowButtons()
    }
    
    func scrollToCurrentPosition() {
        let newOffset = CGPoint(x: CGFloat(currentPosition) * (UIScreen.main.bounds.width - 100), y: 0)
        collectionView.setContentOffset(newOffset, animated: true)
        timerView.reset()
    }
    
    
    //MARK: - Update UI
    func updateArrowButtons() {
        let nextButtonImageName = (currentPosition == playerScores.count - 1) ? "next_last" : "next"
        nextButton.setImage(UIImage(named: nextButtonImageName), for: .normal)

        let previousButtonImageName = (currentPosition == 0) ? "previous_last" : "previous"
        previousButton.setImage(UIImage(named: previousButtonImageName), for: .normal)
    }
    
    
    // MARK: - Reached borders
    func reachedRightBorder() -> Bool {
        if currentPosition > playerScores.count - 1 {
            currentPosition = 0
            collectionView.setContentOffset(CGPoint(x: CGFloat(currentPosition) * (UIScreen.main.bounds.width - 100), y: 0), animated: true)
            return true
        }
        return false
    }
    
    func reachedLeftBorder() -> Bool {
        if currentPosition < 0 {
            currentPosition = playerScores.count - 1
            collectionView.setContentOffset(CGPoint(x: CGFloat(currentPosition) * (UIScreen.main.bounds.width - 100), y: 0), animated: true)
            return true
        }
        return false
    }
}
