//
//  DrawTestViewController.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/4/2.
//

/**
 * 绘图测试
 */
import UIKit

class DrawTestViewController: BasicViewController {
    
    override class func getViewController() -> Self {
        getVC(from: gMainSB)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let op1: ThreadManager.DispatchGroupClosure = {finish in
            print("op1 start")
            TimerManager.shared.after(interval: 4) {
                print("op1 finish")
                finish()
            }
        }
        let op2: ThreadManager.DispatchGroupClosure = {finish in
            print("op2 start")
            TimerManager.shared.after(interval: 2) {
                print("op2 finish")
                finish()
            }
        }
        let op3: ThreadManager.DispatchGroupClosure = {finish in
            print("op3 start")
            TimerManager.shared.after(interval: 1) {
                print("op3 finish")
                finish()
            }
        }
        ThreadManager.shared.asyncGroup(ops: [op1, op2, op3]) {
            print("all finish")
        }
    }
    


}
