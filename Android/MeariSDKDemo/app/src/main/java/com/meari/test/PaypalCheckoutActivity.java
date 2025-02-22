package com.meari.test;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.webkit.ValueCallback;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.meari.sdk.MeariUser;
import com.meari.sdk.callback.IStringResultCallback;
import com.meari.sdk.common.BuyServiceType;
import com.meari.sdk.common.PayType;
import com.meari.sdk.utils.Logger;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Description: PaypalCheckoutActivity
 * Author: wu
 * Date Time: 2022/12/21 11:06
 * Version: 5.0
 */
public class PaypalCheckoutActivity extends AppCompatActivity {

    private int SOURCEAPP = 1;
    private String url = "";
    private int payType = PayType.PAYPAL;
    private String orderId = "";
    // 需要找服务器确定地址
    private final String return_url = "https://meari-us.s3.us-west-1.amazonaws.com/paypal/" + SOURCEAPP;
    //连续订阅
    private boolean subscribe = false;
    private WebView webView;
    private int servicePackageType = BuyServiceType.CLOUD;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_paypal_checkout);
        initData();
        initView();
    }

    public void initData() {
        Bundle bundle = getIntent().getExtras();
        if (bundle != null) {
            url = bundle.getString("url");
            subscribe = bundle.getBoolean("subscribe");
            servicePackageType = bundle.getInt("servicePackageType");
            payType = bundle.getInt("payType");
            if (payType == PayType.YOO_MONEY && url.contains("orderId=")) {
                orderId = url.split("orderId=")[1];
            }
            Log.i("tag", "--->Paypal--url: " + url);
            Log.i("tag", "--->Paypal--orderId: " + orderId);
            Log.i("tag", "--->Paypal--subscribe: " + subscribe);
        }
    }

    public String getUrlParameter(String url, String name) {
        url += "&";
//        String pattern = "(\\?|&){1}#{0,1}" + name + "=[a-zA-Z0-9]*(&{1})";
        String pattern = "([?&])#?" + name + "=[a-zA-Z0-9-]*(&)";
        Pattern r = Pattern.compile(pattern);
        Matcher matcher = r.matcher(url);
        if (matcher.find() && matcher.group(0) != null) {
            return matcher.group(0).split("=")[1].replace("&", "");
        } else {
            return "";
        }
    }

    public void initView() {
        webView = findViewById(R.id.web_view);
        webView.setWebViewClient(new WebViewClient() {

            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
//                String title = view.getTitle();
//                if (!TextUtils.isEmpty(title)) {
//                    setTitle(title);
//                }
                Logger.i("webview", "onPageFinished: " + url);
                view.loadUrl("javascript:(function() {document.getElementById('cancelLink').style.visibility = 'hidden';})()");
            }

            @Override
            public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
                String redirectUrl = request.getUrl().toString();
                Log.i("tag", "--->Paypal--shouldOverrideUrlLoading: " + redirectUrl);
                if (redirectUrl.startsWith(return_url) && redirectUrl.contains("token")) {
                    String token = getUrlParameter(redirectUrl, "token");
                    if (subscribe) {
                        String subscription_id = getUrlParameter(redirectUrl, "subscription_id");
                        String ba_token = getUrlParameter(redirectUrl, "ba_token");
                        capturePaymentOrder(subscription_id);
                        return true;
                    } else {
                        String payerID = getUrlParameter(redirectUrl, "PayerID");
                        capturePaymentOrder(token);
                        return true;
                    }
                }
                if (payType == PayType.YOO_MONEY) {
                    capturePaymentOrder(orderId);
                    return true;
                }
                return false;
            }
        });
        webView.setScrollBarStyle(View.SCROLLBARS_INSIDE_OVERLAY);//滚动条风格，为0指滚动条不占用空间，直接覆盖在网页上
        //得到webview设置
        WebSettings webSettings = webView.getSettings();
        //允许使用javascript
        webSettings.setJavaScriptEnabled(true);
        //设置字符编码
        webSettings.setDefaultTextEncodingName("UTF-8");
        //支持缩放
        webSettings.setSupportZoom(true);
        webSettings.setBuiltInZoomControls(true);
        webSettings.setUseWideViewPort(true);
        webSettings.setLoadWithOverviewMode(true);
        WebChromeClient wvcc = new WebChromeClient() {
            @Override
            public void onReceivedTitle(WebView view, String title) {
                super.onReceivedTitle(view, title);
//                if (TextUtils.isEmpty(web_title)||webSettings.equals("")) {
//                    setTitle(title);
//                }
            }

            // For Android < 3.0
            public void openFileChooser(ValueCallback<Uri> valueCallback) {
            }

            // For Android  >= 3.0
            public void openFileChooser(ValueCallback valueCallback, String acceptType) {
            }

            //For Android  >= 4.1
            public void openFileChooser(ValueCallback<Uri> valueCallback, String acceptType, String capture) {

            }

            // For Android >= 5.0
            @Override
            public boolean onShowFileChooser(WebView webView, ValueCallback<Uri[]> filePathCallback, FileChooserParams fileChooserParams) {
                return true;
            }

            @Nullable
            @Override
            public Bitmap getDefaultVideoPoster() {
                if (super.getDefaultVideoPoster() == null) {
                    return BitmapFactory.decodeResource(getResources(),
                            R.mipmap.ic_launcher);
                } else {
                    return super.getDefaultVideoPoster();
                }
            }
        };
        // 设置setWebChromeClient对象
        webView.setWebChromeClient(wvcc);
        webView.loadUrl(url);
//        ivBack.setOnClickListener(v -> {
//            if (webView.canGoBack()) {
//                webView.goBack();
//            } else {
//                finish();
//            }
//        });
    }

    private void capturePaymentOrder(String orderId) {
        MeariUser.getInstance().capturePaymentOrder(servicePackageType, orderId, payType, " ", new IStringResultCallback() {
            @Override
            public void onSuccess(String result) {
                Intent intent = new Intent();
                Bundle bundle = new Bundle();
                bundle.putInt("code", 1001);
                bundle.putString("msg", result);
                intent.putExtras(bundle);
                setResult(RESULT_OK, intent);
                finish();
            }

            @Override
            public void onError(int errorCode, String errorMsg) {
                Intent intent = new Intent();
                Bundle bundle = new Bundle();
                bundle.putInt("code", errorCode);
                bundle.putString("msg", errorMsg);
                intent.putExtras(bundle);
                setResult(RESULT_OK, intent);
                finish();
            }
        });
    }
}
