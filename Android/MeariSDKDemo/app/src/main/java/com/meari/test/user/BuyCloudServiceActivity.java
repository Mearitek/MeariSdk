package com.meari.test.user;

import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.alipay.sdk.app.PayTask;
import com.braintreepayments.api.BraintreeFragment;
import com.braintreepayments.api.DataCollector;
import com.braintreepayments.api.PayPal;
import com.braintreepayments.api.exceptions.InvalidArgumentException;
import com.braintreepayments.api.interfaces.BraintreeErrorListener;
import com.braintreepayments.api.interfaces.BraintreeResponseListener;
import com.braintreepayments.api.interfaces.ConfigurationListener;
import com.braintreepayments.api.interfaces.PaymentMethodNonceCreatedListener;
import com.braintreepayments.api.models.Configuration;
import com.braintreepayments.api.models.PayPalAccountNonce;
import com.braintreepayments.api.models.PayPalRequest;
import com.braintreepayments.api.models.PaymentMethodNonce;
import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.bean.CloudPriceInfo;
import com.meari.sdk.bean.OrderInfo;
import com.meari.sdk.callback.IPayCallback;
import com.meari.sdk.callback.IStringResultCallback;
import com.meari.sdk.utils.Logger;
import com.meari.test.R;
import com.meari.test.alipay.PayResult;

import java.math.BigDecimal;
import java.util.Locale;
import java.util.Map;

public class BuyCloudServiceActivity extends AppCompatActivity implements ConfigurationListener,
        PaymentMethodNonceCreatedListener, BraintreeErrorListener {

    private CameraInfo mCameraInfo;
    private CloudPriceInfo mEventCloudInfo;     //事件云存储价格
    private CloudPriceInfo mDayCloudInfo;       //全天云存储价格
    private String mMoneyPriceFormat = "";
    /**
     * 0: Event record
     * 1: All day record
     */
    private int mRecordType = 0;
    /**
     * default 1
     */
    private int mAmount = 1;
    /**
     * 0:Month
     * 1:Quarterly
     * 2:Year
     */
    private int mBuyType = 0;
    /**
     * 0: 3days
     * 1: 7days
     * 2: 30days
     */
    private int mRecordTimeType = 0;
    private BigDecimal monthPrice3;
    private BigDecimal monthPrice7;
    private BigDecimal monthPrice30;
    private BigDecimal quarterPrice3;
    private BigDecimal quarterPrice7;
    private BigDecimal quarterPrice30;
    private BigDecimal yearPrice3;
    private BigDecimal yearPrice7;
    private BigDecimal yearPrice30;
    private BigDecimal price;


    private TextView tvPrice;
    private Button btnCheckOut;

    protected int mPayType = 1;
    private OrderInfo mOrderInfo;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_buy_cloud_service);

        initView();
    }

    private void initView() {
        Bundle bundle = getIntent().getExtras();
        if (bundle != null) {
            mCameraInfo = (CameraInfo) bundle.getSerializable("CameraInfo");
            mEventCloudInfo = (CloudPriceInfo) bundle.getSerializable("storageEvent");
            mDayCloudInfo = (CloudPriceInfo) bundle.getSerializable("storageContinue");
        }

        tvPrice = findViewById(R.id.tv_price);
        btnCheckOut = findViewById(R.id.btn_check_out);

        mMoneyPriceFormat = "￥%s";
        if (MeariUser.getInstance().getUserInfo().getCountryCode().equals("CN")) {
            mMoneyPriceFormat = "￥%s";
            mPayType = 1;
            findViewById(R.id.iv_alipay).setVisibility(View.VISIBLE);
            findViewById(R.id.iv_paypal).setVisibility(View.GONE);
        } else {
            mMoneyPriceFormat = "$%s";
            mPayType = 2;
            findViewById(R.id.iv_alipay).setVisibility(View.GONE);
            findViewById(R.id.iv_paypal).setVisibility(View.VISIBLE);
            postPaypalPayToken();
        }

        select();

        btnCheckOut.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (mPayType == 1) {
                    getAlipaySign();
                } else {
                    PayPal.requestOneTimePayment(mBraintreeFragment, getPayPalRequest(price.toString()));
                }
            }
        });

    }

    private void select() {
        mRecordType = 0;
        mBuyType = 0;
        mRecordTimeType = 0;
        if (mRecordType == 0) {
            monthPrice3 = mEventCloudInfo.getThreeM();
            monthPrice7 = mEventCloudInfo.getSevenM();
            monthPrice30 = mEventCloudInfo.getThirtyM();

            quarterPrice3 = mEventCloudInfo.getThreeS();
            quarterPrice7 = mEventCloudInfo.getSevenS();
            quarterPrice30 = mEventCloudInfo.getThirtyS();

            yearPrice3 = mEventCloudInfo.getThreeY();
            yearPrice7 = mEventCloudInfo.getSevenY();
            yearPrice30 = mEventCloudInfo.getThirtyY();
        } else {
            monthPrice3 = mDayCloudInfo.getThreeM();
            monthPrice7 = mDayCloudInfo.getSevenM();
            monthPrice30 = mDayCloudInfo.getThirtyM();

            quarterPrice3 = mDayCloudInfo.getThreeS();
            quarterPrice7 = mDayCloudInfo.getSevenS();
            quarterPrice30 = mDayCloudInfo.getThirtyS();

            yearPrice3 = mDayCloudInfo.getThreeY();
            yearPrice7 = mDayCloudInfo.getSevenY();
            yearPrice30 = mDayCloudInfo.getThirtyY();
        }
        price = monthPrice3;
        tvPrice.setText(String.format(mMoneyPriceFormat, price.toString()));
    }


    private void getAlipaySign() {
        String deviceID = mCameraInfo.getDeviceID();
        String payMoney = price.toString();
        String serverTime = String.valueOf(mAmount);
        String mealType = "";
        switch (mBuyType) {
            case 0:
                mealType = "M";
                break;
            case 1:
                mealType = "S";
                break;
            case 2:
                mealType = "Y";
                break;
        }
        String storageTime = mRecordTimeType == 0 ? "3" : (mRecordTimeType == 1 ? "7" : "30");
        String storageType = String.valueOf(mRecordType);
        MeariUser.getInstance().getAlipaySign(deviceID, payMoney, serverTime, mealType, storageTime, storageType,
                new IPayCallback() {
                    @Override
                    public void onSuccess(OrderInfo orderInfo) {
                        Logger.i("tag", "--->getAlipaySign: OrderNum:" + orderInfo.getOrderNum());
                        mOrderInfo = orderInfo;
                        mOrderInfo.setPayStatus(0);
                        if (!mOrderInfo.getPayMoney().toString().equals(price.toString())) {
                            price = mOrderInfo.getPayMoney();
                        }
                        tvPrice.setText(String.format(Locale.CHINA, mMoneyPriceFormat, price.toString()));
                        String orderNum = mOrderInfo.getOrderNum();

                        payAlipay(mOrderInfo.getPayUrl());
                    }

                    @Override
                    public void onError(int code, String error) {

                    }
                });
    }

    private static final int SDK_PAY_FLAG = 1;

    /**
     * 具体流程可参考支付宝官方文档
     *
     * @param sigPay
     */
    public void payAlipay(final String sigPay) {
        Runnable payRunnable = new Runnable() {
            @Override
            public void run() {
                // 构造PayTask 对象
                PayTask alipay = new PayTask(BuyCloudServiceActivity.this);
                // 调用支付接口，获取支付结果
                Map<String, String> result = alipay.payV2(sigPay, true);

                Message msg = Message.obtain();
                msg.what = SDK_PAY_FLAG;
                msg.obj = result;
                mHandler.sendMessage(msg);
            }
        };
        Thread payThread = new Thread(payRunnable);
        payThread.start();
    }

    private Handler mHandler = new Handler(new Handler.Callback() {
        public boolean handleMessage(Message msg) {
            switch (msg.what) {
                case SDK_PAY_FLAG: {
                    PayResult payResult = new PayResult((Map<String, String>) msg.obj);
                    String resultStatus = payResult.getResultStatus();
                    Logger.i("tag", "--->支pay: resultStatus:" + resultStatus);
                    // 判断resultStatus 为“9000”则代表支付成功，具体状态码代表含义可参考接口文档
                    if (TextUtils.equals(resultStatus, "9000")) {
                        //支付成功
                    } else {
                        // 判断resultStatus 为非"9000"则代表可能支付失败
                        // "8000"代表支付结果因为支付渠道原因或者系统原因还在等待支付结果确认，最终交易是否成功以服务端异步通知为准（小概率状态）
                        String reason;
                        if (TextUtils.equals(resultStatus, "8000")) {
                            reason = "支付结果确认中";
                        } else {
                            reason = "其他原因";
                            // 其他值就可以判断为支付失败，包括用户主动取消支付，或者系统返回的错误
                        }
                    }
                    break;
                }
                default:
                    break;
            }
            return false;
        }
    });


    protected BraintreeFragment mBraintreeFragment;
    private PaymentMethodNonce mPaymentMethodNonce;
    final String EXTRA_COLLECT_DEVICE_DATA = "collect_device_data";
    private String mAuthorization = "";
    private String mDeviceData = "";

    /**
     * get PayPal Token
     */
    public void postPaypalPayToken() {
        MeariUser.getInstance().getPayPalToken(new IStringResultCallback() {
            @Override
            public void onSuccess(String result) {
                Log.i("tag","--->postPaypalPayToken--onSuccess: " + result);
                mAuthorization = result;
                try {
                    mBraintreeFragment = BraintreeFragment.newInstance(BuyCloudServiceActivity.this, mAuthorization);
                } catch (InvalidArgumentException e) {
                    e.printStackTrace();
                    Log.i("tag","--->postPaypalPayToken--onError: " + e.getLocalizedMessage());
                }
            }

            @Override
            public void onError(int code, String error) {
                Log.i("tag","--->postPaypalPayToken--onError: " + error);
            }
        });
    }


    /**
     * The specific process can refer to the official PayPal document
     *
     * @param amount
     * @return
     */
    private PayPalRequest getPayPalRequest(@Nullable String amount) {
        PayPalRequest request = new PayPalRequest(amount);
        request.displayName("Cloud Storage Service");
//        request.offerCredit(true);
//        request.intent(PayPalRequest.INTENT_SALE);
//        request.userAction(PayPalRequest.USER_ACTION_COMMIT);
//        request.intent(PayPalRequest.INTENT_AUTHORIZE);
        return request;
    }

    @Override
    public void onConfigurationFetched(Configuration configuration) {
        if (getIntent().getBooleanExtra(EXTRA_COLLECT_DEVICE_DATA, true)) {
            DataCollector.collectDeviceData(mBraintreeFragment, new BraintreeResponseListener<String>() {
                @Override
                public void onResponse(String deviceData) {
                    mDeviceData = deviceData;
                }
            });
        }
    }

    @Override
    public void onError(Exception e) {
        // Pay failure, please try again!
        Log.i("tag","--->Pay failure--onError: " + e.getLocalizedMessage());
    }

    @Override
    public void onPaymentMethodNonceCreated(PaymentMethodNonce paymentMethodNonce) {
        this.mPaymentMethodNonce = paymentMethodNonce;

        if (paymentMethodNonce instanceof PayPalAccountNonce) {
            PayPalAccountNonce nonce = (PayPalAccountNonce) paymentMethodNonce;
        }

        if (mPaymentMethodNonce == null)
            return;

        String deviceID = mCameraInfo.getDeviceID();
        String payMoney = price.toString();
        String serverTime = String.valueOf(mAmount);
        String mealType = "";
        switch (mBuyType) {
            case 0:
                mealType = "M";
                break;
            case 1:
                mealType = "S";
                break;
            case 2:
                mealType = "Y";
                break;
        }
        String storageTime = mRecordTimeType == 0 ? "3" : (mRecordTimeType == 1 ? "7" : "30");
        String storageType = String.valueOf(mRecordType);
        String payType = String.valueOf(2);
        String payPalNonce = mPaymentMethodNonce.getNonce();
        MeariUser.getInstance().createPayPalOrder(deviceID, payMoney, serverTime, mealType, storageTime, storageType, payType, payPalNonce,
                new IPayCallback() {
                    @Override
                    public void onSuccess(OrderInfo orderInfo) {
                        mPaymentMethodNonce = null;
                        //pay success
                    }

                    @Override
                    public void onError(int code, String error) {
                        if (code == 1052) {
                            //Repeat payment
                        }
                    }
                });
    }
}