//
//  DiceView.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 27.08.21.
//

import UIKit

class DiceView: UIView {
    
    let diceImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideView))
        addGestureRecognizer(tap)
        configureBlurEffect()
        layoutUI()
    }
    
    @objc private func hideView() {
        isHidden = true
    }
    
    private func configureBlurEffect() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.9
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
    
    private func layoutUI() {
        diceImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(diceImageView)
        NSLayoutConstraint.activate([
            diceImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            diceImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            diceImageView.widthAnchor.constraint(equalToConstant: 120),
            diceImageView.heightAnchor.constraint(equalTo: diceImageView.widthAnchor),
        ])
    }
    
    func shakeDice() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.3
        animation.values = [-15.0, 15.0, -7.5, 7.5, -2.5, 2.5, 0]
        diceImageView.layer.add(animation, forKey: "shake")
    }
}
