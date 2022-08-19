//
//  TimeViewController.swift
//  Chapter08-APITest
//
//  Created by 혜리 on 2022/08/11.
//

import UIKit


class TimeViewController: UIViewController {
    
    @IBOutlet weak var currentTime: UILabel!
    
    @IBAction func callCurrentTime(_ sender: Any) {
        do {
            let url = URL(string: "http://swiftapi.rubypaper.co.kr:2029/practice/currentTime")

            let response = try String(contentsOf: url!)
            
            self.currentTime.text = response
            self.currentTime.sizeToFit()
        } catch let e as NSError{
            print(e.localizedDescription)
        }
    }

    
    @IBOutlet weak var userId: UITextField!
    
    @IBOutlet weak var name: UITextField!

    
    @IBAction func post(_ sender: Any) {
        // 전송할 값 준비 (POST 방식)
        let userId = (self.userId.text)!
        let name = (self.name.text)!
        let param = "userId=\(userId)&name=\(name)"
        let paramData = param.data(using: .utf8)
        
        // URL 객체 정의
        let url = URL(string: "http://swiftapi.rubypaper.co.kr:2029/pratice/echo")
        
        // URLRequest 객체 정의 및 요청 내용 담기
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = paramData
        
        // HTTP 메시지에 포함될 헤더 설정
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramData!.count), forHTTPHeaderField: "Content-Length")
        
        // URLSession 객체를 통해 전송 및 응답값 처리 로직 작성
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // 서버에 응답이 없거나 통신이 실패했을 때
            if let e = error {
                NSLog("An error has occurred : \(e.localizedDescription)")
                return
            }
            // 응답 처리 로직이 여기에 들어감
            // 해당 블록의 코드가 메인 스레드에서 비동기로 처리 되도록 함
            DispatchQueue.main.async() {
                do {
                    let object = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    guard let jsonObject = object else { return }
                    
                    // JSON 결과 값을 추출함.
                    let result    = jsonObject["result"] as? String
                    let timestamp = jsonObject["timestamp"] as? String
                    let userId    = jsonObject["userId"] as? String
                    let name      = jsonObject["name"] as? String
                
                    if result == "SUCCESS" {
                        self.responseView.text = "아이디 : \(userId!)" + "\n"
                                                + "이름 : \(name!)" + "\n"
                                                + "응답결과 : \(result!)" + "\n"
                                                + "응답시간 : \(timestamp!)" + "\n"
                                                + "요청방식 : x-www-form-urlencoded"
                    }
                } catch let e as NSError {
                    print("An error has occurred while parsing JSONObject : \(e.localizedDescription)")
                }
            } // end DispatchQueue.main.async
        }
        // POST 전송
        task.resume()
    }
    
    
    @IBAction func json(_ sender: Any) {
        // 전송할 값 준비 (JSON 방식)
        let userId = (self.userId.text)!
        let name = (self.name.text)!
        let param = ["userId": userId, "name": name] // JSON 객체로 변환할 딕셔너리 준비
        let paramData = try! JSONSerialization.data(withJSONObject: param, options: [])
        
        // URL 객체 정의
        let url = URL(string: "http://swiftapi.rubypaper.co.kr:2029/pratice/echoJSON")
        
        // URLRequest 객체 정의 및 요청 내용 담기
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = paramData
        
        // HTTP 메시지에 포함될 헤더 설정
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramData.count), forHTTPHeaderField: "Content-Length")
        
        // URLSession 객체를 통해 전송 및 응답값 처리 로직 작성
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // 서버에 응답이 없거나 통신이 실패했을 때
            if let e = error {
                NSLog("An error has occurred : \(e.localizedDescription)")
                return
            }
            // 응답 처리 로직이 여기에 들어감
            // 해당 블록의 코드가 메인 스레드에서 비동기로 처리 되도록 함
            DispatchQueue.main.async() {
                do {
                    let object = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    guard let jsonObject = object else { return }
                    
                    // JSON 결과 값을 추출함.
                    let result    = jsonObject["result"] as? String
                    let timestamp = jsonObject["timestamp"] as? String
                    let userId    = jsonObject["userId"] as? String
                    let name      = jsonObject["name"] as? String
            
                    if result == "SUCCESS" {
                        self.responseView.text = "아이디 : \(userId!)" + "\n"
                                                + "이름 : \(name!)" + "\n"
                                                + "응답결과 : \(result!)" + "\n"
                                                + "응답시간 : \(timestamp!)" + "\n"
                                                + "요청방식 : x-www-form-urlencoded"
                    }
                } catch let e as NSError {
                    print("An error has occurred while parsing JSONObject : \(e.localizedDescription)")
                }
            } // end DispatchQueue.main.async
        }
        // POST 전송
        task.resume()
    }
    
    
    @IBOutlet weak var responseView: UITextView!
    
    
    
}
