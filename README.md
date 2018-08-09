# iOS Dynamic WebView

## Swift version
**Swift 4.0**

## Description
Storyboard-enabled WebView which uses UIWebView for iOS < 8.0 or WKWebView for latest versions

## Usage

- via code
```
let dynamicWebView = DynamicWebView()
dynamicWebView.delegate = self

extension DynamicWebViewDelegate {
  func webViewDidFinishedLoading(view: DynamicWebView) {}
}
```
- via Storyboard
 1. Drag & Drop UIView
 2. Change view class to DynamicWebView

## Use in Objective-C
Control were created to work in Objective-C project so I can provide you a link with some info)

[Setting up Swift and Objective-C Interoperability](https://medium.com/ios-os-x-development/swift-and-objective-c-interoperability-2add8e6d6887) by Jen Sipila 
[![Twitter](https://abs.twimg.com/favicons/favicon.ico)](https://twitter.com/jen_sipila)


## Why not Carthage or Pods
Because I'm almost 100% sure that you will add custom methods and extend the delegate on your own
