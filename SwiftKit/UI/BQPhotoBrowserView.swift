//
//  BQPhotoBrowserView.swift
//  swift-test
//
//  Created by baiqiang on 2017/6/17.
//  Copyright © 2017年 baiqiang. All rights reserved.
//

import UIKit

private let identifi = "UICollectionViewCell"

class BQPhotoBrowserView: UIView {

    //MARK: - ***** Ivars *****
    fileprivate var datas: [UIImageView]!
    fileprivate var pageControl: UIPageControl!
    private var collectionView:UICollectionView!
    private var index: Int = 0
    //MARK: - ***** Class Method *****
    
    class func show(datas:[UIImageView], current: Int = 0) {
        let browser = BQPhotoBrowserView(frame: UIScreen.main.bounds, datas: datas, current: current)
        UIApplication.shared.keyWindow?.addSubview(browser)
    }
    //MARK: - ***** initialize Method *****
    
    private init(frame: CGRect, datas:[UIImageView], current: Int = 0) {
        super.init(frame: frame)
        self.datas = datas
        self.index = current
        self.initData()
        self.initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - ***** public Method *****
    
    //MARK: - ***** private Method *****
    private func initData() {
        
    }
    private func initUI() {
        self.createCollection()
        self.createPageContrl()
    }
    //MARK: - ***** LoadData Method *****
    
    //MARK: - ***** respond event Method *****
    
    //MARK: - ***** Protocol *****
    
    //MARK: - ***** create Method *****
    func createCollection() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = UIScreen.main.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        self.collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.isPagingEnabled = true
        self.collectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: identifi)
        self.addSubview(self.collectionView)
    }
    func createPageContrl() {
        self.pageControl = UIPageControl(frame: CGRect(x: 0, y: 0, width: self.width, height: 30))
        self.pageControl.center = CGPoint(x: self.width * 0.5, y: self.height - 70)
        self.pageControl.numberOfPages = self.datas.count
        self.pageControl.currentPage = self.index
        self.addSubview(self.pageControl)
    }
}

extension BQPhotoBrowserView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.datas.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifi, for: indexPath)
        cell.backgroundColor = UIColor.randomColor
        return cell
    }
}

extension BQPhotoBrowserView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.pageControl.currentPage = Int((scrollView.contentOffset.x + scrollView.width * 0.5) / scrollView.width)
    }
}
