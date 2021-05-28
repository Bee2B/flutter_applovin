import Flutter
import UIKit
import AppLovinSDK

public class SwiftFlutterApplovinPlugin: NSObject, FlutterPlugin, MARewardedAdDelegate {
    var rewardedAd: MARewardedAd?
    
    var retryAttempt = 0.0
    
    static var methodChannel: FlutterMethodChannel!

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_applovin", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterApplovinPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        methodChannel = channel
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch (call.method) {
        case "init":
            if let dic = call.arguments as? [String: Any?] {
                if let unitId = dic["unitId"] as? String {
                    appLovinInit(unitId)
                }
            } else {
                // TODO: Throw some info to flutter
            }
        case "showRewardVideo":
            if let ad = rewardedAd {
                if ad.isReady {
                    ad.show()
                    result(true)
                    break
                }
            }
            result(false)
        case "isLoaded":
            result(rewardedAd?.isReady ?? false)
        default:
            result(FlutterMethodNotImplemented);
        }
    }
    
    func appLovinInit(_ unitId: String) {
        ALSdk.shared()!.mediationProvider = "max"
        ALSdk.shared()!.initializeSdk { (configuration: ALSdkConfiguration) in
        }
        
        rewardedAd = MARewardedAd.shared(withAdUnitIdentifier: unitId)
        rewardedAd?.delegate = self
        
        rewardedAd?.load()
    }
}

func mapMAAd(_ ad: MAAd) -> [String : Any?] {
    return [
        "format": converMAAdFormatToString(ad.format),
        "adUnitIdentifier": ad.adUnitIdentifier,
        "networkName": ad.networkName,
        "creativeIdentifier": ad.creativeIdentifier,
        "revenue": ad.revenue,
        "placement": ad.placement,
    ]
}

func converMAAdFormatToString(_ format: MAAdFormat) -> String {
    switch format {
    case MAAdFormat.banner: return "banner"
    case MAAdFormat.crossPromo: return "crossPromo"
    case MAAdFormat.interstitial: return "interstitial"
    case MAAdFormat.leader: return "leader"
    case MAAdFormat.mrec: return "mrec"
    case MAAdFormat.native: return "native"
    case MAAdFormat.rewarded: return "rewarded"
    case MAAdFormat.rewardedInterstitial: return "rewardedInterstitial"
    default:
        return "unknown"
    }
}

public extension SwiftFlutterApplovinPlugin {
    // MARK: MAAdDelegate Protocol
    func didLoad(_ ad: MAAd) {
        retryAttempt = 0
        SwiftFlutterApplovinPlugin.methodChannel.invokeMethod("didLoad", arguments: mapMAAd(ad))
    }

    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
        SwiftFlutterApplovinPlugin.methodChannel.invokeMethod("didFailToLoadAd", arguments: nil)
        retryAttempt += 1
        let delaySec = pow(2.0, min(6.0, retryAttempt))
        DispatchQueue.main.asyncAfter(deadline: .now() + delaySec) {
            self.rewardedAd?.load()
        }
        
    }

    func didDisplay(_ ad: MAAd) {
        SwiftFlutterApplovinPlugin.methodChannel.invokeMethod("didDisplay", arguments: mapMAAd(ad))
    }

    func didClick(_ ad: MAAd) {
        SwiftFlutterApplovinPlugin.methodChannel.invokeMethod("didClick", arguments: mapMAAd(ad))
    }

    func didHide(_ ad: MAAd) {
        SwiftFlutterApplovinPlugin.methodChannel.invokeMethod("didHide", arguments: mapMAAd(ad))
        // Rewarded ad is hidden. Pre-load the next ad
        rewardedAd?.load()
    }

    func didFail(toDisplay ad: MAAd, withError error: MAError) {
        SwiftFlutterApplovinPlugin.methodChannel.invokeMethod("didFail", arguments: mapMAAd(ad))
        // Rewarded ad failed to display. We recommend loading the next ad
        rewardedAd?.load()
    }

    func didPayRevenue(for ad: MAAd) {
        SwiftFlutterApplovinPlugin.methodChannel.invokeMethod("didPayRevenue", arguments: mapMAAd(ad))
    }

    // MARK: MARewardedAdDelegate Protocol

    func didStartRewardedVideo(for ad: MAAd) {
        SwiftFlutterApplovinPlugin.methodChannel.invokeMethod("didStartRewardedVideo", arguments: mapMAAd(ad))
    }

    func didCompleteRewardedVideo(for ad: MAAd) {
        SwiftFlutterApplovinPlugin.methodChannel.invokeMethod("didCompleteRewardedVideo", arguments: mapMAAd(ad))
    }

    func didRewardUser(for ad: MAAd, with reward: MAReward) {
        SwiftFlutterApplovinPlugin.methodChannel.invokeMethod("didRewardUser", arguments: mapMAAd(ad))
    }
}

