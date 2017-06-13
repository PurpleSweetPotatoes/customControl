//
//  BQImagePicker.swift
//  HaoJiLai
//
//  Created by baiqiang on 16/11/7.
//  Copyright © 2016年 baiqiang. All rights reserved.
//

import UIKit

enum ClipSizeType {
    case none
    case oneScaleOne
    case twoScaleOne
    case threeScaleTwo
}
/**
 需要在info.plist 文件中添加字段
 Privacy - Photo Library Usage Description //是否允许访问相册
 Privacy - Camera Usage Description        //是否允许是使用相机
 */
class BQImagePicker: NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    //MARK: - ***** Ivars *****
    //单例写法
    private static let sharedInstance = BQImagePicker()
    private override init() {
        //        self.imagePicker = UIImagePickerController()
        //        self.imagePicker.delegate = self;
    }
    lazy var imagePicker:UIImagePickerController = {
        let pickVc = UIImagePickerController()
        pickVc.delegate = self;
        return pickVc;
    }()
    var handle:((UIImage) -> Void)?
    var type:ClipSizeType!
    
    //MARK: - ***** Class Method *****
    class func showPicker(handle:((UIImage) -> Void)?) -> Void {
        self.showPicker(type: ClipSizeType.none, handle: handle)
    }
    class func showPicker(type:ClipSizeType, handle:((UIImage) -> Void)?) -> Void {
        let picker = BQImagePicker.sharedInstance
        picker.type = type
        picker.handle = handle
        var strDatas:[String] = []
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            strDatas.append("拍照")
        }
        strDatas.append("相册")
        BQSheetView.showSheetView(tableDatas: strDatas, title: "获取图像方式") { (index) in
            if strDatas[index] == "拍照" {
                picker.showImagePickVc(type: .camera)
            }else {
                picker.showImagePickVc(type: .photoLibrary)
            }
        }
    }
    //MARK: - ***** initialize Method *****
    private func showImagePickVc(type:UIImagePickerControllerSourceType) -> Void {
        self.imagePicker.sourceType = type
        self.imagePicker.allowsEditing = self.type == ClipSizeType.none
        BQTool.currentVc().present(self.imagePicker, animated: true, completion: nil)
    }
    //MARK: - ***** Instance Method *****
    
    //MARK: - ***** LoadData Method *****
    
    //MARK: - ***** create Method *****
    
    //MARK: - ***** respond event Method *****
    
    //MARK: - ***** Protocol *****
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image: UIImage!
        if self.type == ClipSizeType.none {
            image = info["UIImagePickerControllerEditedImage"] as! UIImage
            picker.dismiss(animated: true, completion: {
                if self.handle != nil {
                    self.handle!(image)
                }
            })
        }else {
            image = info["UIImagePickerControllerOriginalImage"] as! UIImage;
            picker.dismiss(animated: true, completion: {
                BQClipView.showClipView(image: image, type: self.type, handle: self.handle)
            })
        }
        
    }
}

class BQClipView: UIView {
    //MARK: - ***** Ivars *****
    var image: UIImage!
    var type: ClipSizeType
    var imageView: UIImageView!
    var clipLayer: CAShapeLayer!
    var handle:((UIImage) -> Void)?
    var startCenter: CGPoint = CGPoint(x: 0, y: 0)
    var startSacle: CGFloat = 0
    //MARK: - ***** Lifecycle *****
    
    //MARK: - ***** Class Method *****
    class func showClipView(image:UIImage, type:ClipSizeType ,handle:((UIImage) -> Void)?) {
        let clipView = BQClipView.init(image: image, type: type)
        clipView.handle = handle
        UIApplication.shared.keyWindow?.addSubview(clipView)
    }
    //MARK: - ***** initialize Method *****
    init(image:UIImage, type:ClipSizeType) {
        //调用父类的构造函数
        self.image = image
        self.type = type
        super.init(frame: UIScreen.main.bounds)
        self.initUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - ***** Instance Method *****
    func initUI() {
        self.backgroundColor = UIColor.gray
        self.imageView = UIImageView(image: self.image)
        self.imageView.frame = CGRect(x: 0, y: 0, width: self.width, height: self.image.size.height * self.width / self.image.size.width)
        self.imageView.center = self.center
        
        self.imageView.isUserInteractionEnabled = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(gestureRecognizerChange(gesture:)))
        self.imageView.addGestureRecognizer(pan)
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(gestureRecognizerChange(gesture:)))
        self.imageView.addGestureRecognizer(pinch)
        self.addSubview(self.imageView)
        self.createLayer()
        self.createBtn(frame: CGRect(x: 40, y: self.height - 70, width: 50, height: 30), title: "取消", tag: 100)
        self.createBtn(frame: CGRect(x: self.width - 90, y: self.height - 70, width: 50, height: 30), title: "裁剪", tag: 101)
    }
    
    func createLayer() {
        self.clipLayer = CAShapeLayer()
        var width = self.width / 4.0
        var height: CGFloat = 0
        switch self.type {
        case ClipSizeType.oneScaleOne:
            width = self.width / 3.0
            height = width
            break
        case ClipSizeType.twoScaleOne:
            height = width;
            width *= 2;
            break
        case ClipSizeType.threeScaleTwo:
            height = width * 2;
            width *= 3;
            break
        default:
            break
        }
        
        self.clipLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        self.clipLayer.position = self.center
        let length:CGFloat = 20
        let path = UIBezierPath()
        //左上角
        path.move(to: CGPoint(x: 0, y: length))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: length, y: 0))
        //右上角
        path.move(to: CGPoint(x: width - length, y: 0))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: length))
        //右下角
        path.move(to: CGPoint(x: width, y: height - length))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: width - 20, y: height))
        //左下角
        path.move(to: CGPoint(x: length, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: height - length))
        
        self.clipLayer.path = path.cgPath
        self.clipLayer.lineWidth = 3.0
        self.clipLayer.strokeColor = UIColor.green.cgColor
        self.clipLayer.fillColor = UIColor.clear.cgColor
        
        width = self.width
        height = self.height
        self.addMaskLayer(frame: CGRect(x: 0, y: 0, width: width, height: self.clipLayer.frame.origin.y))
        self.addMaskLayer(frame: CGRect(x: 0, y: self.clipLayer.frame.origin.y, width: self.clipLayer.frame.origin.x, height: self.clipLayer.frame.size.height))
        self.addMaskLayer(frame: CGRect(x: 0, y: self.clipLayer.frame.maxY, width: width, height: height - self.clipLayer.frame.maxY))
        self.addMaskLayer(frame: CGRect(x: self.clipLayer.frame.maxX, y: self.clipLayer.frame.origin.y, width: width - self.clipLayer.frame.maxX, height: self.clipLayer.frame.size.height))
        self.layer.addSublayer(self.clipLayer)
    }
    func addMaskLayer(frame: CGRect) {
        let maskLayer = CAShapeLayer()
        maskLayer.frame = frame
        maskLayer.backgroundColor = UIColor(white: 0.2, alpha: 0.7).cgColor
        self.layer.addSublayer(maskLayer)
    }
    //MARK: - ***** LoadData Method *****
    
    //MARK: - ***** create Method *****
    func  createBtn(frame:CGRect, title:String?, tag:Int) {
        let btn = UIButton(type: .custom)
        btn.addTarget(self, action: #selector(btnAction(btn:)), for: UIControlEvents.touchUpInside)
        btn.frame = frame
        btn.tag = tag
        btn.setTitle(title, for: UIControlState.normal)
        self.addSubview(btn)
    }
    //MARK: - ***** respond event Method *****
    func gestureRecognizerChange(gesture:UIGestureRecognizer){
        if gesture.isKind(of: UIPanGestureRecognizer.self) {
            let pan = gesture as! UIPanGestureRecognizer
            switch pan.state {
            case .began:
                self.startCenter = self.imageView.center
                break
            case .changed:
                let translation = pan.translation(in: self)
                self.imageView.center = CGPoint(x: self.startCenter.x + translation.x, y: self.startCenter.y + translation.y)
                break
            case .ended:
                self.startCenter = CGPoint(x: 0, y: 0)
                if self.imageView.frame.origin.x > self.clipLayer.frame.origin.x {
                    UIView.animate(withDuration: 0.1, animations: {
                        var frame = self.imageView.frame;
                        frame.origin.x = self.clipLayer.frame.origin.x;
                        self.imageView.frame = frame;
                    })
                }
                if (self.imageView.frame.maxX < self.clipLayer.frame.maxX) {
                    UIView.animate(withDuration: 0.1, animations: {
                        var frame = self.imageView.frame;
                        frame.origin.x = self.clipLayer.frame.maxX - frame.size.width;
                        self.imageView.frame = frame;
                    })
                }
                if self.imageView.frame.origin.y > self.clipLayer.frame.origin.y {
                    UIView.animate(withDuration: 0.1, animations: {
                        var frame = self.imageView.frame;
                        frame.origin.y = self.clipLayer.frame.origin.y;
                        self.imageView.frame = frame;
                    })
                }
                if (self.imageView.frame.maxY < self.clipLayer.frame.maxY) {
                    UIView.animate(withDuration: 0.1, animations: {
                        var frame = self.imageView.frame;
                        frame.origin.y = self.clipLayer.frame.maxY - frame.size.height;
                        self.imageView.frame = frame;
                    })
                }
                break
            default:
                break
            }
        }else {
            let pinch = gesture as! UIPinchGestureRecognizer
            switch pinch.state {
            case .began:
                startSacle = pinch.scale
                break
            case .changed:
                let scale = (pinch.scale - startSacle) + 1
                
                self.imageView.transform = self.imageView.transform.scaledBy(x: scale, y: scale)
                startSacle = pinch.scale
                break
            case .ended:
                startSacle = 1
                if self.imageView.frame.size.width < self.clipLayer.bounds.size.width || self.imageView.frame.size.height < self.clipLayer.bounds.size.height {
                    UIView.animate(withDuration: 0.1, animations: {
                        self.imageView.frame = CGRect(x: 0,y: 0,width: self.bounds.size.width, height: self.image.size.height * self.width / self.image.size.width);
                        self.imageView.center = self.center;
                    })
                }
                break
            default:
                break
            }
        }
    }
    func btnAction(btn:UIButton) {
        if btn.tag == 101 {
            self.clipLayer.isHidden = true
            let scale = UIScreen.main.scale
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, scale)
            self.layer.render(in: UIGraphicsGetCurrentContext()!)
            let img = UIGraphicsGetImageFromCurrentImageContext()!
            let backImage = UIImage(cgImage: img.cgImage!.cropping(to: CGRect(x: self.clipLayer.frame.origin.x * scale, y: self.clipLayer.frame.origin.y * scale, width: self.clipLayer.frame.size.width * scale, height: self.clipLayer.frame.size.height * scale))!)
            UIGraphicsEndImageContext()
            if self.handle != nil {
                self.handle!(backImage)
            }
        }
        self.removeFromSuperview()
    }
}
