//
//  singleLetterLabel.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 29.08.21.
//

import UIKit

class SingleLetterLabel: UILabel {
    
    convenience init(with name: String) {
        self.init(frame: .zero)
        text = name.first!.uppercased()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        font = UIFont(name: "Nunito-ExtraBold", size: 20)
        textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
