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

class JADScrollSegmentItem: NSObject {
    var id: String = "" //栏目id
    var text: String = ""
    var isSelected: Bool = false
}

typealias JADScrollBehaviorDelegate = UICollectionViewDelegate & UICollectionViewDataSource & JADScrollSegmentDelegate

class JADScrollSegmentView: UIView {
    //MARK: Public
    var delegate: JADScrollSegmentViewDelegate?
    var behaviorDelegate: JADScrollBehaviorDelegate!
    
    let rightAction = JADButton()
    
    var collectionView: UICollectionView?
    var contentInset = UIEdgeInsets.zero {
        didSet {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    var items: [JADScrollSegmentItem]? {
        didSet {
            guard (self.items?.count ?? 0) > 0 else { return }
            currentItem = self.items?[self.selectedSegmentIndex]
            currentItem?.isSelected = true
            collectionView?.reloadData()
        }
    }
    var selectedSegmentIndex: Int = 0 {
        didSet {
            guard self.selectedSegmentIndex < (items?.count ?? 0 - 1) else { return }
            let item = items?[self.selectedSegmentIndex]
            currentItem?.isSelected = false
            currentItem = item
            currentItem?.isSelected = true
            collectionView?.reloadData()
        }
    }
    var currentItem: JADScrollSegmentItem?
    
    //MARK: Private
    static let identifier = "JADScrollSegmentItem"
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(rightAction)
        
        
        let layout = JADScrollSegmentLayout()
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView?.delegate = behaviorDelegate
        collectionView?.dataSource = behaviorDelegate
        collectionView?.extendDelegate = behaviorDelegate
        collectionView?.backgroundColor = UIColor.hex("#FFFFFF")
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 0)
        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .never
        }
        self.addSubview(collectionView!)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        rightAction.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-18)
            make.width.height.equalTo(16)
            make.centerY.equalToSuperview()
        }
        collectionView?.frame = CGRect(x: contentInset.left, y: contentInset.top, width: rightAction.frame.minX - 16 - contentInset.left - contentInset.right, height: self.frame.height - contentInset.top - contentInset.bottom)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
