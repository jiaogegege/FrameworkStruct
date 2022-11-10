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
    
    var bar: FSPageIndicatorBar!
    
    override class func getViewController() -> Self {
        getVC(from: gMainSB)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func createUI() {
        bar = FSPageIndicatorBar(frame: CGRect(x: 100, y: 50, width: 100, height: 8), pages: 10, direction: .horizontal)
        view.addSubview(bar)
        g_after(1) {
            self.bar.setCurrentPage(1)
        }
        g_after(2) {
            self.bar.setCurrentPage(2)
        }
        g_after(3) {
            self.bar.setCurrentPage(3)
        }
        g_after(4) {
            self.bar.setCurrentPage(4)
        }
        g_after(5) {
            self.bar.setCurrentPage(9)
        }
    }
    
    override func configUI() {
        self.presentationController?.delegate = self
        
        bar.bgColor = .gray
        bar.barColor = .red
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
