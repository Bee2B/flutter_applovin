package com.example.flutter_applovin

import com.applovin.mediation.*
import com.applovin.mediation.ads.MaxRewardedAd;
import java.lang.Exception
import java.util.*

class RewardedVideo(unitId: String, private var plugin: FlutterApplovinPlugin) : MaxRewardedAdListener {
    private var rewardedAd: MaxRewardedAd = MaxRewardedAd.getInstance(unitId, plugin.activity)
    private var retryAttempt: Int = 0

    init {
        rewardedAd.setListener(this)
        rewardedAd.loadAd()
    }

    fun show() {
        try {
            if (rewardedAd.isReady) {
                rewardedAd.showAd()
            }
        } catch (e: Exception) {
            //
        }
    }

    fun isLoaded(): Boolean {
        return rewardedAd.isReady
    }

    override fun onAdLoaded(ad: MaxAd?) {
        retryAttempt = 0
        plugin.callback("onAdLoaded", mapMAAd(ad))
    }

    override fun onAdDisplayed(ad: MaxAd?) {
        plugin.callback("didDisplay", mapMAAd(ad))
    }

    override fun onAdHidden(ad: MaxAd?) {
        plugin.callback("didHide", mapMAAd(ad))
        rewardedAd.loadAd()
    }

    override fun onAdClicked(ad: MaxAd?) {
        plugin.callback("didClick", mapMAAd(ad))
    }

    override fun onAdLoadFailed(adUnitId: String?, error: MaxError?) {
        plugin.callback("didFailToLoadAd", mapOf<String, Any>())
    }

    override fun onAdDisplayFailed(ad: MaxAd?, error: MaxError?) {
        plugin.callback("didFailToDisplay", mapMAAd(ad))
    }

    override fun onRewardedVideoStarted(ad: MaxAd?) {
        plugin.callback("didStartRewardedVideo", mapMAAd(ad))
    }

    override fun onRewardedVideoCompleted(ad: MaxAd?) {
        plugin.callback("didCompleteRewardedVideo", mapMAAd(ad))
    }

    override fun onUserRewarded(ad: MaxAd?, reward: MaxReward?) {
        plugin.callback("didRewardUser", mapMAAd(ad))
    }

    private fun convertMAAdFormatToString(format: MaxAdFormat): String {
        return format.displayName.toLowerCase(Locale.ROOT)
    }

    private fun mapMAAd(ad: MaxAd?): Map<String, Any> {
        return if (ad == null) {
            mapOf()
        } else {
            mapOf(
                    Pair("format", convertMAAdFormatToString(ad.format)),
                    Pair("adUnitIdentifier", ad.adUnitId),
                    Pair("networkName", ad.networkName),
                    Pair("creativeIdentifier", ad.creativeId),
                    Pair("revenue", ad.revenue),
                    Pair("placement", ad.placement)
            )
        }
    }
}