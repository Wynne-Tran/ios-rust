//
//  ContentView.swift
//  RustServer
//
//  Created by Wynne Tran on 2025-02-15.
//

import SwiftUI

struct ContentView: View {
    init() {
        start_server()
    }
    var body: some View {
        VStack {
            Button("Send GET Request") {
                getHealthCheck()
            }
            .padding()
            
            Button("Send POST Request") {
                postHealthCheck()
            }
            .padding()
        }
    }
}

func getHealthCheck() {
    guard let url = URL(string: "http://127.0.0.1:8080/health_check") else { return }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("GET Request Error: \(error)")
            return
        }
        if let data = data, let responseString = String(data: data, encoding: .utf8) {
            print("GET Response: \(responseString)")
        }
    }.resume()
}
import Foundation

func postHealthCheck() {
    guard let url = URL(string: "http://127.0.0.1:8080/health_check") else { return }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let jsonBody: [String: String] = ["content": "Call Rust Server from Swift!"]
    
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: jsonBody, options: [])
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    } catch {
        print("Error serializing JSON: \(error)")
        return
    }

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("POST Request Error: \(error)")
            return
        }
        if let data = data, let responseString = String(data: data, encoding: .utf8) {
            print("POST Response: \(responseString)")
        }
    }.resume()
}


#Preview {
    ContentView()
}
