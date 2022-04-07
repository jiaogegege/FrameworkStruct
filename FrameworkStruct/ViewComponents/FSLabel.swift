//
//  FSLabel.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/4/7.
//

/**
 * 自定义label，增加剪切/复制/粘贴功能
 */
import UIKit

class FSLabel: UILabel
{
    //MARK: 属性
    ///开启或关闭复制粘贴功能
    var supportCopy: Bool = false {
        didSet {
            self.enableCopyPaste(supportCopy)
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    //剪贴板适配器
    fileprivate lazy var ca: ClipboardAdapter = ClipboardAdapter.shared
    
    //工具菜单
    fileprivate lazy var menu: UIMenuController = UIMenuController.shared
    
    //MARK: 方法
    /**************************************** 剪切复制粘贴功能 Section Begin ***************************************/
    //打开或关闭复制粘贴功能
    fileprivate func enableCopyPaste(_ enabled: Bool)
    {
        if enabled
        {
            isUserInteractionEnabled = true
            addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(showMenu(sender:))))
        }
        else
        {
            isUserInteractionEnabled = false
            //删除长按手势
            if let gess = gestureRecognizers
            {
                for ges in gess
                {
                    if ges.isKind(of: UILongPressGestureRecognizer.self)
                    {
                        self.removeGestureRecognizer(ges)
                    }
                }
            }
        }
    }
    
    //控制展示的菜单项
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.copy(_:))
        {
            return true
        }
        else if action == #selector(UIResponderStandardEditActions.cut(_:))
        {
            return true
        }
        else if action == #selector(UIResponderStandardEditActions.paste(_:))
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    //显示复制粘贴工具菜单
    @objc fileprivate func showMenu(sender: UIGestureRecognizer)
    {
        becomeFirstResponder()
        if !menu.isMenuVisible
        {
            menu.showMenu(from: self, rect: bounds)
        }
    }
    
    //复制功能
    override func copy(_ sender: Any?) {
        if let tx = text
        {
            _ = ca.write(value: tx, valueType: .string)
        }
        //操作完成后隐藏菜单
        menu.hideMenu(from: self)
    }
    
    //粘贴功能
    override func paste(_ sender: Any?) {
        if let tx = ca.read(valueType: .string) as? String
        {
            self.text = tx
        }
        //操作完成后隐藏菜单
        menu.hideMenu(from: self)
    }
    
    //剪切功能
    override func cut(_ sender: Any?) {
        if let tx = text
        {
            _ = ca.write(value: tx, valueType: .string)
            //清除本地内容
            text = nil
        }
        //操作完成后隐藏菜单
        menu.hideMenu(from: self)
    }
    /**************************************** 剪切复制粘贴功能 Section End ***************************************/

}
