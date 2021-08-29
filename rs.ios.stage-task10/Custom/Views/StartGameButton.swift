//
//  StartGameButton.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 29.08.21.
//

import UIKit

class StartGameButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .RSGreen
        layer.cornerRadius = 65 / 2
        layer.masksToBounds = false
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.RSShadow
        shadow.shadowOffset = CGSize(width: 0, height: 2)
        
        let attributedTitle = NSAttributedString(
            string: "Start Game",
            attributes: [
                NSAttributedString.Key.font: UIFont(name: "Nunito-ExtraBold", size: 24)!,
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.shadow: shadow
            ]
        )
        setAttributedTitle(attributedTitle, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.shadowOpacity = 1
        layer.shadowRadius  = 0
        layer.shadowColor   = UIColor.RSShadow.cgColor
        layer.shadowOffset  = CGSize(width: 0, height: 5)
    }

}
