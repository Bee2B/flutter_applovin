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
    private var _view: UIView
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        _view = UIView()
        super.init()
        
        var w: Double = 375
        var h: Double = 64
        if let a = args as? [String:Any] {
            w = a["width"] as? Double ?? w
            h = a["height"] as? Double ?? h
        }
        createNativeView(view: _view, frame: CGRect(x: 0, y: 0, width: w, height: h))
    }
    
    public func view() -> UIView {
        return _view
    }
    
    func createNativeView(view _view: UIView, frame: CGRect){
        if let sdk = ALSdk.shared() {
            let adView = ALAdView(frame: CGRect(x: 0, y: 0, width: 400, height: 120), size: ALAdSize.banner, sdk: sdk)
            adView.loadNextAd()
            adView.isAutoloadEnabled = true
            _view.addSubview(adView)
        } else {
            print("wow!")
        }
    }
}
