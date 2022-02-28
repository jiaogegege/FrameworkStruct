//
//  ModalTestViewController.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/12/17.
//

/**
 *测试模态显示
 */
import UIKit

class ModalTestViewController: BasicViewController {
    
    override class func getViewController() -> Self {
        getVC(from: gMainSB)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func configUI() {
        self.presentationController?.delegate = self
    }

    @IBAction func dismissBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension ModalTestViewController: UIAdaptivePresentationControllerDelegate
{
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return false
    }
}
