import UIKit
import Alamofire

// let model = Mapper<Type>().map(JSONString: obj as! String)

class FYNetwork: NSObject {
    
    static let share = FYNetwork()
    
    private func getHTTPHeaders() -> HTTPHeaders {
        
        let headers: HTTPHeaders =
            ["content-type": "application/json",
             "charset": "UTF-8",]
        
        return headers
    }
    
    private func responseResult(_ response: DataResponse<Any>) -> String {
        
        switch response.result {
        case .success :
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                return utf8Text
            }
        case .failure(let err) :
            print("err -> \(err)")
        }
        return emptyString
    }
    
    func GET(urlStr: String,
             parameters: [String: Any]?,
             successed: @escaping ((_ responseObj: Any)->())
        ) {
        
        let headers: HTTPHeaders = self.getHTTPHeaders()
        
        Alamofire.request(url_host + urlStr, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers).responseJSON { (response) in
            
            successed(self.responseResult(response))
            
        }
        
    }
    
    func POST(urlStr: String,
             parameters: [String: Any]?,
             successed: @escaping ((_ responseObj: Any)->())
        ) {
        
        let headers: HTTPHeaders = self.getHTTPHeaders()
        
        Alamofire.request(url_host + urlStr, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            successed(self.responseResult(response))
            
        }
        
    }
    
    func PUT(urlStr: String,
              parameters: [String: Any]?,
              successed: @escaping ((_ responseObj: Any)->())
        ) {
        
        let headers: HTTPHeaders = self.getHTTPHeaders()
        
        Alamofire.request(url_host + urlStr, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            successed(self.responseResult(response))
            
        }
        
    }
    
    func DELETE(urlStr: String,
             parameters: [String: Any]?,
             successed: @escaping ((_ responseObj: Any)->())
        ) {
        
        let headers: HTTPHeaders = self.getHTTPHeaders()
        
        Alamofire.request(url_host + urlStr, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            successed(self.responseResult(response))
            
        }
        
    }
    
}
