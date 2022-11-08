//
//  MPLyricView.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/11/7.
//

/**
 播放时显示歌词
 */
import UIKit

class MPLyricView: UIView {
    //MARK: 属性
    var lyricModel: MPLyricModel? {
        didSet {
            updateView()
        }
    }
    
    //定位歌词返回播放时间
    var locateCallback: ((TimeInterval) -> Void)?
    
    //tap回调
    var tapCallback: VoidClosure?
    
    fileprivate var headCellIndex: UITableView.IndexPathTag = .rowTag(-1)   //头部index
    fileprivate var footCellIndex: UITableView.IndexPathTag = .rowTag(-1)   //尾部index
    fileprivate var centerPos: CGPoint = .zero     //中心点位置
    fileprivate(set) var currentLrcIndex: Int = 0       //当前播放到的歌词index，头尾各算一个
    fileprivate var lastLocateTime: TimeInterval?       //上一次拖动歌词定位的时间
    fileprivate var locateHideTimer: Timer?     //歌词定位按钮显示后倒计时隐藏
    
    //UI组件
    fileprivate var bgView: UIView!
    fileprivate var emptyLabel: UILabel!
    fileprivate var tableView: UITableView!
    fileprivate var locationView: UIView!       //歌词定位view
    fileprivate var locateBtn: UIButton!        //定位到当前歌词位置播放
    fileprivate var locateTimeLabel: UILabel!
    fileprivate var locateLine: UIView!
    
    //MARK: 方法
    init()
    {
        super.init(frame: .zero)
        self.createView()
        self.configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createView() {
        bgView = UIView()
        addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        emptyLabel = UILabel()
        bgView.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(fitX(20))
        }
        
        tableView = UITableView()
        bgView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        locationView = UIView()
        bgView.addSubview(locationView)
        locationView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(fitX(30))
        }
        
        locateBtn = UIButton(type: .custom)
        locationView.addSubview(locateBtn)
        locateBtn.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(fitX(28))
        }
        
        locateTimeLabel = UILabel()
        locationView.addSubview(locateTimeLabel)
        locateTimeLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-1)
            make.top.bottom.equalToSuperview()
        }
        
        locateLine = UIView()
        locationView.addSubview(locateLine)
        locateLine.snp.makeConstraints { make in
            make.left.equalTo(locateBtn.snp.right).offset(fitX(5))
            make.right.equalTo(locateTimeLabel.snp.left).offset(fitX(-10))
            make.height.equalTo(0.5)
            make.centerY.equalToSuperview()
        }
    }
    
    override func configView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))
        bgView.addGestureRecognizer(tap)
        
        emptyLabel.text = String.noLyric
        emptyLabel.textColor = .lightGray
        emptyLabel.font = .systemFont(ofSize: fitX(16))
        emptyLabel.textAlignment = .center
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(MPLrcContentCell.self, forCellReuseIdentifier: MPLrcContentCell.reuseId)
        
        locationView.isHidden = true
        locationView.alpha = 0.0
        
        locateBtn.setImage(UIImage.iLrcLocationBtn, for: .normal)
        locateBtn.addTarget(self, action: #selector(lrcLocateAction(sender:)), for: .touchUpInside)
        
        locateTimeLabel.textColor = .white
        locateTimeLabel.font = .systemFont(ofSize: fitX(-10))
        locateTimeLabel.textAlignment = .right
        
        locateLine.backgroundColor = .lightGray
    }
    
    override func updateView() {
        if let model = lyricModel {
            emptyLabel.isHidden = true
            tableView.isHidden = false
            headCellIndex = .rowTag(0)
            footCellIndex = .rowTag(model.lyrics.count + 1)
            centerPos = CGPoint(x: self.width / 2.0, y: self.height / 2.0)
        }
        else
        {
            emptyLabel.isHidden = false
            tableView.isHidden = true
        }
        tableView.reloadData()
        g_after(0.1) {
            self.calcDistance()
        }
    }
    
    @objc func tapAction(sender: UITapGestureRecognizer)
    {
        if let tapCallback = tapCallback {
            tapCallback()
        }
    }
    
    //定位歌词
    @objc func lrcLocateAction(sender: UIButton)
    {
        if let locateCallback = locateCallback {
            let time = getCenterPosTime() + 0.5     //avplayer seek后的时间会往回走，所以增加偏移量
            lastLocateTime = time
            locateCallback(time)
        }
    }
    
    //计算当前cell距离中心显示cell的距离
    //往上往下分别找10个cell，最大最小不超过数组范围
    fileprivate func calcDistance()
    {
        //得到中心点位置处的cell index
        if let centerIndex = tableView.indexPathForRow(at: centerPos)?.row
        {
            let cell = tableView.cellForRow(at: IndexPath(row: centerIndex, section: 0)) as? MPLrcContentCell
            cell?.distanceToCenter = .center(0)
            cell?.updateView()
            for i in 0..<10
            {
                let previousIndex = centerIndex - i
                if tableView.isVisible(row: previousIndex, secton: 0)
                {
                    if let cell = tableView.cellForRow(at: IndexPath(row: previousIndex, section: 0)) as? MPLrcContentCell
                    {
                        cell.distanceToCenter = .center(abs(previousIndex - centerIndex))
                        cell.updateView()
                    }
                }
                let nextIndex = centerIndex + i
                if tableView.isVisible(row: nextIndex, secton: 0)
                {
                    if let cell = tableView.cellForRow(at: IndexPath(row: nextIndex, section: 0)) as? MPLrcContentCell
                    {
                        cell.distanceToCenter = .center(abs(nextIndex - centerIndex))
                        cell.updateView()
                    }
                }
            }
        }
    }
    
    //得到中心点处的歌词时间
    fileprivate func getCenterPosTime() -> TimeInterval
    {
        if let centerIndex = tableView.indexPathForRow(at: centerPos)?.row
        {
            if centerIndex <= 0
            {
                return 0.0
            }
            else if centerIndex >= lyricModel!.lyrics.count + 1
            {
                return lyricModel!.lyrics.last!.time
            }
            else
            {
                return lyricModel!.lyrics[centerIndex - 1].time
            }
        }
        return 0.0
    }
    
    //计算最靠近中心点的位置并滚动到此处
    fileprivate func scrollToNearestCell()
    {
        if let currentIndex = tableView.indexPathForRow(at: centerPos)?.row
        {
            tableView.scrollTo(row: currentIndex, section: 0)
        }
    }
    
    //显示定位view
    fileprivate func showLocationView()
    {
        //用户开始拖动
        locateHideTimer?.invalidate()
        locateHideTimer = nil
        locationView.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.locationView.alpha = 1.0
        } completion: { finished in
            
        }
    }
    
    //隐藏定位view
    fileprivate func hideLocationView()
    {
        locateHideTimer?.invalidate()
        locateHideTimer = nil
        locateHideTimer = TimerManager.shared.timer(interval: 2.5, repeats: false, mode: .default, hostId: self.className, action: {[weak self] (timer) in
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                self?.locationView.alpha = 0.0
            } completion: { finished in
                self?.locationView.isHidden = true
            }
        })
    }
    
}


extension MPLyricView: DelegateProtocol, UITableViewDelegate, UITableViewDataSource
{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        centerPos = CGPoint(x: self.width / 2.0, y: self.height / 2.0 + scrollView.contentOffset.y)
        calcDistance()
        //定位时间显示
        self.locateTimeLabel.text = TimeEmbellisher.shared.convertSecondsToMinute(Int(getCenterPosTime()))
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        showLocationView()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate  //如果不减速，那么滚动到当前滑动的位置
        {
            scrollToNearestCell()
            hideLocationView()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollToNearestCell()
        hideLocationView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let model = lyricModel
        {
            return model.lyrics.count + 2   //歌词总数+头部+尾部
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let _ = lyricModel {
            if indexPath.row == headCellIndex.position.row   //头部
            {
                return self.height
            }
            else if indexPath.row == footCellIndex.position.row     //尾部
            {
                return self.height / 2.0
            }
            else    //歌词
            {
                return Self.lyricCellHeight
            }
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let model = lyricModel
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: MPLrcContentCell.reuseId, for: indexPath) as! MPLrcContentCell
            if indexPath.row == headCellIndex.position.row
            {
                cell.title = model.title
                cell.artist = model.artist
                cell.album = model.album
                cell.lrcInfo = nil
            }
            else if indexPath.row == footCellIndex.position.row
            {
                cell.title = nil
                cell.artist = nil
                cell.album = nil
                cell.lrcInfo = nil
            }
            else
            {
                cell.title = nil
                cell.artist = nil
                cell.album = nil
                cell.lrcInfo = model.lyrics[indexPath.row - 1]
            }
            cell.updateView()
            return cell
        }
        else
        {
            return UITableViewCell()
        }
    }
    
}


extension MPLyricView: InternalType
{
    //歌词cell高度
    static let lyricCellHeight: CGFloat = fitX(60.0)
    
}


extension MPLyricView: ExternalInterface
{
    ///设置当前时间
    func setCurrentTime(_ time: TimeInterval)
    {
        guard tableView.isTracking == false, tableView.isDragging == false, tableView.isDecelerating == false else {
            return
        }
        if lastLocateTime == nil || (lastLocateTime != nil && time >= lastLocateTime!)
        {
            if let model = self.lyricModel
            {
                var currentIndex = -1
                //计算当前播放的歌词index
                for (index, lrc) in model.lyrics.enumerated()
                {
                    if index + 1 >= model.lyrics.count
                    {
                        currentIndex = index
                        break
                    }
                    else
                    {
                        if time >= lrc.time && time < model.lyrics[index + 1].time
                        {
                            currentIndex = index + 1
                            break
                        }
                    }
                }
                //判断第一个
                if let firstLrc = model.lyrics.first
                {
                    if time < firstLrc.time
                    {
                        currentIndex = 0
                    }
                }
                //判断最后一个
                if let lastLrc = model.lyrics.last
                {
                    if time >= lastLrc.time
                    {
                        currentIndex = model.lyrics.count
                    }
                }
                //计算的index和当前index不同的时候才滚动
                if currentIndex != currentLrcIndex
                {
                    currentLrcIndex = currentIndex
                    tableView.scrollTo(row: currentLrcIndex, section: 0)
                }
            }
            
            lastLocateTime = nil
        }
    }
    
}
