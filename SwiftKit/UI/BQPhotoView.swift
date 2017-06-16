//
//  BQPhotoView.swift
//  swift-test
//
//  Created by baiqiang on 2017/6/16.
//  Copyright © 2017年 baiqiang. All rights reserved.
//

import UIKit

class BQPhotoView: UIView {

    //MARK: - ***** Ivars *****
    private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.black
        return imageView
    }()
    private var singleTapAction: ((UITapGestureRecognizer) -> ())?
    fileprivate var scrollView: UIScrollView!
    //MARK: - ***** initialize Method *****
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
        self.initGesture()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - ***** public Method *****
    func tapAction(handle:@escaping (UITapGestureRecognizer) -> ()) {
        self.singleTapAction = handle
    }
    //MARK: - ***** private Method *****
    private func initGesture() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(ges:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(ges:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.numberOfTouchesRequired = 1
        // 允许优先执行doubleTap, 在doubleTap执行失败的时候执行singleTap, 如果没有设置这个, 那么将只会执行singleTap 不会执行doubleTap
        singleTap.require(toFail: doubleTap)
        self.addGestureRecognizer(singleTap)
        self.addGestureRecognizer(doubleTap)
    }
    private func initUI() {
        self.addScrollView()
    }
    
    //MARK: - ***** LoadData Method *****
    
    //MARK: - ***** respond event Method *****
    // 单击手势, 给外界处理
    @objc private func handleSingleTap(ges: UITapGestureRecognizer) {
        // 首先缩放到最小倍数, 以便于执行退出动画时frame可以同步改变
        if scrollView.zoomScale != scrollView.minimumZoomScale {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: false)
        }
        singleTapAction?(ges)
    }
    @objc private func handleDoubleTap(ges: UITapGestureRecognizer) {
        if self.imageView.image == nil {
            return
        }
        if scrollView.zoomScale <= scrollView.minimumZoomScale {
            let location = ges.location(in: scrollView)
            let width = scrollView.width/scrollView.maximumZoomScale
            let height = scrollView.height/scrollView.maximumZoomScale
            let rect = CGRect(x: location.x * (1 - 1/scrollView.maximumZoomScale), y: location.y * (1 - 1/scrollView.maximumZoomScale), width: width, height: height)
            scrollView.zoom(to: rect, animated: true)
        }else {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        }
    }
    //MARK: - ***** create Method *****
    private func addScrollView() {
        let scrollView = UIScrollView(frame:self.bounds)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.clipsToBounds = true
        scrollView.backgroundColor = UIColor.black
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 1.0
        scrollView.delegate = self
        self.imageView.frame = scrollView.bounds
        scrollView.addSubview(self.imageView)
        self.addSubview(scrollView)
        self.scrollView = scrollView
    }
}
//MARK:- ***** scrollviewDelegate *****
extension BQPhotoView : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        // 居中显示图片
        setImageViewToTheCenter()
    }
    // 居中显示图片
    func setImageViewToTheCenter() {
        let offsetX = (scrollView.width > scrollView.contentSize.width) ? (scrollView.width - scrollView.contentSize.width)*0.5 : 0.0
        let offsetY = (scrollView.height > scrollView.contentSize.height) ? (scrollView.height - scrollView.contentSize.height)*0.5 : 0.0
        
        imageView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
        
    }
}
