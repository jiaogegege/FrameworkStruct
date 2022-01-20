//
//  ShadowTestViewController.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/1/20.
//

import UIKit

class ShadowTestViewController: BasicViewController {
    
    static func getViewController() -> ShadowTestViewController
    {
        let board = UIStoryboard(name: gMainSB, bundle: nil)
        return board.instantiateViewController(withIdentifier: "ShadowTestViewController") as! ShadowTestViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func createUI() {
        let redView = UIView(frame: CGRect(x: 100, y: 100, width: 200, height: 150))
        redView.backgroundColor = .red
        redView.layer.cornerRadius = 150/2
        redView.addPathShadow(offset: CGSize(width: 10, height: 10), radius: 5)
        view.addSubview(redView)
        
        let greenView = UIView(frame: CGRect(x: 100, y: 300, width: 200, height: 200))
        greenView.backgroundColor = .green
        greenView.layer.cornerRadius = 20
        greenView.setLayerShadow(offset: CGSize(width: -5, height: 5))
        view.addSubview(greenView)

    }

}
