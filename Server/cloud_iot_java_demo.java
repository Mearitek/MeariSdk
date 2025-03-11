package com.meari.demo;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.TypeReference;
import com.alibaba.fastjson.serializer.SerializerFeature;
import lombok.Data;
import lombok.experimental.Accessors;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.ResponseBody;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.io.Serializable;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.LinkedHashMap;
import java.util.Map;

public class cloud_iot_java_demo {

    private static final String BASE_DOMAIN = "https://apis.cloudedge360.com";
    private static final String URL_REDIRECT = "/v2/third/sdk/redirect";
    private static final String URL_IOT = "/v1/third/customer/iot/set";

    private static final String SIGNATURE_VERSION = "1.0";
    private static final String SIGNATURE_METHOD = "HMAC-SHA1";
    private static final String IOT_TYPE = "3";

    private static class HmacSha1Util {
        private static final String MAC_NAME = "HmacSHA1";
        private static final String ENCODING = "UTF-8";

        static byte[] encrypt(String encryptText, String encryptKey) throws Exception {
            Mac mac = Mac.getInstance(MAC_NAME);
            mac.init(new SecretKeySpec(encryptKey.getBytes(ENCODING), MAC_NAME));
            return mac.doFinal(encryptText.getBytes(ENCODING));
        }
    }

    @Data
    @Accessors(chain = true)
    private class RequestParam implements Serializable {
        private String partnerKey;
        private String partnerSecret;

        private String signatureVersion;
        private String signatureMethod;
        private String signatureNonce;
        private String timestamp;

        private String sourceApp;
        private String userAccount;
        private String snNum;
        private String items;
        private String countryCode;
        private String iotType;
    }

    public static void main(String[] args)throws Exception {
        String partnerKey = "";
        String partnerSecret = "";
        String sourceApp = "";

        String userAccount = "testUserAccount";
        String countryCode = "US";
        String snNum = "";
        String items = "{\"118\":0}";

        new cloud_iot_java_demo().request(partnerKey, partnerSecret, sourceApp, userAccount, snNum, items, countryCode);
    }

    private void request(String partnerKey, String partnerSecret, String sourceApp, String userAccount, String snNum, String items, String countryCode)throws Exception {
        long millis = System.currentTimeMillis();
        String signatureNonce = String.valueOf(millis);
        String timestamp = String.valueOf(millis);

        RequestParam redirectParam = new RequestParam()
                .setCountryCode(countryCode)
                .setSourceApp(sourceApp)
                .setPartnerKey(partnerKey)
                .setSignatureVersion(SIGNATURE_VERSION)
                .setSignatureMethod(SIGNATURE_METHOD)
                .setSignatureNonce(signatureNonce)
                .setTimestamp(timestamp);
        String sortStringRedirect = getSortString(redirectParam);
        String redirectParamStr = sortStringRedirect + "&signature=" + getSignature(sortStringRedirect, partnerSecret);
        System.out.println(redirectParamStr);
        String redirectResponse = redirect(redirectParamStr);
        if (redirectResponse==null || "".equals(redirectResponse)) {
            return;
        }
        String iotDomain = JSONObject.parseObject(redirectResponse).getJSONObject("result").getString("apiServer");

        RequestParam iotParam = new RequestParam()
                .setUserAccount(userAccount.toLowerCase())
                .setSourceApp(sourceApp)
                .setSnNum(snNum)
                .setItems(items)
                .setCountryCode(countryCode)
                .setIotType(IOT_TYPE)
                .setPartnerKey(partnerKey)
                .setSignatureVersion(SIGNATURE_VERSION)
                .setSignatureMethod(SIGNATURE_METHOD)
                .setSignatureNonce(signatureNonce)
                .setTimestamp(timestamp);
        String sortStringIot = getSortString(iotParam);
        String iotParamStr = sortStringIot + "&signature=" + getSignature(sortStringIot, partnerSecret);
        System.out.println(iotParamStr);
        String iotResponse = iot(iotDomain, iotParamStr);
        if (iotResponse==null || "".equals(iotResponse)) {
            return;
        }

        JSONObject iotJson = JSONObject.parseObject(iotResponse);
        System.out.println(iotJson);
    }

    private String redirect(String requestParamStr) {
        return okHttpGetRequest(BASE_DOMAIN + URL_REDIRECT + "?" + requestParamStr);
    }

    private String iot(String domain, String requestParamStr) {
        return okHttpGetRequest(domain + URL_IOT + "?" + requestParamStr);
    }

    private String okHttpGetRequest(String url) {
        OkHttpClient client = new OkHttpClient().newBuilder()
                .build();
        Request request = new Request.Builder()
                .url(url)
                .method("GET", null)
                .build();

        Response response = null;
        try {
            response = client.newCall(request).execute();

            ResponseBody responseBody = response.body();
            if (response.code() == 200 && responseBody != null) {
                return responseBody.string();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (response != null){
                response.close();
            }
        }
        return null;
    }

    private String getSortString(Object... objects) {
        JSONObject allJson = new JSONObject();
        for (Object object : objects) {
            allJson.putAll(JSON.parseObject(JSON.toJSONString(object)));
        }
        allJson.remove("signature");
        allJson.remove("partnerSecret");

        String sortJsonString = JSON.toJSONString(allJson, SerializerFeature.MapSortField);
        LinkedHashMap<String,String> sortMap = JSON.parseObject(sortJsonString,new TypeReference<LinkedHashMap<String,String>>() {});

        StringBuilder endResult = new StringBuilder();
        for(Map.Entry<String,String> entry : sortMap.entrySet()) {
            endResult.append(entry.getKey()).append("=").append(entry.getValue()).append("&");
        }

        String endResultString = endResult.toString();
        return endResultString.substring(0,endResultString.length()-1);
    }

    private String getSignature(String sortString, String partnerSecret)throws Exception {
        String signature = Base64.getEncoder().encodeToString(HmacSha1Util.encrypt(sortString, partnerSecret));
        return URLEncoder.encode(signature, StandardCharsets.UTF_8.displayName());
    }
}
