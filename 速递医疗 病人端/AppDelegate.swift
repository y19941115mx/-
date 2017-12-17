//
//  AppDelegate.swift
//  速递医疗 病人端
//
//  Created by admin on 2017/10/29.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var locationManager:AMapLocationManager = AMapLocationManager()
    var lon:String = "0"
    var lat:String = "0"
    var departData = [String:[String]]()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        进度条设置
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setForegroundColor(UIColor.APPColor)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setDefaultAnimationType(.native)
        //        获取基本数据
        self.initData()
//        百度推送
        self.setUpBaiDuPush(application, didFinishLaunchingWithOptions: launchOptions)
//        高德地图
        self.setUpMap()
//        环信
        self.setupHuanxin()
        //初始化支付管理类
        AliSdkManager.sharedManager()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
       EMClient.shared().applicationDidEnterBackground(application)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        EMClient.shared().applicationWillEnterForeground(application)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        BPush.registerDeviceToken(deviceToken)
        BPush.bindChannel(completeHandler: {result, error in
            if error != nil {return}
            if result != nil {
                // 获取channel_id
                let BaiDu_Channel_id = BPush.getChannelId()
                dPrint(message: BaiDu_Channel_id)
                user_default.setUserDefault(key: user_default.channel_id, value: BaiDu_Channel_id!)
            }
        })
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        // App 收到推送的通知
        BPush.handleNotification(userInfo)
        let vc = UIStoryboard.init(name: "Mine", bundle: nil).instantiateViewController(withIdentifier: "mineMsg") as! Mine_msg_main
        APPLICATION.window?.rootViewController?.present(vc, animated: false, completion: nil)
        // 清空角标
        UIApplication.shared.applicationIconBadgeNumber = 0
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        dPrint(message: error)
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.host == "safepay" {
            AlipaySDK.defaultService().processOrder(withPaymentResult: url as URL!, standbyCallback: {
                (resultDic) -> Void in
                //调起支付结果处理
                AliSdkManager.aliSdkManager.showResult(result: resultDic! as NSDictionary);
            })
        }
        return true;
    }
    
    // MARK: - private method
    private func setUpBaiDuPush(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        if (UIDevice.current.systemVersion as NSString).floatValue >= 10.0 {
            let center =  UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.alert,.badge,.sound], completionHandler: { (granted, error) in
                if granted {
                    application.registerForRemoteNotifications()
                }
            })
        }else if (UIDevice.current.systemVersion as NSString).floatValue >= 8.0 {
            let userSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound],
                                                          categories: nil)
            UIApplication.shared.registerUserNotificationSettings(userSettings)
        }else {
            
        }
        
        BPush.registerChannel([:], apiKey:StaticClass.TuisongAPIKey , pushMode: BPushMode.development, withFirstAction: "打开", withSecondAction: "关闭", withCategory: "test", useBehaviorTextInput: true, isDebug: true)
        //        关闭地理推送
        BPush.disableLbs()
        
        //        初始化百度推送
        let userInfo = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification]
        if userInfo != nil{
            BPush.handleNotification(userInfo as! [AnyHashable : Any])
        }
        // 清空角标
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    private func setUpMap() {
        AMapServices.shared().apiKey = StaticClass.GaodeAPIKey
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        locationManager.locationTimeout = 2
        
        locationManager.reGeocodeTimeout = 2
        
        MapUtil.singleLocation(successHandler: {location, reGeocode in
            if reGeocode != nil {
                showToast((APPLICATION.window?.rootViewController?.view)!, "定位成功："+(reGeocode?.country)! + (reGeocode?.city)! + (reGeocode?.aoiName)!)
            }
        }, failHandler: {})
    }
    
    private func setupHuanxin() {
        let options = EMOptions.init(appkey: StaticClass.HuanxinAppkey)
        EMClient.shared().initializeSDK(with: options)
        // 环信登录
        let account = user_default.account.getStringValue()
        let pass = user_default.password.getStringValue()
        if account != nil && account != ""{
            EMClient.shared().login(withUsername: account!, password: pass, completion: { (name, error) in
                if error == nil {
                    Toast("环信登录成功")
                }else {
                    Toast("环信登录失败，\(error.debugDescription)")
                }
            })
            
        }
    }
    
    private func initData() {
        // 获取部门数据
        NetWorkUtil.getDepartMent(success: { response in
            let json = JSON(response)
            let data = json["data"].arrayValue
            for i in 0..<data.count{
                // 处理数据
                let one = data[i]["first"].stringValue
                let two = data[i]["second"].arrayObject as! [String]
                if one != "" {
                    self.departData[one] = two
                }
            }
        }, failture:{ error in dPrint(message: error)
        })
    }
    


}

