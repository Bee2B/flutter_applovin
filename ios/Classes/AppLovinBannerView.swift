//
//  AppLovinBannerView.swift
//  Pods
//
//  Created by DDDrop on 2021/06/23.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___.
//  All rights reserved.
//
    
import AppLovinSDK

public class AppLovinBannerFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    
    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return AppLovinBanner(frame: frame, viewIdentifier: viewId, arguments: args,binaryMessenger: messenger)
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}

public class AppLovinBanner: NSObject, FlutterPlatformView {
    private var _view: MAAdView!
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        super.init()
        
        if let a = args as? [String:Any] {
            _view = MAAdView(adUnitIdentifier: a["unit"] as! String)
            _view.delegate = self
            _view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: a["height"] as! CGFloat)
            _view.loadAd()
        }
    }
    
    public func view() -> UIView {
        return _view
    }
}

extension AppLovinBanner: MAAdViewAdDelegate {
    public func didLoad(_ ad: MAAd) {}

    public func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {}

    public func didClick(_ ad: MAAd) {}

    public func didFail(toDisplay ad: MAAd, withError error: MAError) {}

    public func didExpand(_ ad: MAAd) {}

    public func didCollapse(_ ad: MAAd) {}
    
    // MARK: Deprecated Callbacks
    public func didDisplay(_ ad: MAAd) {}
    public func didHide(_ ad: MAAd) {}
}
