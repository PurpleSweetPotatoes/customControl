//
//  BQPhotoBrowserView.swift
//  swift-test
//
//  Created by baiqiang on 2017/6/17.
//  Copyright © 2017年 baiqiang. All rights reserved.
//

import UIKit

private let identifi = "PhotoCollectionCell"

class BQPhotoBrowserView: UIView {
    
    //MARK: - ***** Ivars *****
    fileprivate var datas: [UIImageView]!
    fileprivate var pageControl: UIPageControl!
    private var collectionView:UICollectionView!
    private var index: Int = 0
    private var backView: UIView!
    private var animationView: UIImageView!
    //MARK: - ***** Class Method *****
    
    class func show(datas:[UIImageView], current: Int = 0) {
        let browser = BQPhotoBrowserView(frame: UIScreen.main.bounds, datas: datas, current: current)
        UIApplication.shared.keyWindow?.addSubview(browser)
        browser.startAnimation()
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
        self.backView = UIView(frame: self.bounds)
        self.backView.backgroundColor = UIColor.black
        self.addSubview(self.backView)
        self.createCollection()
        self.createPageContrl()
        self.animationView = UIImageView(frame: CGRect.zero)
        self.addSubview(self.animationView)
        self.collectionView.scrollToItem(at: IndexPath(item: self.index, section: 0), at: .centeredHorizontally, animated: false)
    }
    private func startAnimation() {
        let imgView = self.datas[self.index]
        self.animationView.frame = imgView.superview!.convert(imgView.frame, to: UIApplication.shared.keyWindow?.rootViewController?.view)
        self.backView.alpha = 0
        self.collectionView.alpha = 0
        self.pageControl.alpha = 0
        
        UIView.animate(withDuration: 0.25, animations: {
            self.configImgFrame(imgView: imgView)
            self.backView.alpha = 1
        }) { (flag) in
            self.animationView.alpha = 0
            self.collectionView.alpha = 1
            self.pageControl.alpha = 1
        }
    }
    fileprivate func removeSelf(row:Int)  {
        print("第\(row)个被点击")
        self.index = row
        let imgView = self.datas[self.index]
        let toFrame = imgView.superview!.convert(imgView.frame, to: UIApplication.shared.keyWindow?.rootViewController?.view)
        self.configImgFrame(imgView: imgView)
        self.animationView.alpha = 1
        self.collectionView.alpha = 0
        self.pageControl.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.backView.alpha = 0
            self.animationView.frame = toFrame
        }) { (finish) in
            self.removeFromSuperview()
        }
    }
    func configImgFrame(imgView:UIImageView) {
        let imgSize = imgView.image!.size
        let height = imgSize.height * (self.width - 16) / imgSize.width
        let frame = CGRect(x: 8, y: (self.height - height) * 0.5, width: (self.width - 16), height: height)
        self.animationView.image = self.datas[self.index].image
        self.animationView.frame = frame
    }
    //MARK: - ***** LoadData Method *****
    
    //MARK: - ***** respond event Method *****
    
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
        self.collectionView.register(PhotoCollectionCell.classForCoder(), forCellWithReuseIdentifier: identifi)
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

extension BQPhotoBrowserView: UICollectionViewDelegate, UICollectionViewDataSource, PhotoCellDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.datas.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifi, for: indexPath) as! PhotoCollectionCell
        cell.delegate = self
        cell.row = indexPath.row
        cell.setImage(img: self.datas[indexPath.row].image)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photoCell = cell as! PhotoCollectionCell
        photoCell.photoView.zoomNormal()
    }
    func photoTapAction(row: Int) {
        self.removeSelf(row: row)
    }
}

extension BQPhotoBrowserView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.pageControl.currentPage = Int((scrollView.contentOffset.x + scrollView.width * 0.5) / scrollView.width)
    }
}

protocol PhotoCellDelegate: NSObjectProtocol {
    func photoTapAction(row:Int)
}

class PhotoCollectionCell: UICollectionViewCell {
    fileprivate var photoView: BQPhotoView!
    weak var delegate: PhotoCellDelegate?
    var row: Int = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        let photoView = BQPhotoView(frame:CGRect(x: 8, y: 0, width: UIScreen.main.bounds.width - 16, height: UIScreen.main.bounds.height))
        self.contentView.addSubview(photoView)
        self.photoView = photoView
        self.photoView.tapAction {[weak self] (ges) in
            self?.delegate?.photoTapAction(row: (self?.row)!)
        }
    }
    func setImage(img:UIImage?) {
        if let image = img {
            let imgSize = image.size
            let height = imgSize.height * self.photoView.width / imgSize.width
            let frame = CGRect(x: 0, y: (self.photoView.height - height) * 0.5, width: self.photoView.width, height: height)
            self.photoView.imageView.frame = frame
            self.photoView.imageView.image = img
        }else {
            self.photoView.imageView.image = nil
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


