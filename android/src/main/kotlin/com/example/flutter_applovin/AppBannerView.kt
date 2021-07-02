package com.example.flutter_applovin

import android.content.Context
import android.view.View
import android.widget.FrameLayout
import com.applovin.adview.AppLovinAdView
import com.applovin.mediation.MaxAd
import com.applovin.mediation.MaxAdViewAdListener
import com.applovin.mediation.MaxError
import com.applovin.mediation.ads.MaxAdView
import com.applovin.sdk.AppLovinAd
import com.applovin.sdk.AppLovinAdClickListener
import com.applovin.sdk.AppLovinAdSize
import io.flutter.plugin.platform.PlatformView
import com.applovin.sdk.AppLovinSdk


internal class AppBannerView(context: Context, id: Int, createParams: Map<String?, Any?>?) : PlatformView, MaxAdViewAdListener {
    private var view: MaxAdView? = null

    override fun getView(): View {
        return view!!
    }

    override fun dispose() {
        view?.destroy()
    }

    init {
        view = MaxAdView(createParams?.get("unit") as String, FlutterApplovinPlugin.activity)
        view!!.setListener(this)
        view!!.loadAd()
    }

//    override fun adClicked(ad: AppLovinAd?) {
//        print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
//        view?.loadAd()
//    }

    // MAX Ad Listener
    override fun onAdLoaded(maxAd: MaxAd) {}

    override fun onAdLoadFailed(adUnitId: String?, error: MaxError?) {}

    override fun onAdDisplayFailed(ad: MaxAd?, error: MaxError?) {}

    override fun onAdClicked(maxAd: MaxAd) {}

    override fun onAdExpanded(maxAd: MaxAd) {}

    override fun onAdCollapsed(maxAd: MaxAd) {}

    override fun onAdDisplayed(maxAd: MaxAd) {}

    override fun onAdHidden(maxAd: MaxAd) {}
}