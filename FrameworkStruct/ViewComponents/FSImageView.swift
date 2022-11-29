//
//  FSImageView.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/4/7.
//

/**
 自定义imageview，增加剪切/复制/粘贴功能，自定义其它菜单功能
 */
import UIKit

class FSImageView: UIImageView
{
    //MARK: 属性
    ///开启或关闭复制粘贴功能
    var supportMenu: Bool = false {
        willSet {
            self.enableMenu(newValue)
        }
    }
    
    /**************************************** 支持的菜单项 Section Begin ***************************************/
    //支持的菜单项
    var canCopy: Bool = true                //复制
    var canPaste: Bool = true               //粘贴
    var canCut: Bool = true                 //剪切
    var canDelete: Bool = true              //删除
    var canAppend: Bool = true              //追加
    
    /**************************************** 支持的菜单项 Section End ***************************************/
    
    override var canBecomeFirstResponder: Bool {
        return supportMenu
    }
    
    //剪贴板适配器
    fileprivate lazy var ca: ClipboardAdapter = ClipboardAdapter.shared
    
    //工具菜单
    fileprivate lazy var menu: UIMenuController = UIMenuController.shared
    
    //MARK: 方法
    /**************************************** 剪切复制粘贴功能 Section Begin ***************************************/
    //打开或关闭复制粘贴功能
    fileprivate func enableMenu(_ enabled: Bool)
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
                        //删除长按手势后结束循环
                        break
                    }
                }
            }
        }
    }
    
    //控制展示的菜单项
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.copy(_:))
        {
            return canCopy
        }
        else if action == #selector(UIResponderStandardEditActions.cut(_:))
        {
            return canCut
        }
        else if action == #selector(UIResponderStandardEditActions.paste(_:))
        {
            return canPaste
        }
        else if action == #selector(UIResponderStandardEditActions.delete(_:))
        {
            return canDelete
        }
        else if action == #selector(append(_:))
        {
            return canAppend
        }
        else
        {
            return false
        }
    }
    
    //获取自定义菜单项
    func getCustomMenuItems() -> [UIMenuItem]
    {
        var items: [UIMenuItem] = []
        if canAppend
        {
            items.append(UIMenuItem(title: String.append, action: #selector(append(_:))))
        }
        
        return items
    }
    
    //显示复制粘贴工具菜单
    @objc fileprivate func showMenu(sender: UIGestureRecognizer)
    {
        becomeFirstResponder()
        if !menu.isMenuVisible
        {
            //构建自定义菜单项
            menu.menuItems = getCustomMenuItems()
            menu.showMenu(from: self, rect: bounds)
        }
    }
    
    //复制功能
    override func copy(_ sender: Any?) {
        if let img = image
        {
            _ = ca.write(value: img, valueType: .image)
        }
        //操作完成后隐藏菜单
        menu.hideMenu(from: self)
    }
    
    //粘贴功能
    override func paste(_ sender: Any?) {
        if let img = ca.read(valueType: .image) as? UIImage
        {
            self.image = img
        }
        //操作完成后隐藏菜单
        menu.hideMenu(from: self)
    }
    
    //剪切功能
    override func cut(_ sender: Any?) {
        if let img = image
        {
            _ = ca.write(value: img, valueType: .image)
            //清除本地内容
            image = nil
        }
        //操作完成后隐藏菜单
        menu.hideMenu(from: self)
    }
    
    //删除
    override func delete(_ sender: Any?) {
        image = nil
    }
    
    //追加，将两张图片拼接在一起
    @objc func append(_ sender: UIMenuController)
    {
        if let img = ca.read(valueType: .image) as? UIImage
        {
            if let originImg = image
            {
                //将两张图片并排绘制
                image = GraphicsManager.shared.drawGroupImages([originImg, img], direction: .horizontal, align: .left)
            }
            else
            {
                image = img
            }
        }
        //操作完成后隐藏菜单
        menu.hideMenu(from: self)
    }
    
    /**************************************** 剪切复制粘贴功能 Section End ***************************************/

}
