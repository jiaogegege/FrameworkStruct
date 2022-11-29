//
//  MPSonglistsView.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/11/5.
//

/**
 添加到歌单时选择歌单的view
 */
import UIKit

class MPSonglistsView: FSDialog {
    //MARK: 属性
    //要添加的歌曲
    var song: MPSongModel?
    //歌单列表，外部传入
    var songlists: [MPSonglistModel]?
    fileprivate unowned var mpr: MPManager = MPManager.shared
    
    //UI组件
    fileprivate var titleLabel: UILabel!
    fileprivate var newBtn: UIButton!
    fileprivate var tableView: UITableView!

    //MARK: 方法
    override func createView() {
        super.createView()
        
        containerView.frame = CGRect(x: 0, y: Self.containerHeight, width: kScreenWidth, height: Self.containerHeight)
        
        titleLabel = UILabel(frame: CGRect(x: 12, y: 24, width: kScreenWidth / 2.0, height: 17))
        containerView.addSubview(titleLabel)
        
        newBtn = UIButton(type: .custom)
        newBtn.frame = CGRect(x: kScreenWidth - 12 - 80, y: 17.5, width: 80, height: 30)
        containerView.addSubview(newBtn)
        
        tableView = UITableView(frame: CGRect(x: 0, y: titleLabel.y + titleLabel.height + 12, width: self.width, height: Self.containerHeight - (titleLabel.y + titleLabel.height + 12)))
        containerView.addSubview(tableView)
    }
    
    override func configView() {
        super.configView()
        
        self.showType = .bounce
        self.isTapDismissEnabled = true
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        
        titleLabel.text = String.addSongToSonglist
        titleLabel.textColor = .cBlack_3
        titleLabel.font = .boldSystemFont(ofSize: 16)
        
        newBtn.setTitle(String.newSonglist, for: .normal)
        newBtn.setTitleColor(.darkGray, for: .normal)
        newBtn.titleLabel?.font = .systemFont(ofSize: 14)
        newBtn.addTarget(self, action: #selector(newAction(sender:)), for: .touchUpInside)
        newBtn.layer.cornerRadius = newBtn.height / 2.0
        newBtn.layer.borderColor = UIColor.lightGray.cgColor
        newBtn.layer.borderWidth = 0.5
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.register(UINib(nibName: MPSonglistCell.className, bundle: nil), forCellReuseIdentifier: MPSonglistCell.reuseId)
    }
    
    //新建歌单
    @objc func newAction(sender: UIButton)
    {
        showNewSonglistView()
    }
    
    //新增歌单
    fileprivate func showNewSonglistView()
    {
        AlertManager.shared.wantPresentAlert(title: .newSonglist, needInput: true, inputPlaceHolder: .enterSonglistNameHint, leftTitle: .cancel, leftBlock: {
            
        }, rightTitle: .confirm) { name in
            guard let name = name else {
                g_alert(message: .pleaseEnterName)
                return
            }
            self.createNewSonglist(name)
        }
    }
    
    //创建一个新歌单
    fileprivate func createNewSonglist(_ name: String)
    {
        mpr.createNewSonglist(name) {[weak self] songlist in
            if let songlist = songlist, let so = self?.song {
                //添加到新歌单中
                self?.mpr.addSongsToSonglist([so], songlistId: songlist.id, completion: { result in
                    g_toast(text: result.getDesc(), interaction: true)
                    self?.mpr.getAllSonglists({ songlists in
                        if let songlists = songlists {
                            self?.songlists = songlists
                            self?.tableView.reloadData()
                            g_after(2) {
                                self?.dismiss()
                            }
                        }
                        else
                        {
                            self?.dismiss()
                        }
                    })
                })
            }
            else
            {
                g_toast(text: String.createFailure, interaction: true)
            }
        }
    }
    
}


extension MPSonglistsView: DelegateProtocol, UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        songlists?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MPSonglistCell.reuseId, for: indexPath) as! MPSonglistCell
        cell.songlist = songlists![indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let song = song, let songlist = songlists?[indexPath.row] {
            mpr.addSongsToSonglist([song], songlistId: songlist.id) {[weak self] result in
                g_toast(text: result.getDesc(), interaction: true)
                self?.dismiss()
            }
        }
    }
    
}


extension MPSonglistsView: InternalType
{
    //内容区域高度
    static let containerHeight: CGFloat = kScreenHeight / 2.0 + fitX(60.0)
    
}
