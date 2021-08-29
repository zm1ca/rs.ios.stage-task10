//
//  GameVC+CollectionView.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 27.08.21.
//

import UIKit

extension GameVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlayerScoreCell.reuseID, for: indexPath) as! PlayerScoreCell
        cell.set(with: playerScores[indexPath.row].0, and: playerScores[indexPath.row].1)
        
        let previousSwipe = UISwipeGestureRecognizer(target: self, action: #selector(scrollToPrevPlayer))
        let nextSwipe     = UISwipeGestureRecognizer(target: self, action: #selector(scrollToNextPlayer))
        
        previousSwipe.direction = .right
        nextSwipe.direction     = .left
        
        cell.addGestureRecognizer(previousSwipe)
        cell.addGestureRecognizer(nextSwipe)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        playerScores.count
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        _ = reachedLeftBorder()
        _ = reachedRightBorder()
        updateArrowButtons()
    }
}
