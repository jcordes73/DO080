package com.redhat.training.model;

import java.net.InetAddress;

public class Host {

	private String ip;
	private String hostname;
	
	public Host(InetAddress ip, String hostname) {
		this.ip = ip.toString();
		this.hostname = hostname;
	}

	public String getIp() {
		return ip;
	}

	public String getHostname() {
		return hostname;
	}
	
}
