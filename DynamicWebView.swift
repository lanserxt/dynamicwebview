import UIKit
import WebKit

@objc public protocol DynamicWebViewDelegate: class {
    @objc optional func webViewDidFinishedLoading(view: DynamicWebView)
}

final public class DynamicWebView: UIView {
    
    public weak var delegate: DynamicWebViewDelegate?
    
    fileprivate lazy var oldWebView: UIWebView  = {
        var webView = UIWebView()
        webView.delegate = self
        webView.backgroundColor = UIColor.white
        webView.scrollView.isScrollEnabled = false
        webView.isOpaque = false
        return webView
    }()
    
    @available(iOS 8.0, *)
    fileprivate lazy var modernWebView: WKWebView  = {
        var webView = WKWebView()
        webView.navigationDelegate = self
        webView.backgroundColor = UIColor.white
        webView.scrollView.isScrollEnabled = false
        webView.isOpaque = false
        return webView
    }()
    
    var webBackgroundColor: UIColor? {
        didSet{
            if let webBackgroundColor = webBackgroundColor {
                if #available(iOS 8.0, *) {
                    self.modernWebView.backgroundColor = webBackgroundColor
                    self.modernWebView.scrollView.backgroundColor = webBackgroundColor
                } else {
                    self.oldWebView.backgroundColor = webBackgroundColor
                    self.oldWebView.scrollView.backgroundColor = webBackgroundColor
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    fileprivate func setupView() {
        if #available(iOS 8.0, *) {
            self.addSubview(self.modernWebView)
            self.modernWebView.translatesAutoresizingMaskIntoConstraints = false
            let horizontalConstraint = NSLayoutConstraint(item: self.modernWebView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
            let verticalConstraint = NSLayoutConstraint(item: self.modernWebView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
            let leftConstraint = NSLayoutConstraint(item: self.modernWebView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
            let rightConstraint = NSLayoutConstraint(item: self.modernWebView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
            self.addConstraints([horizontalConstraint, verticalConstraint, leftConstraint, rightConstraint])
        } else {
            self.addSubview(self.oldWebView)
            
            self.oldWebView.translatesAutoresizingMaskIntoConstraints = false
            let horizontalConstraint = NSLayoutConstraint(item: self.oldWebView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
            let verticalConstraint = NSLayoutConstraint(item: self.oldWebView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
            let leftConstraint = NSLayoutConstraint(item: self.oldWebView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
            let rightConstraint = NSLayoutConstraint(item: self.oldWebView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
            self.addConstraints([horizontalConstraint, verticalConstraint, leftConstraint, rightConstraint])
        }
    }
    
    public func loadHTML(_ string: String) {
        if #available(iOS 8.0, *) {
            self.modernWebView.loadHTMLString(string, baseURL: nil)
        } else {
            self.oldWebView.loadHTMLString(string, baseURL: nil)
        }
    }
    
    public func loadRequest(_ urlRequest: URLRequest) {
        if #available(iOS 8.0, *) {
            self.modernWebView.load(urlRequest)
        } else {
            self.oldWebView.loadRequest(urlRequest)
        }
    }
    
    public func setWebViewFrame(_ frame: CGRect) {
        if #available(iOS 8.0, *) {
            self.modernWebView.frame = frame
        } else {
            self.oldWebView.frame = frame
        }
    }
    
    public func evaluateJS(script: String, result: @escaping (String) -> Void) {
        if #available(iOS 8.0, *) {
            self.modernWebView.evaluateJavaScript(script) { (response, error) in
                if let error = error {
                    print(error)
                } else {
                    if let response  = response {
                        print(response)
                    }
                }
            }
        } else {
            result(self.oldWebView.stringByEvaluatingJavaScript(from: script) ?? "")
        }
    }
    
    public func sizedFrame() -> CGSize{
        if #available(iOS 8.0, *) {
            return self.modernWebView.sizeThatFits(CGSize.zero)
        } else {
            return self.oldWebView.sizeThatFits(CGSize.zero)
        }
    }
}

extension DynamicWebView: UIWebViewDelegate {
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        if let delegate = self.delegate {
            delegate.webViewDidFinishedLoading?(view: self)
        }
    }
}

@available(iOS 8.0, *)
extension DynamicWebView: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        if let delegate = self.delegate {
            delegate.webViewDidFinishedLoading?(view: self)
        }
    }
}
