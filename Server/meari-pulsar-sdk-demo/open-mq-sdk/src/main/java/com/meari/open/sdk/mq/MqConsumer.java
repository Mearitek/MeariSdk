package com.meari.open.sdk.mq;

import org.apache.pulsar.client.api.*;

public class MqConsumer {

    private String serviceUrl;

    private String accessId;

    private String accessKey;

    private MqEnv env = MqEnv.PROD;

    private IMessageListener messageListener;

    public static MqConsumer build() {
        return new MqConsumer();
    }

    public MqConsumer serviceUrl(String serviceUrl) {
        this.serviceUrl = serviceUrl;
        return this;
    }

    public MqConsumer accessId(String accessId) {
        this.accessId = accessId;
        return this;
    }

    public MqConsumer accessKey(String accessKey) {
        this.accessKey = accessKey;
        return this;
    }

    public MqConsumer env(MqEnv env) {
        this.env = env;
        return this;
    }


    public MqConsumer messageListener(IMessageListener messageListener) {
        this.messageListener = messageListener;
        return this;
    }

    /**
     * Start consumer
     *
     * @throws Exception
     */
    public void start() throws Exception {
        System.out.println("###PULSAR_MSG => start initial pulsar consumer");
        if (serviceUrl == null || serviceUrl.trim().length() == 0) {
            throw new IllegalStateException("serviceUrl must be initialized");
        }
        if (accessId == null || accessId.trim().length() == 0) {
            throw new IllegalStateException("accessId must be initialized");
        }
        if (accessKey == null || accessKey.trim().length() == 0) {
            throw new IllegalStateException("accessKey must be initialized");
        }
        if (messageListener == null) {
            throw new IllegalStateException("messageListener must be initialized");
        }
        PulsarClient client = PulsarClient.builder()
                .serviceUrl(serviceUrl)
                .allowTlsInsecureConnection(false)
                .authentication(new MqAuthentication(accessId, accessKey))
                .build();
        Consumer consumer = client.newConsumer()
                .topic(String.format("%s-event-msg", accessId))
                .subscriptionName(String.format("%s-sub", accessId))
                .subscriptionType(SubscriptionType.Failover)
                .autoUpdatePartitions(Boolean.FALSE)
                .subscribe();
        System.out.println("###PULSAR_MSG => pulsar consumer initial success");
        do {
            MessageId msgId = null;
            String tid = null;
            try {
                System.out.println("###PULSAR_MSG => start receive next message");
                Message message = consumer.receive();
                msgId = message.getMessageId();
                tid = message.getProperty("tid");
                long publishTime = message.getPublishTime();
                System.out.println("<msgId>" + msgId + "<tid>" + tid + "<publishTime>" + publishTime);

                Long s = System.currentTimeMillis();
                messageListener.onMessageArrived(message);
                if (MqConfigs.DEBUG) {
                    System.out.println("business processing cost={}"+ (System.currentTimeMillis() - s));
                }

                System.out.println("<msgId>" + msgId + "<tid>" + tid + "<publishTime>" + publishTime);
                consumer.acknowledge(message);
            } catch (Throwable t) {
                System.out.println("<error>" + t);
            }
        } while (true);
    }

    public interface IMessageListener {

        void onMessageArrived(Message message) throws Exception;
    }

}
