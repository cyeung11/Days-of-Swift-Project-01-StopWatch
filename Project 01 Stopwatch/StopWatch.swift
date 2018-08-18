//
//  StopWatch.swift
//  Project 01 Stopwatch
//
//  Created by Chris on 16/8/2018.
//  Copyright © 2018 Chris. All rights reserved.
//

import Foundation

struct StopWatch {
    var lapsTimeInMillis: [Int]
    private var startTime: Date?
    private var lapTime: Date?
    private var pauseTimeIntervalSinceStart: TimeInterval?
    private var pauseTimeIntervalSinceLap: TimeInterval?
    private var isPaused = false
    var timeIntervalInMillisSinceStart: Int{
        if let startTime = startTime{
            return -Int(Double(startTime.timeIntervalSinceNow)*1000)
        } else {
            return 0
        }
    }
    var timeIntervalInMillisSinceLap: Int{
        if let lapTime = lapTime{
            return -Int(Double(lapTime.timeIntervalSinceNow)*1000)
        } else {
            return 0
        }
    }
    
    init() {
        lapsTimeInMillis = [Int]()
    }
    
    mutating func startStopWatch(){
        isPaused = false
        startTime = Date.init()
        lapsTimeInMillis.removeAll()
    }
    
    mutating func resetStopWatch(){
        isPaused = false
        startTime = nil
        lapTime = nil
    }
    
    mutating func pauseStopWatch(){
        isPaused = true
        pauseTimeIntervalSinceStart = startTime?.timeIntervalSinceNow
        if let lapTime = lapTime{
            pauseTimeIntervalSinceLap = lapTime.timeIntervalSinceNow
        }
    }

    mutating func resumeStopWatch(){
        isPaused = false
        if let pauseTimeIntervalSinceStart = pauseTimeIntervalSinceStart{
            startTime = Date.init(timeInterval: pauseTimeIntervalSinceStart, since: Date.init())
            if let pauseTimeIntervalSinceLap = pauseTimeIntervalSinceLap{
                lapTime = Date.init(timeInterval: pauseTimeIntervalSinceLap, since: Date.init())
            }
        }
    }
    
    mutating func lap(){
        if let startTime = startTime{
            if isPaused{
                if let pauseTimeIntervalSinceStart = pauseTimeIntervalSinceStart{
                    lapsTimeInMillis.append(-Int(Double(pauseTimeIntervalSinceStart)*1000))
                    pauseTimeIntervalSinceLap = 0
                }
            } else {
                lapsTimeInMillis.append(-Int(Double(startTime.timeIntervalSinceNow)*1000))
                lapTime = Date.init()
            }
        }
    }
}
