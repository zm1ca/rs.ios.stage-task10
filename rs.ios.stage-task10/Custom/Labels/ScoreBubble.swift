//
//  ScoreBubbleLabel.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 29.08.21.
//

import UIKit

protocol ScoreBubbleDelegate {
    func switchTurn(adding value: Int)
}

class ScoreBubble: UILabel {
    
    var isPresented   = false
    private var value = 0
    private var timer = Timer()
    
    var delegate: ScoreBubbleDelegate!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heightAnchor.constraint(equalTo: widthAnchor).isActive = true
        layer.cornerRadius = layer.frame.height / 2
        clipsToBounds = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        alpha           = 0
        backgroundColor = .RSBackground
        font            = UIFont(name: "Nunito-ExtraBold", size: 25)
        textColor       = .RSSelectedWhite
        textAlignment   = .center
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addValue(_ increment: Int) {
        isPresented = true
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0.85
        }
        
        timer.invalidate()
                
        value += increment
        if value > 0 {
            text = "+\(value)"
        } else {
            text = "\(value)"
        }

        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(applyScoreAndReset), userInfo: nil, repeats: false)
    }
    
    @objc private func applyScoreAndReset() {
        isPresented = false
        delegate.switchTurn(adding: value)
        _ = reset()
    }
    
    func reset() -> Int {
        isPresented   = false
        let lastValue = value
        value = 0
        timer.invalidate()
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
        }
        return lastValue
    }
    
    
}
