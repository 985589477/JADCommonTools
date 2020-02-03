//
//  JADBannerView.swift
//  JADTransfer
//
//  Created by iOS on 2019/9/16.
//  Copyright © 2019 Jason. All rights reserved.
//

import UIKit
import Kingfisher

protocol JADBannerViewDelegate {
    func clickBannerAtIndex(_ index: Int)
}

//交给pagecontrol实现的协议
protocol JADBannerPageControlDelegate: UIView {
    var numberOfPages: Int { set get }
    var currentPage: Int { set get }
    var itemSize: CGSize { set get }
    var columnSpacing: CGFloat { set get }
}

protocol JADBannerViewAPI {
    var delegate: JADBannerViewDelegate? { set get }
    var configuration: JADBannerViewConfiguration? { get }
    var dataArray: [String]? { set get } //image字符串或者http url
    var currentPage: Int { get }
    var pageControl: JADBannerPageControlDelegate? { set get }
    var isTimerEnabled: Bool { set get }
    var isTimerRunning: Bool { set get }
}

class JADBannerView: UIView, JADBannerViewAPI {
    var delegate: JADBannerViewDelegate?
    var configuration: JADBannerViewConfiguration?
    var dataArray: [String]? {
        didSet {
            guard (self.dataArray?.count ?? 0) > 0 else { return }
            if self.dataArray!.count >= 2 {
                let first = self.dataArray?.last
                let last = self.dataArray?.first
                var array = [String]()
                array.append(first!)
                array.append(contentsOf: self.dataArray!)
                array.append(last!)
                shufflingArray = array
                collectionView?.isScrollEnabled = true
            } else {
                shufflingArray = self.dataArray
                collectionView?.isScrollEnabled = false
            }
            self.pageControl?.numberOfPages = self.dataArray!.count
            self.collectionView?.reloadData()
        }
    }
    
    var currentPage: Int = 0
    var pageControl: JADBannerPageControlDelegate? {
        didSet {
            self.addSubview(self.pageControl!)
        }
    }
    var isTimerEnabled: Bool = false {
        didSet {
            if (self.dataArray?.count ?? 0) <= 1 {
                self.stop()
                return
            }
            isTimerEnabled ? self.start() : self.stop()
        }
    }
    var isTimerRunning: Bool = false
    
    private var shufflingArray:[String]?
    private var collectionView: UICollectionView?
    private var timer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    convenience init(config: JADBannerViewConfiguration) {
        self.init(frame: CGRect.zero)
        configuration = config
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: configuration!.layout)
        collectionView?.contentInset = configuration!.contentInsets
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.decelerationRate = .fast
        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .never
        }
        collectionView?.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "UICollectionViewCell")
        self.addSubview(collectionView!)
        
    }
    
    @objc func timerMethod(_ timer: Timer) {
        if self.currentPage == 0 {
            self.collectionView?.setContentOffset(CGPoint(x: configuration!.layout.itemSize.width * CGFloat(self.shufflingArray!.count - 2), y: 0), animated: false)
        } else if (self.currentPage == self.shufflingArray!.count) {
            self.collectionView?.setContentOffset(CGPoint(x: configuration!.layout.itemSize.width, y: 0), animated: false)
        } else {
            self.collectionView?.setContentOffset(CGPoint(x: CGFloat(self.currentPage) * configuration!.layout.itemSize.width, y: 0), animated: true)
        }
        if (self.currentPage == self.shufflingArray!.count - 1) {
            self.currentPage = 0;
        }
        self.currentPage += 1
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView?.frame = self.bounds
        if (dataArray?.count ?? 0) >= 2 {
            self.collectionView?.setContentOffset(CGPoint(x: configuration!.layout.itemSize.width, y: 0), animated: false)
        }
    }
    
    func start() {
        guard !isTimerRunning else { return }
        guard isTimerEnabled else { return }
        self.stop()
        timer = Timer(timeInterval: configuration!.timeInterval, target: self, selector: #selector(timerMethod(_:)), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        isTimerRunning = true
    }
    
    func stop() {
        guard isTimerRunning else { return }
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension JADBannerView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.shufflingArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        var imageView = cell.contentView.viewWithTag(10) as? UIImageView
        if imageView == nil {
            imageView = UIImageView(frame: cell.bounds)
            imageView?.tag = 10
            if JADTools.isPad {
                imageView?.contentMode = .scaleAspectFit
            }
            cell.contentView.addSubview(imageView!)
        }
        let pic = shufflingArray![indexPath.row]
        if pic.hasPrefix("http") {
            imageView?.kf.setImage(with: URL(string: pic))
        } else {
            imageView?.image = UIImage(named: pic)
        }
        
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.stop()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.start()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemSize = self.configuration!.layout.itemSize.width
        let viewSize = self.configuration!.layout.viewSize
        let minimumColumnSpacing = self.configuration!.layout.minimumColumnSpacing
        let contentInset = self.configuration!.contentInsets
        var x = itemSize * CGFloat(indexPath.row) + itemSize / 2 - viewSize / 2 + minimumColumnSpacing * CGFloat(indexPath.row)
        
        if indexPath.row == 0 {
            x = x - (itemSize / 2 - viewSize / 2) - contentInset.left
        } else {
            x = x + (itemSize / 2 - viewSize / 2) + contentInset.right
        }
        collectionView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        let index = shufflingArray!.count >= 2 ? indexPath.row - 1 : indexPath.row
        delegate?.clickBannerAtIndex(index)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let itemSize = self.configuration!.layout.itemSize.width
        let viewSize = self.configuration!.layout.viewSize
        let minimumColumnSpacing = self.configuration!.layout.minimumColumnSpacing
//        let contentInset = self.configuration!.contentInsets
        let index = roundf(Float((scrollView.contentOffset.x + minimumColumnSpacing + viewSize / 2 - itemSize / 2) / itemSize))
        self.currentPage = Int(index)
        self.pageControl?.currentPage = Int(index) - 1
        let offsetX = scrollView.contentOffset.x
        if offsetX >= scrollView.frame.size.width * CGFloat(self.shufflingArray!.count - 1) {
            scrollView.setContentOffset(CGPoint(x: scrollView.frame.size.width, y: 0), animated: false)
        } else if offsetX <= 0 {
            scrollView.setContentOffset(CGPoint(x: scrollView.frame.size.width * CGFloat(shufflingArray!.count - 2), y: 0), animated: false)
        }
    }
    
}
