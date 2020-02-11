//
//  JADScrollSegmentView.swift
//  JADTransfer
//
//  Created by iOS on 2019/10/21.
//  Copyright © 2019 Jason. All rights reserved.
//

import UIKit

protocol JADScrollSegmentViewDelegate {
    func segment(segment: JADScrollSegmentView, index: Int)
}

typealias JADScrollBehaviorDelegate = UICollectionViewDelegate & UICollectionViewDataSource & JADScrollSegmentDelegate

class JADScrollSegmentView: UIView {
    //MARK: Public
    var delegate: JADScrollSegmentViewDelegate?
    ///必须设置这个代理
    var behaviorDelegate: JADScrollBehaviorDelegate!
    var itemInset = UIEdgeInsets.zero {
        didSet {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    var items: [Any]? {
        didSet {
            guard (self.items?.count ?? 0) > 0 else { return }
            tagItems =  self.items?.map({ (data) -> JADSegmentItem in
                return JADSegmentItem(data)
            })
            tagItem = self.tagItems?[self.selectedSegmentIndex]
            tagItem?.isSelected = true
            collectionView?.reloadData()
        }
    }
    var selectedSegmentIndex: Int = 0 {
        didSet {
            guard self.selectedSegmentIndex < (items?.count ?? 0 - 1) else { return }
            let item = tagItems?[self.selectedSegmentIndex]
            tagItem?.isSelected = false
            tagItem = item
            tagItem?.isSelected = true
            collectionView?.reloadData()
        }
    }
    var currentItem: Any? {
        return tagItem?.extraData
    }
    private var tagItems: [JADSegmentItem]?
    private var tagItem: JADSegmentItem?
    
    private var collectionView: UICollectionView?
    
    init(frame: CGRect? = CGRect.zero, collectionView callBack: ((UICollectionView) -> Void)?) {
        super.init(frame: frame ?? CGRect.zero)
        let layout = JADScrollSegmentLayout()
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView?.delegate = behaviorDelegate
        collectionView?.dataSource = behaviorDelegate
        collectionView?.extendDelegate = behaviorDelegate
        collectionView?.backgroundColor = UIColor.white
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 0)
        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .never
        }
        self.addSubview(collectionView!)
        callBack?(collectionView!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView?.frame = CGRect(x: itemInset.left, y: itemInset.top, width: itemInset.left - itemInset.right, height: self.frame.height - itemInset.top - itemInset.bottom)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate class JADSegmentItem {
    var isSelected: Bool = false
    var extraData: Any
    init(_ model: Any) {
        extraData = model
    }
}

protocol JADScrollSegmentDelegate {
    func itemWidth(index: Int) -> CGFloat
}

fileprivate var extendDelegateKey = "extendDelegateKey"
fileprivate extension UICollectionView {
    var extendDelegate: JADScrollSegmentDelegate? {
        set {
            objc_setAssociatedObject(self, &extendDelegateKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &extendDelegateKey) as? JADScrollSegmentDelegate
        }
    }
}

fileprivate class JADScrollSegmentLayout: UICollectionViewLayout {
    
    var itemHeight: CGFloat = 32
    var minimumColumnSpacing: CGFloat = 14
    private var items = [UICollectionViewLayoutAttributes]()
    private var widths = [CGFloat]()
    private var currentOffset:CGFloat = 0.0 //标记坐标位置
    
    
    override func prepare() {
        super.prepare()
        currentOffset = 0.0
        items.removeAll()
        widths.removeAll()
        let cellCount = self.collectionView?.numberOfItems(inSection: 0) ?? 0
        for i in 0 ..< cellCount {
            widths.append(self.collectionView?.extendDelegate?.itemWidth(index: i) ?? 0)
        }
        for i in 0 ..< cellCount {
            let indexPath = IndexPath(item: i, section: 0)
            let attribute = self.layoutAttributesForItem(at: indexPath)
            items.append(attribute!)
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let width = widths[indexPath.row]
        attributes.frame = CGRect(x: currentOffset, y: 0, width: width, height: itemHeight)
        currentOffset += (width + minimumColumnSpacing)
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return items
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return !newBounds.equalTo(self.collectionView!.bounds)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: currentOffset , height: self.collectionView!.frame.height)
    }
    
}
