//
//  NewsDataManager.swift
//  Today News
//
//  Created by Nandan on 27/03/24.
//

import Foundation
import Alamofire

protocol NewsDataManagerDelegate {
    func updateUIOnSuccess(articles: [Article])
    func updateUIOnfail()
}

struct NewsDataManager {
    
    let newsUrl = "https://newsapi.org/v1/articles?source=the-verge&apiKey=de5fdb7b6cd24c1894c91a3e4f851a61"
    var delegate: NewsDataManagerDelegate?
    
    func getNewsData() {
        AF.request(newsUrl, method: .get).responseData { response in
            
            if response.error != nil {
                
                print("getNewsData RESPONSE ERROR = \(String(describing: response.error?.localizedDescription))")
                
            } else {
                
                if let safeData = response.data {
                    let response = String(data: safeData, encoding: .utf8)
                    print("getNewsData response.. : \(response!)")
                    
                    let decoder = JSONDecoder()
                    
                    do {
                        
                        let decodedData = try decoder.decode(NewsData.self, from: safeData)
                        
                        if decodedData.status == "ok" {
                            print("getNewsData decoded data: \(String(describing: decodedData.articles))")
                            delegate?.updateUIOnSuccess(articles: decodedData.articles)
                        } else {
                            delegate?.updateUIOnfail()
                        }
                        
                    } catch {
                        print("getNewsData decode error: \(error)")
                        delegate?.updateUIOnfail()
                    }
                }
            }
        }
    }
}
