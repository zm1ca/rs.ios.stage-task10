//
//  IncrementButton.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 26.08.21.
//

import UIKit

class IncrementButton: UIButton {
    
    var value: Int!
    
    convenience init(value: Int, fontSize: CGFloat) {
        self.init(frame: .zero)
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.RSShadow
        shadow.shadowOffset = CGSize(width: 0, height: 2)
        
        self.value = value
        let title  = (value <= 0) ? "\(value)" : "+\(value)"
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                NSAttributedString.Key.font: UIFont(name: "Nunito-ExtraBold", size: fontSize)!,
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.shadow: shadow
            ]
        )
        setAttributedTitle(attributedTitle, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .RSGreen
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
