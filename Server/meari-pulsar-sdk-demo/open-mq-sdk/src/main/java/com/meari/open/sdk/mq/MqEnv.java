
package com.meari.open.sdk.mq;

public enum MqEnv {
	PROD("prod", "event", "online environment"),
	TEST("test", "event-test", "test environment");

	private String	key;

	private String	value;

	private String	description;

	MqEnv(String key, String value, String description) {
		this.key = key;
		this.value = value;
		this.description = description;
	}

	public String getKey() {
		return key;
	}

	public String getValue() {
		return value;
	}

	public String getDescription() {
		return description;
	}
}
