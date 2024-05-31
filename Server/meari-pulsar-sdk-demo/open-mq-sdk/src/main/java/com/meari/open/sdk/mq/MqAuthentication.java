
package com.meari.open.sdk.mq;

import org.apache.pulsar.client.api.Authentication;
import org.apache.pulsar.client.api.PulsarClientException;

import java.io.IOException;
import java.util.Map;

public class MqAuthentication implements Authentication {

	private String	accessId;

	private String	accessKey;

	public MqAuthentication(String accessId, String accessKey) {
		this.accessId = accessId;
		this.accessKey = accessKey;
	}

	@Override
	public String getAuthMethodName() {
		return "auth1";
	}

	@Override
	public org.apache.pulsar.client.api.AuthenticationDataProvider getAuthData() throws PulsarClientException {
		return new MqAuthenticationDataProvider(this.accessId, this.accessKey);
	}

	@Override
	public void configure(Map<String, String> map) {
	}

	@Override
	public void start() throws PulsarClientException {
	}

	@Override
	public void close() throws IOException {
	}
}
