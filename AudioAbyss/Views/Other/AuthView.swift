//
//  AuthView.swift
//  AudioAbyss
//
//  Created by Moody on 2023-11-04.
//

import SwiftUI
import WebKit

struct AuthView: UIViewRepresentable {
    let url: URL
    @Environment(\.dismiss) var dismiss
    @Binding var signedIn: Bool

    func makeUIView(context: Context) -> WKWebView {
        
        // Creating Web View for Spotify Authentication
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {

        // URL Request with Spotify Auth URL
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: AuthView

        init(_ parent: AuthView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            guard let authURL = webView.url else { return }
            
            // Exchange the code given for an Access token
            guard let code = URLComponents(string: authURL.absoluteString)?.queryItems?.first(where: {$0.name == "code"})?.value else { return }
            
            print("Access Code: \(code)")
            
            Task {
                do {
                    let exchangedCode = try await AuthManager.shared.exchangeCodeForToken(code: code)
                    
                    if exchangedCode {
                        DispatchQueue.main.async {
                            self.parent.dismiss()
                            self.parent.signedIn.toggle()
                        }
                    } else {
                        //TODO: Alert the user that something went wrong
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }

    func makeCoordinator() -> AuthView.Coordinator {
        Coordinator(self)
    }
}
