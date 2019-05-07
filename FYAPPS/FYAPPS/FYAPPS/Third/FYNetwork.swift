import UIKit
import AFNetworking

// let model = Mapper<Type>().map(JSON: obj as! [String : Any])

class FYNetwork: NSObject {
    
    private static let isPrint: Bool = true
    
    private static var manager: AFHTTPSessionManager?
    private class func defaultManager() -> AFHTTPSessionManager {
        FYGCD.fy_gcdQueue(FYGCD.fy_gcdQueue(FY_Queue_Global), task: FY_Task_Once) {
            manager = AFHTTPSessionManager()
            manager?.responseSerializer.acceptableContentTypes = NSSet.init(objects: "text/html", "text/json", "text/plain", "text/javascript", "application/json") as? Set<String>
//            manager?.requestSerializer = AFJSONRequestSerializer()
//            manager?.requestSerializer.timeoutInterval = 300
//            manager?.operationQueue.maxConcurrentOperationCount = 6
            self.KVONetworkChange()
        }
        return manager!
    }
    
    private class func KVONetworkChange() {
        AFNetworkReachabilityManager.shared().setReachabilityStatusChange { (status) in
            switch status {
            case .unknown :
                print("未知网络状态")
            case .notReachable :
                print("无网络")
                self.defaultManager().operationQueue.cancelAllOperations()
            case .reachableViaWWAN:
                print("3G/4G")
            case .reachableViaWiFi:
                print("WiFi")
            }
        }
        AFNetworkReachabilityManager.shared().startMonitoring()
    }
    
    private class func success(_ response: Any?, _ successed: ((_ response: Any)->())) {
        if response != nil {
            isPrint ? NSObject.AFPrint(response!) : ()
            successed(response!)
        } else { print("response == nil") }
    }
    
    class func GET(urlStr: String,
                   parameters: [String: Any]?,
                   successed: @escaping ((_ response: Any)->())
        ) {
        self.defaultManager().get(urlStr, parameters: parameters, progress: nil, success: { (_, response) in
            self.success(response, successed)
        }) { (_, err) in
            print("err -> \(err)")
        }
    }
    
    class func GET(urlStr: String,
                   parameters: [String: Any]?,
                   successed: @escaping ((_ response: Any)->()),
                   errBlock: @escaping (()->())
        ) {
        self.defaultManager().get(urlStr, parameters: parameters, progress: nil, success: { (_, response) in
            self.success(response, successed)
        }) { (_, err) in
            print("err -> \(err)")
            errBlock()
        }
    }
    
    class func POST(urlStr: String,
                    parameters: [String: Any]?,
                    successed: @escaping ((_ response: Any)->())
        ) {
        self.defaultManager().post(urlStr, parameters: parameters, progress: nil, success: { (_, response) in
            self.success(response, successed)
        }) { (_, err) in
            print("err -> \(err)")
        }
    }
    
    class func POST(urlStr: String,
                    parameters: [String: Any]?,
                    successed: @escaping ((_ response: Any)->()),
                    errBlock: @escaping (()->())
        ) {
        self.defaultManager().post(urlStr, parameters: parameters, progress: nil, success: { (_, response) in
            self.success(response, successed)
        }) { (_, err) in
            print("err -> \(err)")
            errBlock()
        }
    }
}

extension NSObject {
    
    // 将AFNetworking请求成功返回的字典打印成JSON格式的字符串
    class func AFPrint(_ obj: Any) {
        do {
            print("obj -> \(String.init(data: try JSONSerialization.data(withJSONObject: obj, options: JSONSerialization.WritingOptions.prettyPrinted), encoding: .utf8) ?? "")")
        } catch {}
    }
    
}
