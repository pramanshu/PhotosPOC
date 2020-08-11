//
//  Webservice.swift
//  PhotosPOC
//
//  Created by Pramanshu Goel on 11/08/20.
//  Copyright © 2020 Pramanshu Goel. All rights reserved.
//
//https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=f6bb977b702cd9cf8da782c3d27637bb&text=%22river%22&format=json&nojsoncallback=1
import Foundation


import Foundation
import SystemConfiguration

extension URLComponents {
    
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
    
}

// MARK: Error enum Declaration

enum NetworkError: Error {
    case domainError
    case decodingError
}
enum Router {
    
    case getFacts(method:String,api_key:String,text:String,format:String,nojsoncallback:String)
   
    
    
 
    
    
    var scheme: String {
        switch self {
        case .getFacts:
            return "https"
        }
    }
    
    var host: String {
        let base = "www.flickr.com"
        switch self {
        case .getFacts:
            return base
        }
    }
    
    var path: String {
        switch self {
        case .getFacts:
            return "/services/rest"

        }
    }
    var parameters: [URLQueryItem] {
        switch self {
        case .getFacts(let method,let api_key, let text,let format,let nojsoncallback):
            return [URLQueryItem(name: "method", value: method),
                    URLQueryItem(name: "api_key", value: api_key),
                URLQueryItem(name: "text", value: text),
                URLQueryItem(name: "format", value: format),
                URLQueryItem(name: "nojsoncallback", value: nojsoncallback),
            ]
       
        }
    }
    
    var method: String {
        switch self {
        case .getFacts:
            return "GET"
        }
    }
    
}



class NetworkService {
    
    
//    class func getData (router: Router){
//         var components = URLComponents()
//                    components.scheme = router.scheme
//                    components.host = router.host
//                    components.path = router.path
//                   components.queryItems = router.parameters
//
//                    let session = URLSession(configuration: .default)
//                    guard let url = components.url else { return }
//                    var urlRequest = URLRequest(url: url)
//
//                urlRequest.httpMethod = router.method
//
//
//
//                    let dataTask = session.dataTask(with: urlRequest) { data, response, error in
//
//                        guard error == nil else {
//                           // completion(.failure(.domainError))
//                            return
//                        }
//                        guard response != nil else {
//                            print("no response")
//                            return
//                        }
//                        guard let data = data else {
//                            print("no data")
//                            return
//                        }
//                        do{
//                            print(data)
//
//
//
//
//
//                            let dataEncode = String(data: data, encoding: .isoLatin1)?.data(using: .utf8)
//
//
//                            let json =  try! JSONSerialization.jsonObject(with: data)
//                            print(json as Any)
////                            let responseObject = try! JSONDecoder().decode(T.self, from: dataEncode!)
//
//                           // completion(.success(responseObject))
//
//                        }
//                        catch{
//                          //  completion(.failure(.decodingError))
//                        }
//                    }
//                    dataTask.resume()
//                }
    
    
    
    
    class func request<T: Decodable>(router: Router, completion: @escaping (Result<T,NetworkError>) -> ()){
            
            var components = URLComponents()
            components.scheme = router.scheme
            components.host = router.host
          components.path = router.path
           components.queryItems = router.parameters
            
            let session = URLSession(configuration: .default)
            guard let url = components.url else { return }
            var urlRequest = URLRequest(url: url)

        urlRequest.httpMethod = router.method
        
          

            let dataTask = session.dataTask(with: urlRequest) { data, response, error in
                
                guard error == nil else {
                   // completion(.failure(.domainError))
                    return
                }
                guard response != nil else {
                    print("no response")
                    return
                }
                guard let data = data else {
                    print("no data")
                    return
                }
                do{
                    print(data)
                    
                    
                    
                    
                    
                    let dataEncode = String(data: data, encoding: .isoLatin1)?.data(using: .utf8)
                              
                    
//                    let json =  try! JSONSerialization.jsonObject(with: data)
//                    print(json as Any)
                    let responseObject = try! JSONDecoder().decode(T.self, from: dataEncode!)

                    completion(.success(responseObject))

                }
                catch{
                    completion(.failure(.decodingError))
                }
            }
            dataTask.resume()
        }
    
    

}

// MARK: Reachbility  Class Implementation


public class Reachability {
    
    static let shared = Reachability()
    
    
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
}

