//
//  TimerView.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 29.08.21.
//

import UIKit

class TimerView: UIView {
    
    private var timer = Timer()
    var startTime: TimeInterval?
    var pauseTime: TimeInterval?
    
    //MARK: Views
    private let timeLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.text      = "00:00"
        lbl.font      = UIFont(name: "Nunito-ExtraBold", size: 28)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let playPauseButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "play"), for: .normal)
        btn.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    
    //MARK: API
    func start() {
        guard !timer.isValid else { return }
        playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        timeLabel.textColor = .white
        timer = Timer.scheduledTimer(timeInterval: 0.01,
                                     target: self,
                                     selector: #selector(updateTimeLabel),
                                     userInfo: nil,
                                     repeats: true)
        
        if startTime != nil {
            if let pauseTime = pauseTime {
                self.startTime! += (Date.timeIntervalSinceReferenceDate - pauseTime)
            }
        } else {
            self.startTime = Date.timeIntervalSinceReferenceDate
        }
    }
    
    func pause() {
        guard timer.isValid else { return }
        timer.invalidate()
        
        playPauseButton.setImage(UIImage(named: "play"), for: .normal)
        timeLabel.textColor = .RSTable
        pauseTime = Date.timeIntervalSinceReferenceDate
    }
    
    func reset() {
        startTime = nil
        pauseTime = nil
        timer.invalidate()
    }
    

    
    //MARK: Initizalization
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Action Methods
    @objc private func playPauseButtonTapped() {
        if timer.isValid {
            pause()
        } else {
            start()
        }
    }
    
    @objc private func updateTimeLabel() {
        guard let startTime = startTime else { return }
        let currentTime = Date.timeIntervalSinceReferenceDate
        let elapsedTime: TimeInterval = currentTime - startTime
        
        let minutes = Int(elapsedTime / 60.0) //int to drop miliseconds
        let seconds = Int(elapsedTime - TimeInterval(minutes) * 60)
        
        let minutesString = String(format: "%02d", minutes)
        let secondsString = String(format: "%02d", seconds)
        timeLabel.text = "\(minutesString):\(secondsString)"
    }
    
    
    //MARK: Layout
    private func layoutUI() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(timeLabel, playPauseButton)
        NSLayoutConstraint.activate([
            timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            playPauseButton.heightAnchor.constraint(equalToConstant: 20),
            playPauseButton.widthAnchor.constraint(equalToConstant: 20),
            playPauseButton.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            playPauseButton.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 20),
        ])
    }
}
