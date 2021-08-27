//
//  BarButton.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 27.08.21.
//

import UIKit

class BarButton: UIButton {
    
    convenience init(title: String) {
        self.init(frame: .zero)
        titleLabel?.font = UIFont(name: "Nunito-ExtraBold", size: 17)
        let states: [UIControl.State] = [.normal, .disabled, .highlighted]
        for state in states {
            setTitle(title, for: state)
            setTitleColor(.RSGreen, for: state)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
