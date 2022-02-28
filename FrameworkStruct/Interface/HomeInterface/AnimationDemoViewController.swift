//
//  AnimationDemoViewController.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/2/12.
//

/**
 动画演示
 */
import UIKit

class AnimationDemoViewController: BasicViewController {
    
    override class func getViewController() -> Self {
        getVC(from: gMainSB)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configUI() {
        super.configUI()
        let v = AnimationManager.shared.lottie(name: "BLE_img_gear", loopMode: .loop) {
            FSLog("完成")
        }
        v.backgroundColor = .yellow
        v.frame = CGRect(x: 10, y: kSafeTopHeight, width: 100, height: 100)
        self.view.addSubview(v)
        AnimationManager.shared.popBasic(propertyName: kPOPViewCenter, toValue: CGPoint(x: 300, y: 300), duration: 1, isLoop: true, repeatCount: 2, autoReverse: true, host: v) {
            FSLog("POP动画完成")
        }
        AnimationManager.shared.popSpring(propertyName: kPOPViewFrame, toValue: CGRect(x: 200, y: 200, width: 400, height: 400), bounciness: 4, speed: 12, isLoop: true, repeatCount: 1, autoReverse: true, host: v) {
            FSLog("pop弹性动画完成")
        }
        AnimationManager.shared.popDecay(propertyName: kPOPViewCenter, fromValue: CGPoint(x: 100, y: 200), velocity: CGPoint(x: 200, y: 600), deceleration: 0.998, isLoop: true, repeatCount: 1, autoReverse: true, host: v) {
            FSLog("衰减动画完成")
        }

    }
    

}
