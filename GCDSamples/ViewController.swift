//
//  ViewController.swift
//  GCDSamples
//
//  Created by Gabriel Theodoropoulos on 07/11/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var inactiveQueue: DispatchQueue!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.globalQueues()
//
//        serialQueues()
//
//        queuesWithQoS()
//
//        concurrentQueues()
//
//        self.inactiveQueues()
//        if let queue = inactiveQueue {
//            queue.activate()
//        }
//
//        queueWithDelay()
//
//        self.dispatchGroupQueues()
    }
    
    @IBAction func action(_ sender: Any) {
        let anotherQueue2 = DispatchQueue(label: "com.appcoda", qos: .default, attributes: .concurrent)
        anotherQueue2.sync {
            for i in 100..<11000 {
                print("🔵", i)
            }
        }
    }
    
    func globalQueues() {
        DispatchQueue.global().sync {
            for i in 0..<10 {
                self.blueDot(index: i)
            }
        }
        for i in 0..<10 {
            self.redDot(index: i)
        }
    }
    
    func printFrom1To1000(){
        for counter in 0..<1000{
            print("Counter = \(counter) - Thread = \(Thread.current)")
        }
    }
    
    func serialQueues() {
        let queue = DispatchQueue(label: "label")
        queue.async {
            for i in 0..<10 {
                self.redDot(index: i)
            }
        }
        queue.sync {
            for i in 0..<10 {
                self.blueDot(index: i)
            }
        }
    }
    
    
    private func blackDot(index: Int) {
        print("⚫️", index)
    }
    
    private func redDot(index: Int) {
        print("🔴 ", index)
    }
    
    private func blueDot(index: Int) {
        print("Ⓜ️ ", index)
    }
    
    func queuesWithQoS() {
        /* have 6 QoS
         1.userInteractive
         2.userInitiated
         3.default
         4.utility
         5.background
         6.uspecified
        */
        let queue1 = DispatchQueue(label: "com.appcoda.queue1", qos: DispatchQoS.userInitiated)
        let queue2 = DispatchQueue(label: "com.appcoda.queue2", qos: DispatchQoS.utility)
        
        queue1.async {
            for i in 0..<10 {
                print("🔴", i)
            }
        }
        
        queue2.async {
            for i in 100..<110 {
                print("🔵", i)
            }
        }
    }
    
    func concurrentQueues() {
        let anotherQueue = DispatchQueue(label: "com.appcoda.anotherQueue", qos: .default, attributes: .concurrent)
        anotherQueue.sync {
            for i in 0..<1000 {
                
                print("🔴", i)
                sleep(1)
                
                let anotherQueue1 = DispatchQueue(label: "com.appcoda.anotherQueue", qos: .default, attributes: .concurrent)
                
                anotherQueue1.sync {
                    for i in 100..<110 {
                        print("🔵", i)
                        sleep(1)
                    }
                }
            }
        }
    }
    
    func queueWithDelay() {
        let delayQueue = DispatchQueue(label: "com.appcoda.delayqueue", qos: .userInitiated)
        print(Date())
        let additionalTime: DispatchTimeInterval = .seconds(2)
        
        delayQueue.asyncAfter(deadline: .now() + additionalTime) {
            print(Date())
        }
    }
    
    func useWorkItem() {
        var value = 10
        let workItem = DispatchWorkItem {
            value += 5
        }
        workItem.perform()
        let queue = DispatchQueue.global(qos: .utility)
        queue.async(execute: workItem)
        workItem.notify(queue: DispatchQueue.main) {
            print("value = ", value)
        }
    }
    
    func dispatchGroupQueues() {
        let anotherQueue = DispatchQueue(label: "com.appcoda.anotherQueue", qos: .utility, attributes: .concurrent)
        let dispatchGroup = DispatchGroup()
        var value = 0
        
        dispatchGroup.enter()
        anotherQueue.async {
            value += 1
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        anotherQueue.async {
            value += 1
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        anotherQueue.async {
            value += 1
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        anotherQueue.async {
            value += 1
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            print(value)
        }
    }
    
    func inactiveQueues() {
        let queue = DispatchQueue(label: "initqueue", qos: .default, attributes: .initiallyInactive)
        self.inactiveQueue = queue
        queue.async {
            print("do something")
        }
    }
}
