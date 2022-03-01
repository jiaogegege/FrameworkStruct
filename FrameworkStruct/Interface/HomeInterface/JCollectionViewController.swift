//
//  JCollectionViewController.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/11/3.
//

import UIKit

class JCollectionViewController: BasicViewController
{
//MARK: 属性
    var collectionView: UICollectionView!
    let colors:[UIColor] = [UIColor.red, UIColor.yellow, UIColor.gray, UIColor.green, UIColor.blue, UIColor.purple, UIColor.orange]

//MARK: 方法
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = String.waterfall
        let flowLayout = GCWaterfallFlowLayout.init()
        flowLayout.delegate = self
//        flowLayout.sectionHeadersPinToVisibleBounds = true
        self.collectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight), collectionViewLayout: flowLayout)
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.isScrollEnabled = true
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionviewcell")
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "collectionheaderview")
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "collectionfooterview")
        self.view.addSubview(self.collectionView)
    }

}

//MARK: collectionview代理方法
extension JCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    //返回4个section，前面3个都是一行一个，最后一个section一行2个，可能是瀑布流
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 4;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if section == 3
        {
            return 40
        }
        else
        {
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets.init(top: 10, left: 10, bottom: 100, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionviewcell", for: indexPath)
//        cell.contentView.backgroundColor = self.colors[Int(arc4random_uniform(UInt32(self.colors.count)))]
        cell.contentView.backgroundColor = UIColor.lightGray
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        //1.取出section的headerView
        if kind == UICollectionView.elementKindSectionHeader
        {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "collectionheaderview", for: indexPath) as UICollectionReusableView
            let label = UILabel.init()
            label.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 40)
            label.backgroundColor = UIColor.yellow
            label.text = "header:\(indexPath.section)"
            headerView.addSubview(label)
            return headerView
        }
        else if kind == UICollectionView.elementKindSectionFooter
        {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "collectionfooterview", for: indexPath) as UICollectionReusableView
            let label = UILabel.init()
            label.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 20)
            label.backgroundColor = UIColor.systemPink
            label.text = "footer:\(indexPath.section)"
            footerView.addSubview(label)
            return footerView
        }
        return UICollectionReusableView.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        FSLog("select")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 3
        {
            return CGSize(width:( kScreenWidth - 40) / 2.0, height: CGFloat(20 + arc4random_uniform(80)))
        }
        else if indexPath.section == 1
        {
            return CGSize(width: kScreenWidth - 20, height: 60)
        }
        else
        {
            return CGSize(width: kScreenWidth - 20, height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 3
        {
            return CGSize.init(width: kScreenWidth, height: 40)
        }
        else
        {
            return CGSize.init(width: kScreenWidth, height: 45)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 3
        {
            return CGSize.init(width: kScreenWidth, height: 40)
        }
        else
        {
            return CGSize.init(width: kScreenWidth, height: 45)
        }
    }
    
}

//MARK: 瀑布流代理方法
extension JCollectionViewController: GCWaterfallFlowLayoutDeleagte
{
    func gcWaterfallSizeForItem(atIndex index: IndexPath!, collectionView: UICollectionView!) -> CGSize
    {
        if index.section == 3
        {
            return CGSize(width:( kScreenWidth - 40) / 2.0, height: CGFloat(20 + arc4random_uniform(80)))
        }
        else if index.section == 1
        {
            return CGSize(width: kScreenWidth - 20, height: 60)
        }
        else
        {
            return CGSize(width: kScreenWidth - 20, height: 40)
        }
    }
    
    func gcWaterfallInsetForItem(atIndex index: IndexPath!, collectionView: UICollectionView!) -> UIEdgeInsets
    {
        return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func gcWaterfallMinimumLineSpacingForSection(atIndex index: IndexPath!, collectionView: UICollectionView!) -> CGFloat
    {
        return 10
    }
    
    func gcWaterfallReferenceSizeForHeader(inSection index: IndexPath!, collectionView: UICollectionView!) -> CGSize
    {
        if index.section == 3
        {
            return CGSize.init(width: kScreenWidth, height: 40)
        }
        else
        {
            return CGSize.init(width: kScreenWidth, height: 45)
        }
    }
    
    func gcWaterfallReferenceSizeForFooter(inSection index: IndexPath!, collectionView: UICollectionView!) -> CGSize
    {
        if index.section == 3
        {
            return CGSize.init(width: kScreenWidth, height: 40)
        }
        else
        {
            return CGSize.init(width: kScreenWidth, height: 20)
        }
    }
    
}
