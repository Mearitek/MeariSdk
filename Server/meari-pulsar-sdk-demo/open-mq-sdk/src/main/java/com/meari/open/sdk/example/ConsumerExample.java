package com.meari.open.sdk.example;

import com.alibaba.fastjson.JSON;
import com.meari.open.sdk.util.AesUtil;
import com.meari.open.sdk.mq.MqConfigs;
import com.meari.open.sdk.mq.MqConsumer;
import org.apache.pulsar.client.api.MessageId;

public class ConsumerExample {

    private static String URL = MqConfigs.CN_SERVER_URL;
    private static String ACCESS_ID = "";
    private static String ACCESS_KEY = "";

    public static void main(String[] args) throws Exception {
        MqConsumer mqConsumer = MqConsumer.build().serviceUrl(URL).accessId(ACCESS_ID).accessKey(ACCESS_KEY)
                .messageListener(message -> {
                    MessageId msgId = message.getMessageId();
                    String tid = message.getProperty("tid");
                    long publishTime = message.getPublishTime();
                    String payload = new String(message.getData());
                    System.out.println("<msgId>" + msgId + "<tid>" + tid + "<publishTime>" + publishTime + "<payload>" + payload);
                    payloadHandler(payload);
                });
        mqConsumer.start();
    }

    private static void payloadHandler(String payload) {
        try {
            MessageVO messageVO = JSON.parseObject(payload, MessageVO.class);
            //decryption data
            String dataJsonStr = AesUtil.decrypt(messageVO.getData(), ACCESS_KEY.substring(6, 22));
            System.out.println("messageVO=" + messageVO.toString() + "\n" + "data after decryption dataJsonStr=" + dataJsonStr);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
