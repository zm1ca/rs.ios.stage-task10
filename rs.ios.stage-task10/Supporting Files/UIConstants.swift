//
//  UIConstants.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 29.08.21.
//

import UIKit

struct UIConstants {
    static let screenWidth:      CGFloat = UIScreen.main.bounds.width
    static let screenHeight:     CGFloat = UIScreen.main.bounds.height
    static let playerCellHeight: CGFloat = screenHeight * 0.35
    static let playerCellWidth:  CGFloat = playerCellHeight * 0.83
    static let sideInset:        CGFloat = (screenWidth - playerCellWidth) / 2
    static let singleCellOffset: CGFloat = playerCellWidth + 20
}
