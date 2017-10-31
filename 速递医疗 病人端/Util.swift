//
//  Util.swift


import UIKit
import Kingfisher

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let APPLICATION = UIApplication.shared.delegate as! AppDelegate
let ERRORMSG = "获取服务器数据失败"
let CATCHMSG = "解析服务器数据失败"

//日志打印
public func dPrint<N>(message:N,fileName:String = #file,methodName:String = #function,lineNumber:Int = #line){
    #if DEBUG
        print("------ BEGIN \n\(fileName as NSString)\n方法:\(methodName)\n行号:\(lineNumber)\n打印信息:\(message)\n------ end");
    #endif
}

struct StaticClass {
    static let BaseApi = "http://1842719ny8.iok.la:14086/internetmedical/user"
}

// UserDefault 相关
class UserDefaultUtil: NSObject {
    //UserDefaults 进行本地存储
    class func setUserDefault(key:String, value:Any){
        UserDefaults.standard.set(value, forKey: key)
    }
    
    //UserDefaults 获取string数据
    
    class func getUserDefaultStringValue(key:String, defaultValue: String) -> String{
        
        let res = UserDefaults.standard.string(forKey: key)
        if res != nil{
            return res!
        }
        return defaultValue
    }
    
    //UserDefaults 获取Bool数据
    
    class func getUserDefaultBoolValue(key:String) -> Bool{
        let res = UserDefaults.standard.bool(forKey: key)
        return res
    }
    //UserDefaults 清空数据
    class func clearUserDefaultValue(key:String){
        UserDefaults.standard.removeObject(forKey: key)
    }
}

// Alert 相关
class AlertUtil: NSObject {
    //显示toast
    public func showToast(vc:UIViewController, text:String){
        let alertController = UIAlertController(title: text,
                                                message: nil, preferredStyle: .alert)
        //显示提示框
        vc.present(alertController, animated: true, completion: nil)
        //两秒钟后自动消失
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            vc.presentedViewController?.dismiss(animated: false, completion: nil)
        }
        
    }
    
    /**
     选择弹出框
     - parameter title: 标题
     - parameter msg:   消息
     - parameter btns:  弹框项
     */
    func popMenu(vc:UIViewController, title:String,msg:String,btns:[String], handler:@escaping (_ value: String)->()) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert);
        
        for i in 0 ..< btns.count {
            
            let btn = UIAlertAction(title: btns[i], style: .default) { (UIAlertAction) -> Void in
                
                handler(UIAlertAction.title!)
                
            }
            alert.addAction(btn)
        }
        
        //    let btn = UIAlertAction(title: "取消", style:.cancel, handler: nil)
        //
        //    alert.addAction(btn);
        
        vc.present(alert, animated: true,completion: nil);
    }
    
    func popAlert(vc:UIViewController, msg:String, okhandler: @escaping ()->())
    {
        // 弹出提示框
        let alertController = UIAlertController(title: "提示",
                                                message: msg, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确认", style: .default, handler: {
            action in
            okhandler()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        vc.present(alertController, animated: true, completion: nil)
    }
}

class ImageUtil{
    //设置图片
    class public func setImage(path:String, imageView:UIImageView){
        let url = URL(string:path)
        imageView.kf.setImage(with: url)
    }
    
    // 图片转为Data类型
    class public func image2Data(image:UIImage) -> Data{
        return UIImageJPEGRepresentation(image, 0.1)!
    }
}

class TimeUTil {
    
    // 将时间戳转换为时间字符串
    class public func timestamp2string(timeStamp:Int) -> String{
        //转换为时间
        let timeInterval:TimeInterval = TimeInterval(timeStamp/1000)
        let date = Date(timeIntervalSince1970: timeInterval)
        
        //格式化输出
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dformatter.string(from: date)
    }
    
    // 获取当前系统时间字符串
    class public func getCurTimeStr() -> String{
        let date = NSDate()
        
        let timeFormatter = DateFormatter()
        
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let strNowTime = timeFormatter.string(from:date as Date) as String
        return strNowTime
    }
    
    // 获取显示时间（几分钟前，几小时前，几天前）
    class public func getComparedTimeStr(str:String) -> String{
        //把字符串转为NSdate
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timeDate = timeFormatter.date(from: str)
        let currentDate = NSDate()
        
        // 获得时间差
        let timeInterval = currentDate.timeIntervalSince(timeDate!)
        var temp = 0
        var result:String?
        
        //处理时间差
        if timeInterval / 60 < 1{
            result = "刚刚"
        }
        else if timeInterval/60 < 60 {
            temp = Int(timeInterval/60)
            result = "\(temp)分钟前"
        }
        else if timeInterval / 60 / 60 < 24 {
            temp = Int(timeInterval / 60 / 60)
            result = "\(temp)小时前"
        }
        else if timeInterval / 60 / 60 / 24 < 30{
            temp = Int(timeInterval / 60 / 60 / 24)
            result = "\(temp)天前"
        }
        else if timeInterval / 60 / 60 / 24 / 30 < 12 {
            temp = Int(timeInterval / 60 / 60 / 24 / 30)
            result = "\(temp)个月前"
        } else{
            temp = Int(timeInterval / 60 / 60 / 24 / 30 / 12)
            result = "\(temp)年前"
        }
        
        return  result!;
        
    }
    
}
