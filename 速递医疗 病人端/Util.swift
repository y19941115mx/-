//
//  Util.swift


import UIKit
import Kingfisher
import Toast_Swift
import Alamofire
import Moya
import SVProgressHUD
import ObjectMapper
import SwiftyJSON
import SwiftHash
import RealmSwift

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let APPLICATION = UIApplication.shared.delegate as! AppDelegate
let ERRORMSG = "获取服务器数据失败"
let CATCHMSG = "解析服务器数据失败"

struct StaticClass {
    static let RootIP = "http://118.89.172.204:6221"
    
    //    static let RootIP = "http://1842719ny8.iok.la:14086"
    //    static let RootIP = "http://120.77.32.15:8080"
    static let BaseApi = RootIP + "/internetmedical/user"
    static let PictureIP = RootIP + "/picture/"
    static let GetDept = RootIP + "/internetmedical/doctor/getdept"
    static let TuisongAPIKey = "vGiSGpkn8LDk5U7GB7wEtS1r"
    static let GaodeAPIKey = "e1f634835289963a63040a55a00ab886"
    static let HuanxinAppkey = "1133171107115421#medicalclient"
    static let AliPayScheme = "com.dingling.medical.o2o"
    static let BuglyAPPID = "e0392726ce"
    static let weixinAPPID = "wx000999888777"
}


//日志打印
public func dPrint<N>(message:N,fileName:String = #file,methodName:String = #function,lineNumber:Int = #line){
    #if DEBUG
        print("------ BEGIN \n\(fileName as NSString)\n方法:\(methodName)\n行号:\(lineNumber)\n打印信息:\(message)\n------ end");
    #endif
}

public func showToast(_ view:UIView, _ message:String) {
    var style = ToastStyle()
    style.backgroundColor = UIColor.APPColor
    view.makeToast(message, duration: 2.0, position: .bottom, style:style)
}

public func ToastError(_ message:String) {
    var style = ToastStyle()
    style.backgroundColor = UIColor.red
    let view = APPLICATION.window?.rootViewController?.view
    view?.makeToast(message, duration: 2.0, position: .bottom, style:style)
}

public func Toast(_ message:String) {
    var style = ToastStyle()
    style.backgroundColor = UIColor.APPColor
    let vc = APPLICATION.window?.rootViewController
    
    vc!.view!.makeToast(message, duration: 2.0, position: .bottom, style:style)
}

public func customBtn(str:String) -> UIButton {
    let btn = UIButton()
    btn.layer.cornerRadius = 5
    btn.backgroundColor = UIColor.APPColor
    btn.setTitleColor(.white, for: .normal)
    btn.setTitle(str, for: .normal)
    return btn
}

// 网络请求
class NetWorkUtil<T:BaseAPIBean> {
    var method:API?
    
    init(method:API) {
        self.method = method
    }
    
    class func getRequest(urlString: String, params : [String : Any], success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()) {
        Alamofire.request(urlString, method: .get, parameters: params).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    success(value as! [String : AnyObject])
                case .failure(let error):
                    failture(error)
                }
        }
    }
    
    func newRequest(successhandler:((_ bean:T, _ JSONObj:JSON) -> Void)?,failhandler:((_ bean:T, _ JSONObj:JSON) -> Void)? = nil ) {
        let Provider = MoyaProvider<API>()
        SVProgressHUD.show()
        Provider.request(method!) { result in
            switch result {
            case let .success(response):
                do {
                    SVProgressHUD.dismiss()
                    let jsonObj =  try response.mapJSON()
                    let bean = Mapper<T>().map(JSONObject: jsonObj)
                    let json = JSON(jsonObj)
                    if let bean = bean {
                        if bean.code == 100 {
                            if successhandler != nil {
                                successhandler!(bean, json)
                            }
                        }else {
                            if failhandler != nil {
                                failhandler!(bean, json)
                            }else {
                                ToastError(bean.msg!)
                            }
                        }
                    }
                }catch {
                    dPrint(message: "response:\(response)")
                    Toast(CATCHMSG)
                }
            case let .failure(error):
                SVProgressHUD.dismiss()
                dPrint(message: "error:\(error)")
                Toast(ERRORMSG)
            }
        }
    }
    
    func newRequestWithOutHUD(successhandler:((_ bean:T, _ JSONObj:JSON) -> Void)? ,failhandler:((_ bean:T, _ JSONObj:JSON) -> Void)? = nil) {
        let Provider = MoyaProvider<API>()
        Provider.request(method!) { result in
            switch result {
            case let .success(response):
                do {
                    let jsonObj =  try response.mapJSON()
                    let bean = Mapper<T>().map(JSONObject: jsonObj)
                    let json = JSON(jsonObj)
                    if let bean = bean {
                        if bean.code == 100 {
                            if successhandler != nil {
                                successhandler!(bean, json)
                            }
                        }else {
                            if failhandler != nil {
                                failhandler!(bean, json)
                            }else {
                                ToastError(bean.msg!)
                            }
                        }
                    }
                    
                    
                }catch {
                    dPrint(message: "response:\(response)")
                    Toast(CATCHMSG)
                }
            case let .failure(error):
                dPrint(message: "error:\(error)")
                Toast(ERRORMSG)
            }
        }
    }
    
    //获取科室数据
    class func getDepartMent(success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()){
        getRequest(urlString: StaticClass.GetDept, params: [:], success: success, failture:failture)
    }
}






// UserDefault UserDefault相关的枚举值
enum user_default:String {
    case userId, password, typename, pix, token, username, title, account, channel_id, phoneNum
    func getStringValue()->String? {
        return UserDefaults.standard.string(forKey: self.rawValue)
    }
    //UserDefaults 进行本地存储
    static func setUserDefault(key:user_default, value:Any){
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    //UserDefaults 清空数据
    static func clearUserDefaultValue(){
        UserDefaults.standard.removeObject(forKey: "typename")
        UserDefaults.standard.removeObject(forKey: "pix")
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "title")
        UserDefaults.standard.removeObject(forKey: "account")
        UserDefaults.standard.removeObject(forKey: "password")
    }
    // 退出登录
    static func logout(_ msg:String) {
        let vc_login = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
        APPLICATION.window?.rootViewController = vc_login
    NetWorkUtil<BaseAPIBean>.init(method: .exit).newRequestWithOutHUD(successhandler: { (bean, json) in
            
                user_default.clearUserDefaultValue()
                EMClient.shared().logout(false, completion: { (error)
                    in
                    if error == nil {
                        Toast("\(msg)账号退出成功")
                    }else {
                        Toast("\(msg)账号退出失败")
                    }
                })
        })
        
    }
}


// Alert 相关
class AlertUtil: NSObject {
    
    /**
     选择弹出框
     - parameter title: 标题
     - parameter msg:   消息
     - parameter btns:  弹框项
     */
    class func popMenu(vc:UIViewController, title:String,msg:String,btns:[String], handler:@escaping (_ value: String)->()) {
        
        let alertController = UIAlertController(title: title, message: msg,
                                                preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        for btn in btns {
            let action = UIAlertAction(title: btn, style: .default) { (UIAlertAction) -> Void in
                handler(UIAlertAction.title!)
                
            }
            alertController.addAction(action)
        }
        // 添加Pad支持
        alertController.popoverPresentationController?.sourceView = vc.view
        alertController.popoverPresentationController?.sourceRect = CGRect.init(x: 0, y: 0, width: 1, height: 1)
        
        vc.present(alertController, animated: true, completion: nil)
    }
    
    class func popAlert(vc:UIViewController, msg:String, okhandler: @escaping ()->())
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
    
    // 弹出带文本输入框
    class func popTextFields(vc:UIViewController,title:String, textfields:[UITextField], okhandler: @escaping (_ textfields:[UITextField])->()) {
        let alertController = UIAlertController(title: title,
                                                message: "", preferredStyle: .alert)
        for item in textfields {
            alertController.addTextField {
                (textField: UITextField!) -> Void in
                textField.placeholder = item.placeholder
                textField.keyboardType = item.keyboardType
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: {
            action in
            okhandler(alertController.textFields!)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    
    class func popInfoTextFields(vc:UIViewController, okhandler: @escaping (_ textfields:[UITextField])->()) {
        let alertController = UIAlertController(title: "输入内容",
                                                message: "", preferredStyle: .alert)
        alertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "姓名"
        }
        alertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "性别(男/女)"
        }
        alertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "年龄"
            textField.keyboardType = .numberPad
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: {
            action in
            okhandler(alertController.textFields!)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        vc.present(alertController, animated: true, completion: nil)
    }
}

class ImageUtil{
    class func URLToImg(url:URL) -> UIImage {
        var img = UIImage.init()
        do {
            let data = try Data.init(contentsOf: url)
            img = UIImage.init(data: data)!
        }catch {
            img = #imageLiteral(resourceName: "photo_default")
        }
        return img
    }
    // 设置按钮不可用灰色
    class func setButtonDisabledImg(button:UIButton){
        button.setBackgroundImage(ImageUtil.color2img(color: UIColor.APPGrey), for: .disabled)
    }
    
    // 颜色转图片
    class func color2img(color:UIColor) -> UIImage{
        //  颜色转换为背景图片
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor);
        context.fill(rect);
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
        
    }
    //设置图片
    class public func setImage(path:String, imageView:UIImageView){
        let url = URL(string:path)
        imageView.kf.setImage(with: url)
    }
    
    static public func setAvator(path:String, imageView:UIImageView) {
        let url = URL(string: path)
        //        imageView.kf.setImage(with: url)
        imageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "photo_default"), options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    // 图片转为Data类型
    class public func image2Data(image:UIImage) -> Data{
        return UIImageJPEGRepresentation(image, 0.1)!
    }
}

//MARK: - 地图定位
class MapUtil {
    class func singleLocation(successHandler:((_ location:CLLocation, _ reGeocode:AMapLocationReGeocode?) -> Void)?, failHandler:@escaping () -> Void ) {
        APPLICATION.locationManager.requestLocation(withReGeocode: true, completionBlock: {(location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in
            
            if let error = error {
                let error = error as NSError
                failHandler()
                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
                    let msg = "定位错误:{\(error.code) - \(error.localizedDescription)};"
                    Toast(msg)
                    return
                }
                else if error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
                    || error.code == AMapLocationErrorCode.timeOut.rawValue
                    || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
                    || error.code == AMapLocationErrorCode.badURL.rawValue
                    || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
                    || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue {
                    
                    //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
                    let msg = "获取地理位置失败，请检查GPS设置;"
                    Toast(msg)
                }
            }else {
                if let location = location  {
                    APPLICATION.lon = location.coordinate.longitude.description
                    APPLICATION.lat = location.coordinate.latitude.description
                    if successHandler != nil {
                        successHandler!(location, reGeocode)
                    }
                }
            }
            
            
        })
    }
}

class StringUTil {
    
    // 动态获取字符串宽、高度
   class func getTextRectSize(text:NSString, font:UIFont, size:CGSize) -> CGRect {
        // 传入字符串的字体、最大宽高，返回字符串实际占用的宽高(.width   .height)
    let attributes = [NSAttributedStringKey.font:font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = text.boundingRect(with: size, options: option, attributes: attributes, context: nil)
        return rect
    }
    // 消除空格
    class public func trimmingCharactersWithWhiteSpaces(_ str:String) -> String{
        return str.trimmingCharacters(in: .whitespaces)
    }
    // 距离转换
    class public func transformDistance(_ distance:Int) -> String {
        if distance/1000 < 1 {
            return "\(distance)米"
        }else {
            let res = Int(distance/1000)
            return  "\(res)千米"
        }
    }
    
    // 转换MD5值
    class public func transformMD5(_ string:String)->String {
        return MD5(string)
    }
    
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
    
    class func splitImage(str:String) -> [String] {
        return str.components(separatedBy: ",")
    }
    
    
}

public class AliSdkManager: NSObject {
    public static var aliSdkManager:AliSdkManager!
    var context:BaseRefreshController<OrderBean>?
    
    static func sharedManager (context:BaseRefreshController<OrderBean>) -> AliSdkManager{
        AliSdkManager.aliSdkManager = AliSdkManager.init()
        AliSdkManager.aliSdkManager.context = context
        return AliSdkManager.aliSdkManager
    }
    internal func showResult(result:NSDictionary){
        //        9000    订单支付成功
        //        8000    正在处理中
        //        4000    订单支付失败
        //        6001    用户中途取消
        //        6002    网络连接出错
        let returnCode:String = result["resultStatus"] as! String
        var returnMsg:String = result["memo"] as! String
        dPrint(message: "returnMsg: \(result)")
        switch  returnCode{
        case "9000":
            returnMsg = "支付成功"
            dPrint(message: JSON.init(parseJSON: (result["result"] as! String))["alipay_trade_app_pay_response"]["sub_msg"].stringValue)
            Toast(returnMsg)
            self.context?.refreshData()
        default:
            Toast("支付失败")
        }
    }
}


public class AliPayUtils: NSObject {
    var context:UIViewController
    
    public init(context:UIViewController) {
        self.context = context
        let vc = context as! BaseRefreshController<OrderBean>
        //初始化支付管理类
        AliSdkManager.sharedManager(context: vc)
    }
    
    public func pay(sign:String){
        let decodedData = sign.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
        let decodedString:String = (NSString(data: decodedData, encoding: String.Encoding.utf8.rawValue))! as String
        
        
        AlipaySDK.defaultService().payOrder(decodedString, fromScheme: StaticClass.AliPayScheme, callback: { (resp) in
            dPrint(message: resp)
        } )
    }
}

public class DBHelper:NSObject {
    // 初始化数据库
    class public func setUpDB() {
        /* Realm 数据库配置，用于数据库的迭代更新 */
        let schemaVersion: UInt64 = 0
        let config = Realm.Configuration(schemaVersion: schemaVersion, migrationBlock: { migration, oldSchemaVersion in
            
            /* 什么都不要做！Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的数据库架构 */
            if (oldSchemaVersion < schemaVersion) {}
        })
        Realm.Configuration.defaultConfiguration = config
        Realm.asyncOpen { (realm, error) in
            
            /* Realm 成功打开，迁移已在后台线程中完成 */
            if let _ = realm {
                
                print("Realm 数据库配置成功")
            }
                /* 处理打开 Realm 时所发生的错误 */
            else if let error = error {
                
                print("Realm 数据库配置失败：\(error.localizedDescription)")
            }
        }
    }
}



