package com.tvo.danrom

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import com.tvo.danrom.R
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class ListTileNativeAdFactory(val context: Context) : GoogleMobileAdsPlugin.NativeAdFactory {
  override fun createNativeAd(
    nativeAd: NativeAd,
    customOptions: MutableMap<String, Any>?
  ) : NativeAdView {
    val nativeAdView = LayoutInflater.from(context).inflate(R.layout.list_tile_native_ad, null) as NativeAdView

    with(nativeAdView) {
      val attributionViewSmall = findViewById<TextView>(R.id.tv_list_tile_native_ad_attribution_small)

      val iconView = findViewById<ImageView>(R.id.iv_list_tile_native_ad_icon)
      val icon = nativeAd.icon
      
      if (icon != null) {
        attributionViewSmall.visibility = View.VISIBLE
        iconView.setImageDrawable(icon.drawable)
      }
      this.iconView = iconView

      val button = findViewById<Button>(R.id.bv_list_tile_native_ad_button)
      button.setOnClickListener {
          val intent = Intent(Intent.ACTION_VIEW, Uri.parse(nativeAd.callToAction))
          context.startActivity(intent)
      }

      button.setVisibility(View.VISIBLE)
      val images = nativeAd.images
      val imageView = findViewById<ImageView>(R.id.iv_list_tile_native_ad_image);
      imageView.setImageDrawable(images[0].drawable)
      imageView.setVisibility(View.VISIBLE);

      val headlineView = findViewById<TextView>(R.id.tv_list_tile_native_ad_headline)
      headlineView.text = nativeAd.headline
      this.headlineView = headlineView

      val bodyView = findViewById<TextView>(R.id.tv_list_tile_native_ad_body)
      with(bodyView) {
        text = nativeAd.body
        visibility = if (nativeAd.body?.isNotEmpty() == true) View.VISIBLE else View.INVISIBLE
      }
      this.bodyView = bodyView

      setNativeAd(nativeAd)
    }

    return nativeAdView
  }
}