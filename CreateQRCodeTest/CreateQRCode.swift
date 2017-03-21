//
//  ViewController.swift
//  CreateQRCodeTest
//
//  Created by jay on 2017/3/14.
//  Copyright © 2017年 Jay. All rights reserved.
//

import UIKit

class CreateQRCode: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var btnAction: UIButton!
    @IBOutlet weak var imgQRcode: UIImageView!
    @IBOutlet weak var slider: UISlider!
    
    var qrcodeImage: CIImage!
    
    @IBAction func performButtonAction(_ sender: Any) {
        if qrcodeImage == nil {
            if textField.text == "" {
                return
            }
            
            //設定輸入框輸入資料用data承接
            let data = textField.text?.data(using: String.Encoding.utf8, allowLossyConversion: false)
            
            let filter = CIFilter(name: "CIQRCodeGenerator")
            
            filter?.setValue(data, forKey: "inputMessage")
            filter?.setValue("Q", forKey: "inputCorrectionLevel")
            
            qrcodeImage = filter?.outputImage
            
            //UIImage來接CIImage呈現
//            imgQRcode.image = UIImage(ciImage: qrcodeImage)
            
            //因為QRCode圖片要清晰配合所拉image畫面大小，所以改用function的方式來給照片
            displayQRCodeImage()
            
            
            
            //將按鈕改成"Clear"
            btnAction.setTitle("Clear", for: .normal)
            
            slider.isHidden = false
            textField.isEnabled = false
            
            //收鍵盤
            textField.resignFirstResponder()
            
        } else {
            imgQRcode.image = nil
            qrcodeImage = nil
            slider.isHidden = true
            textField.isEnabled = true
            btnAction.setTitle("Creat", for: .normal)
        }
        
    }
    
    func displayQRCodeImage() {
        let scaleX = imgQRcode.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = imgQRcode.frame.size.height / qrcodeImage.extent.size.height
        
        let transformedImage = qrcodeImage.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        imgQRcode.image = UIImage(ciImage: transformedImage)
        
    }
    
    @IBAction func changeImageViewScale(_ sender: Any) {
        
        imgQRcode.transform = CGAffineTransform(scaleX: CGFloat(slider.value), y: CGFloat(slider.value))
        
    }
    
    
    // 按空白處會隱藏編輯狀態
    func hideKeyboard(_ tapG:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slider.isHidden = true
        
        
        // 增加一個觸控事件，收鍵盤。
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateQRCode.hideKeyboard(_:)))
        // 加在最基底的 self.view 上
        self.view.addGestureRecognizer(tap)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

