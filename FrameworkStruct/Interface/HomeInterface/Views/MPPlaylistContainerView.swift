//
//  MPPlaylistContainerView.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/11/2.
//

/**
 播放列表视图，可包含多个播放列表
 */
import UIKit

class MPPlaylistContainerView: FSDialog {
    //MARK: 属性
    lazy var mpr = MPManager.shared
    
    //当前页
    fileprivate(set) var currentPage: Int = 0
    //一共有多少页，目前只有2个
    fileprivate(set) var totalPage: Int = 2
    
    //UI组件
    fileprivate var pageControl: UIPageControl!
    fileprivate var scrollView: UIScrollView!
    fileprivate var currentPlaylistView: MPPlaylistView!    //当前播放列表
    fileprivate var historyPlaylistView: MPPlaylistView!    //历史播放列表
    
    
    //MARK: 方法
    //初始化
    init() {
        super.init(frame: .zero)
        self.mpr.addDelegate(self)
        updateView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createView() {
        super.createView()
        
        containerView.frame = CGRect(x: 0, y: kScreenHeight / 3.0, width: kScreenWidth, height: Self.containerHeight)
        
        pageControl = UIPageControl(frame: CGRect(x: 0, y: 0, width: containerView.width, height: 10))
        containerView.addSubview(pageControl)
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 10 + fitX(4), width: containerView.width, height: containerView.height - 10 - fitX(4)))
        containerView.addSubview(scrollView)
        
        //创建播放列表view
        var scrollWidth: CGFloat = Self.borderSpace  //滚动范围
        currentPlaylistView = MPPlaylistView(frame: CGRect(x: scrollWidth, y: 0, width: Self.playlistWidth, height: scrollView.height - fitX(10)))
        scrollView.addSubview(currentPlaylistView)
        
        scrollWidth += currentPlaylistView.width
        scrollWidth += Self.borderSpace / 2.0
        
        historyPlaylistView = MPPlaylistView(frame: CGRect(x: scrollWidth, y: 0, width: Self.playlistWidth, height: scrollView.height - fitX(10)))
        scrollView.addSubview(historyPlaylistView)
        
        scrollWidth += historyPlaylistView.width
        scrollWidth += Self.borderSpace
        
        scrollView.contentSize = CGSize(width: scrollWidth, height: scrollView.height)
    }
    
    override func configView() {
        super.configView()
        
        self.isTapDismissEnabled = true
        self.showType = .bounce
        
        containerView.backgroundColor = .clear
        
        pageControl.numberOfPages = 2
        pageControl.isEnabled = false
        
        scrollView.delegate = self
        
        currentPlaylistView.needLocation = true
        currentPlaylistView.clickCallback = {[weak self] (audio, playlist) in
            self?.mpr.playSong(audio as! MPSongModel, in: playlist, completion: { succeed in
                if succeed == false
                {
                    g_toast(text: "歌曲 \(audio.audioName)播放失败")
                }
            })
        }
        currentPlaylistView.deleteSongCallback = {[weak self] (audio, playlist) in
            self?.mpr.deleteSong(audio, in: playlist, success: { succeed in
                g_toast(text: (succeed ? String.deleteSucceed : String.deleteFailed))
            })
        }
        
        historyPlaylistView.clickCallback = {[weak self] (audio, playlist) in
            self?.mpr.playSong(audio as! MPSongModel, in: playlist, completion: { succeed in
                if succeed == false
                {
                    g_toast(text: "歌曲 \(audio.audioName)播放失败")
                }
            })
        }
        historyPlaylistView.deleteSongCallback = {[weak self] (audio, playlist) in
            self?.mpr.deleteSong(audio, in: playlist, success: { succeed in
                g_toast(text: (succeed ? String.deleteSucceed : String.deleteFailed))
            })
        }
    }
    
    override func updateView() {
        mpr.getCurrentPlaylist {[weak self] playlist in
            self?.currentPlaylistView.playlist = playlist
            self?.currentPlaylistView.setTitle(String.currentPlay)
            if let song = self?.mpr.currentSong {
                self?.currentPlaylistView.currentSong = song
            }
        }
        mpr.getHistorySongs {[weak self] history in
            self?.historyPlaylistView.playlist = history
        }
    }
    
    //是否可以滚页
    var canScrollPage: Bool = true
    fileprivate func scrollPage()
    {
        if canScrollPage
        {
            canScrollPage = false
            //控制分页效果，下一页出现超过屏幕1/3就滑过去，上一页出现超过屏幕1/3就滑过去
            //先判断是否可以滚到到下一页
            let nextPage = currentPage + 1
            //判断是否可以滚到到上一页
            let previousPage = currentPage - 1
            let offsetX = scrollView.contentOffset.x        //松手时滚动距离
            let nextPageBoundaryX = Self.borderSpace + CGFloat(currentPage) * (Self.whiteSpace + Self.playlistWidth) + Self.playlistWidth / 4.0     //滑动到下一页的阈值
            let previousPageBoundaryX = Self.borderSpace + CGFloat(currentPage) * (Self.whiteSpace + Self.playlistWidth) - Self.playlistWidth / 4.0     //滑动到上一页的阈值
            var realOffsetX: CGFloat = 0.0
            if nextPage < totalPage && offsetX > nextPageBoundaryX  //滑动到下一页
            {
                currentPage += 1
                //计算实际滑动距离
            }
            else if previousPage >= 0 && offsetX < previousPageBoundaryX    //滑动到上一页
            {
                currentPage -= 1
            }
            else    //回到原来位置
            {
                canScrollPage = true
            }
            realOffsetX = CGFloat(currentPage) * (Self.playlistWidth + Self.whiteSpace)
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
                self.scrollView.contentOffset = CGPoint(x: realOffsetX, y: 0)
            } completion: { finished in
                self.canScrollPage = true
                self.pageControl.currentPage = self.currentPage
            }
        }
    }
    
}


extension MPPlaylistContainerView: DelegateProtocol, MPManagerDelegate, UIScrollViewDelegate
{
    /**************************************** MPManager 代理 Section Begin ***************************************/
    func mpManagerDidInitCompleted() {
        updateView()
    }
    
    func mpManagerDidUpdated() {
//        updateView()
    }
    
    func mpManagerWaitToPlay(_ song: MPAudioProtocol) {
        
    }
    
    func mpManagerStartPlay(_ song: MPAudioProtocol) {
        updateView()
    }
    
    func mpManagerPausePlay(_ song: MPAudioProtocol) {
        
    }
    
    func mpManagerResumePlay(_ song: MPAudioProtocol) {
        
    }
    
    func mpManagerFailedPlay(_ song: MPAudioProtocol) {
        
    }
    
    func mpManagerProgressChange(_ progress: TimeInterval) {
        
    }
    
    func mpManagerBufferProgressChange(_ progress: TimeInterval) {
        
    }
    
    func mpManagerDidUpdateFavoriteSongs(_ favoriteSongs: MPFavoriteModel) {
        
    }
    
    func mpManagerDidUpdateCurrentPlaylist(_ currentPlaylist: MPPlaylistModel) {
        updateView()
    }
    
    func mpManagerDidUpdateHistorySongs(_ history: MPHistoryAudioModel) {
        updateView()
    }
    
    func mpManagerDidUpdateSonglists(_ songlists: [MPSonglistModel]) {
        
    }
    
    /**************************************** MPManager 代理 Section End ***************************************/
    
    /**************************************** UIScrollView 代理 Section Begin ***************************************/
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !scrollView.isDecelerating
        {
            scrollPage()
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollView.setContentOffset(scrollView.contentOffset, animated: false)
        scrollPage()
    }
    
    /**************************************** UIScrollView 代理 Section End ***************************************/
}


extension MPPlaylistContainerView: InternalType
{
    //内容区域高度
    static let containerHeight: CGFloat = kScreenHeight / 3.0 * 2.0
    //播放列表范围左右边距
    static let borderSpace: CGFloat = fitX(20)
    //播放列表间距
    static let whiteSpace: CGFloat = borderSpace / 2.0
    //播放列表宽度
    static let playlistWidth: CGFloat = kScreenWidth - borderSpace * 2.0
    //播放列表高度
    static let playlistHeight: CGFloat = containerHeight - 10 - fitX(4) - fitX(10)
    
}
