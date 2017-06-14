//
//  BQSheetView.swift
//  swift-Test
//
//  Created by MrBai on 2017/6/13.
//  Copyright © 2017年 MrBai. All rights reserved.
//

import UIKit

enum SheetType {
    case table
    case collection
}

class BQSheetView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //MARK: - ***** Ivars *****
    private var title: String?
    private var type: SheetType!
    private var tableDatas: [String] = []
    private var shareDatas: [Dictionary<String,String>] = []
    private var backView: UIView!
    private var bottomView: UIView!
    private var callBlock: ((Int) -> ())!
    //MARK: - ***** Class Method *****
    class func showSheetView(tableDatas:[String] ,title:String? = nil, handle:@escaping (Int)->()) {
        let sheetView = BQSheetView(tableDatas: tableDatas, title: title)
        sheetView.callBlock = handle
        UIApplication.shared.keyWindow?.addSubview(sheetView)
        sheetView.startAnimation()
    }
    
    /// 弹出脚部分享视图
    ///
    /// - Parameters:
    ///   - shareDatas: ["image":"图片名"]
    ///   - title: 抬头名称
    ///   - handle: 回调方法
    class func showShareView(shareDatas:[Dictionary<String,String>] ,title:String, handle:@escaping (Int)->()) {
        let sheetView = BQSheetView(shareDatas: shareDatas, title: title)
        sheetView.callBlock = handle
        UIApplication.shared.keyWindow?.addSubview(sheetView)
        sheetView.startAnimation()
    }
    //MARK: - ***** initialize Method *****
    
    private init(tableDatas:[String] ,title:String? = nil) {
        self.title = title
        self.type = .table
        self.tableDatas = tableDatas
        super.init(frame: UIScreen.main.bounds)
        self.initData()
        self.initUI()
    }
    private init(shareDatas:[Dictionary<String,String>] ,title:String? = nil) {
        self.title = title
        self.type = .collection
        self.shareDatas = shareDatas
        super.init(frame: UIScreen.main.bounds)
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
        self.backView.backgroundColor = UIColor(white: 0.3, alpha: 0.6)
        self.backView.alpha = 0
        self.backView.addTapGes {[weak self] (view) in
            self?.removeAnimation()
        }
        self.addSubview(self.backView)
        self.bottomView = UIView(frame: CGRect(x: 0, y: self.height, width: self.width, height: 0))
        self.addSubview(self.bottomView)
        var top: CGFloat = 0
        if self.type == .table {
            top = self.createTableUI(y: top)
        }else {
            top = self.createShareUI(y: top)
        }
        self.bottomView.height = top + 8
    }
    
    private func startAnimation() {
        UIView.animate(withDuration: 0.25) {
            self.bottomView.top = self.height - self.bottomView.height
            self.backView.alpha = 1
        }
    }
    private func removeAnimation() {
        UIView.animate(withDuration: 0.25, animations: {
            self.bottomView.top = self.height
            self.backView.alpha = 0
        }) { (flag) in
            self.removeFromSuperview()
        }
    }
    //MARK: - ***** LoadData Method *****
    
    //MARK: - ***** respond event Method *****
    @objc private func tableBtnAction(btn:UIButton) {
        self.callBlock(btn.tag)
        self.removeAnimation()
    }
    
    //MARK: - ***** Protocol *****
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.shareDatas.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BQShareItemCell", for: indexPath) as! BQShareItemCell
        cell.loadInfo(dic: self.shareDatas[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.callBlock(indexPath.row)
        self.removeAnimation()
    }
    
    //MARK: - ***** create Method *****
    private func createTableUI(y:CGFloat) -> CGFloat {
        var top = y
        let spacing: CGFloat = 20
        let height: CGFloat = 44
        let labWidth: CGFloat = self.width - spacing * 2
        if let titl = self.title {
            let lab = UILabel(frame: CGRect(x: spacing, y: top, width: labWidth, height: height))
            lab.text = titl
            lab.textAlignment = .center
            lab.numberOfLines = 0
            lab.font = UIFont.systemFont(ofSize: 14)
            lab.textColor = UIColor.gray
            let labHeight = titl.boundingRect(with: CGSize(width: labWidth, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:lab.font], context: nil).size.height + 20
            lab.height = labHeight
            self.bottomView.addSubview(lab)
            lab.setCornerColor(color: UIColor.white, readius: 8, corners: [.topLeft,.topRight])
            top = labHeight
        }
        
        top += 1
        var count = 0
        for str in self.tableDatas {
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: spacing, y: top, width: labWidth, height: height)
            btn.setTitle(str, for: .normal)
            btn.tag = count
            btn.titleLabel?.textAlignment = .center
            btn.setTitleColor(UIColor.black, for: .normal)
            btn.addTarget(self, action: #selector(tableBtnAction(btn:)), for: .touchUpInside)
            self.bottomView.addSubview(btn)
            if count == self.tableDatas.count - 1 {
                btn.setCornerColor(color: UIColor.white, readius: 8, corners: [.bottomLeft,.bottomRight])
                
            }else {
                if count == 0 && self.title == nil {
                    btn.setCornerColor(color: UIColor.white, readius: 8, corners: [.topLeft,.topRight])
                }else {
                    btn.backgroundColor = UIColor.white
                }
            }
            count += 1
            top = btn.bottom + 1
        }
        top += 7
        let lab = UILabel(frame: CGRect(x: spacing, y: top, width: labWidth, height: height))
        lab.text = "返回"
        lab.layer.cornerRadius = 8
        lab.layer.masksToBounds = true
        lab.textAlignment = .center
        lab.backgroundColor = UIColor.white
        lab.addTapGes(action: {[weak self] (view) in
            self?.removeAnimation()
        })
        self.bottomView.addSubview(lab)
        return lab.bottom
    }
    private func createShareUI(y:CGFloat) -> CGFloat {
        var top = y
        let spacing: CGFloat = 10
        let labWidth: CGFloat = self.width - spacing * 2
        let itemWidth = labWidth / 4.0
        if let titl = self.title {
            let lab = UILabel(frame: CGRect(x: spacing, y: top, width: labWidth, height: height))
            lab.text = titl
            lab.textAlignment = .center
            lab.numberOfLines = 0
            lab.font = UIFont.systemFont(ofSize: 14)
            lab.textColor = UIColor.gray
            let labHeight = titl.boundingRect(with: CGSize(width: labWidth, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:lab.font], context: nil).size.height + 20
            lab.height = labHeight
            self.bottomView.addSubview(lab)
            lab.setCornerColor(color: UIColor.white, readius: 8, corners: [.topLeft,.topRight])
            top = labHeight
        }
        top += 1
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.scrollDirection = .vertical
        var num = self.shareDatas.count / 4
        if self.shareDatas.count % 4 > 0 {
            num += 1
        }
        let collectionView = UICollectionView(frame: CGRect(x: spacing, y: top, width: labWidth, height: CGFloat(num) * itemWidth), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.register(BQShareItemCell.classForCoder(), forCellWithReuseIdentifier: "BQShareItemCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        self.bottomView.addSubview(collectionView)
        top = collectionView.bottom + 1
        let lab = UILabel(frame: CGRect(x: spacing, y: top, width: labWidth, height: 44))
        lab.text = "返回"
        lab.textAlignment = .center
        lab.addTapGes(action: {[weak self] (view) in
            self?.removeAnimation()
        })
        self.bottomView.addSubview(lab)
        lab.setCornerColor(color: UIColor.white, readius: 8, corners: [.bottomLeft,.bottomRight])
        return lab.bottom
    }
}

class BQShareItemCell: UICollectionViewCell {
    
    private var imgView: UIImageView!
    private var titleLab: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    private func initUI() {
        let imgWidth = self.width / 2.0
        let spacing = (self.width - imgWidth) * 0.5
        let imageView = UIImageView(frame: CGRect(x: spacing, y: spacing * 0.7, width: imgWidth, height: imgWidth))
        self.contentView.addSubview(imageView)
        self.imgView = imageView
        
        let lab = UILabel(frame: CGRect(x: 0, y: imageView.bottom, width: self.width, height: spacing))
        lab.textAlignment = .center
        lab.font = UIFont.systemFont(ofSize: 13)
        lab.textColor = UIColor.gray
        self.contentView.addSubview(lab)
        self.titleLab = lab
    }
    public func loadInfo(dic:Dictionary<String,String>) {
        self.imgView.image = UIImage(named:dic["image"] ?? "")
        self.titleLab.text = dic["image"]
    }
}
