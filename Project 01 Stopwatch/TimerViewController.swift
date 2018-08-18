//
//  TimerViewController.swift
//  Project 01 Stopwatch
//
//  Created by Chris on 16/8/2018.
//  Copyright © 2018 Chris. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    private var countDownTimer = StopWatch.init()
    private var timer: Timer?
    private var timeToCountDown = 0
    private var timerState = StopWatchState.stop
    
    // MARK bind view
    @IBOutlet weak var timeSelection: UIStackView!
    @IBOutlet weak var startButton: UIButton!{
        didSet{
            startButton.layer.borderWidth = 2.0
            startButton.layer.cornerRadius = 6
            startButton.layer.borderColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        }
    }
    @IBOutlet weak var resetButton: UIButton!{
        didSet{
            resetButton.layer.borderWidth = 2.0
            resetButton.layer.cornerRadius = 6
        }
    }
    private func enableResetButton(enable: Bool){
        resetButton.isEnabled = enable
        var color: CGColor
        if enable {
            color = #colorLiteral(red: 1, green: 0.1273401127, blue: 0, alpha: 1)
        } else {
            color = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        resetButton.setTitleColor(UIColor(cgColor: color), for: .normal)
        resetButton.layer.borderColor = color
    }
    @IBOutlet weak var minutePicker: UIPickerView!{
        didSet{
            minutePicker.dataSource = self
            minutePicker.delegate = self
        }
    }
    @IBOutlet weak var secondPicker: UIPickerView!{
        didSet{
            secondPicker.dataSource = self
            secondPicker.delegate = self
        }
    }
    @IBOutlet weak var timeLabel: UILabel!
    
    //MARK: Picker Data Source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == minutePicker || pickerView == secondPicker{
            return 1
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == minutePicker {
            return 100
        } else if pickerView == secondPicker {
            return 60
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == minutePicker || pickerView == secondPicker{
            return String(row)
        } else {
            return nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableResetButton(enable: false)
    }
    
    @IBAction func startPress(_ sender: Any) {
        switch timerState {
        case .playing:
            timerState = .pause
            startButton.setTitle("Resume", for: .normal)
            countDownTimer.pauseStopWatch()
            timer?.invalidate()
        case .stop:
            timeToCountDown = minutePicker.selectedRow(inComponent: 0)*60000 + secondPicker.selectedRow(inComponent: 0)*1000
            timeSelection.isHidden = true
            timeLabel.isHidden = false
            enableResetButton(enable: true)
            countDownTimer.startStopWatch()
            timer = Timer.scheduledTimer(timeInterval: 0.07, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
            startButton.setTitle("Pause", for: .normal)
            timerState = .playing
        case .pause:
            timerState = .playing
            startButton.setTitle("Pause", for: .normal)
            countDownTimer.resumeStopWatch()
            timer = Timer.scheduledTimer(timeInterval: 0.07, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
        }
    }
    
    @IBAction func resetPress(_ sender: Any) {
        timerState = .stop
        timeSelection.isHidden = false
        timeLabel.isHidden = true
        enableResetButton(enable: false)
        timeToCountDown = 0
        countDownTimer.resetStopWatch()
        timer?.invalidate()
        startButton.setTitle("Start", for: .normal)
    }
    
    @objc func updateTimeLabel(){
        let remainingTimeInMillis = timeToCountDown - countDownTimer.timeIntervalInMillisSinceStart
        if remainingTimeInMillis < 0 {
            timer?.invalidate()
            timeLabel.text = "00:00:00"
        } else {
            timeLabel.text = "\(remainingTimeInMillis.formatMinuteForStopWatch):\(remainingTimeInMillis.formatSecondForStopWatch):\(remainingTimeInMillis.formatMillisSecondForStopWatch)"
        }
    }
    
}
