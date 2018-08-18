//
//  ViewController.swift
//  Project 01 Stopwatch
//
//  Created by Chris on 16/8/2018.
//  Copyright © 2018 Chris. All rights reserved.
//

import UIKit

class StopWatchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var stopWatch = StopWatch.init()
    private var stopWatchState = StopWatchState.stop
    private var mainTimeLabelTimer: Timer?

    //MARK: Bind view
    @IBOutlet private weak var lapButton: UIButton!{
        didSet{
            lapButton.layer.borderWidth = 2.0
            lapButton.layer.cornerRadius = 6
        }
    }
    @IBOutlet private weak var startButton: UIButton!{
        didSet{
            startButton.layer.borderWidth = 2.0
            startButton.layer.cornerRadius = 6
            startButton.layer.borderColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        }
    }
    @IBOutlet private weak var resetButton: UIButton!{
        didSet{
            resetButton.layer.borderWidth = 2.0
            resetButton.layer.cornerRadius = 6
        }
    }
    @IBOutlet private weak var lapTimeTableView: UITableView!{
        didSet{
            lapTimeTableView.delegate = self
            lapTimeTableView.dataSource = self
        }
    }
    @IBOutlet weak var mainTimeLabel: UILabel!
    @IBOutlet weak var lapTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableLapButton(enable: false)
        enableResetButton(enable: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        mainTimeLabelTimer?.invalidate()
    }
    
    //MARK: Update Time Label
    @objc func updateTimeLabel(){
        let timeInMillis = stopWatch.timeIntervalInMillisSinceStart
        mainTimeLabel.text = "\(timeInMillis.formatMinuteForStopWatch):\(timeInMillis.formatSecondForStopWatch):\(timeInMillis.formatMillisSecondForStopWatch)"
        let lapTimeInMillis = stopWatch.timeIntervalInMillisSinceLap
        lapTimeLabel.text = "\(lapTimeInMillis.formatMinuteForStopWatch):\(lapTimeInMillis.formatSecondForStopWatch):\(lapTimeInMillis.formatMillisSecondForStopWatch)"
        if timeInMillis >= 5999920{
            resetPress(resetButton)
        }
    }
    
    
    //MARK: Button Action
    
    @IBAction private func startPress(_ sender: Any) {
        switch stopWatchState {
        case .playing:
            stopWatch.pauseStopWatch()
            startButton.setTitle("Resume", for: .normal)
            stopWatchState = .pause
            mainTimeLabelTimer?.invalidate()
        case .pause:
            stopWatch.resumeStopWatch()
            startButton.setTitle("Pause", for: .normal)
            stopWatchState = .playing
            mainTimeLabelTimer = Timer.scheduledTimer(timeInterval: 0.07, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
            RunLoop.current.add(mainTimeLabelTimer!, forMode: RunLoopMode.commonModes)
        case .stop:
            enableLapButton(enable: true)
            enableResetButton(enable: true)
            stopWatch.startStopWatch()
            startButton.setTitle("Pause", for: .normal)
            stopWatchState = .playing
            lapTimeTableView.reloadData()
            mainTimeLabelTimer = Timer.scheduledTimer(timeInterval: 0.07, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
            RunLoop.current.add(mainTimeLabelTimer!, forMode: RunLoopMode.commonModes)
        }
    }
    
    @IBAction private func resetPress(_ sender: Any) {
        stopWatch.resetStopWatch()
        stopWatchState = .stop
        startButton.setTitle("Start", for: .normal)
        enableLapButton(enable: false)
        enableResetButton(enable: false)
        mainTimeLabelTimer?.invalidate()
        updateTimeLabel()
    }
    
    @IBAction private func lapPress(_ sender: Any) {
        stopWatch.lap()
        let lapCount = stopWatch.lapsTimeInMillis.count
        lapTimeTableView.insertRows(at: [IndexPath(row: lapCount-1, section: 0)], with: .automatic)
    }
    
    //MARK: Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stopWatch.lapsTimeInMillis.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lapCell", for: indexPath)
        if let cell = cell as? LapTableViewCell{
            let timeInMillis = stopWatch.lapsTimeInMillis[indexPath.row]
            cell.time.text = "\(timeInMillis.formatMinuteForStopWatch):\(timeInMillis.formatSecondForStopWatch):\(timeInMillis.formatMillisSecondForStopWatch)"
            cell.title.text = "Lap \(indexPath.row)"
        }
        return cell
    }

    //MARK: Button UI
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
    
    private func enableLapButton(enable: Bool){
        lapButton.isEnabled = enable
        var color: CGColor
        if enable {
            color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            color = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        lapButton.setTitleColor(UIColor(cgColor: color), for: .normal)
        lapButton.layer.borderColor = color
    }
}

extension Int{
    var formatMillisSecondForStopWatch: String{
        return String(format: "%02d", Int(self/10)%100)
    }
    var formatSecondForStopWatch: String{
        return String(format: "%02d", Int(self/1000)%60)
    }
    var formatMinuteForStopWatch: String{
        return String(format: "%02d", Int(self/60000))
    }
}
