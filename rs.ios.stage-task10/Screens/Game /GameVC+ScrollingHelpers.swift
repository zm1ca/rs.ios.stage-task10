//
//  GameVC+ScrollingHelpers.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 27.08.21.
//

import UIKit

extension GameVC {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        currentPosition = (velocity.x == 0)
            ? Int(floor((targetContentOffset.pointee.x - UIConstants.pageWidth / 2) / UIConstants.pageWidth) + 1.0)
            : (velocity.x > 0 ? currentPosition + 1 : currentPosition - 1)
 
        targetContentOffset.pointee = CGPoint(x: CGFloat(currentPosition) * UIConstants.pageWidth,
                                              y: targetContentOffset.pointee.y)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        applyValueFromScoreBubble()
    }
    
    func scrollToCurrentPosition() {
        let newOffset = CGPoint(x: CGFloat(currentPosition) * UIConstants.singleCellOffset, y: 0)
        collectionView.setContentOffset(newOffset, animated: true)
    }
}
