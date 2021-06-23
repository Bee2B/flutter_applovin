package com.example.flutter_applovin

import android.content.Context
import android.view.View
import com.applovin.adview.AppLovinAdView
import com.applovin.sdk.AppLovinAd
import com.applovin.sdk.AppLovinAdClickListener
import com.applovin.sdk.AppLovinAdSize
import io.flutter.plugin.platform.PlatformView
import com.applovin.sdk.AppLovinSdk


internal class AppBannerView(context: Context, id: Int, createParams: Map<String?, Any?>?) : PlatformView, AppLovinAdClickListener {
    private val view: AppLovinAdView

    override fun getView(): View {
        return view
    }

    override fun dispose() {
    }

    init {
        view = AppLovinAdView(AppLovinSdk.getInstance(context), AppLovinAdSize.BANNER, context)
        view.loadNextAd()
    }

    override fun adClicked(ad: AppLovinAd?) {
        print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
        view.loadNextAd()
    }
}