<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page import="java.security.SecureRandom"%>
<%@page import="java.util.StringTokenizer"%>
<%@page import="java.io.File,java.io.IOException,java.util.Properties,java.io.FileInputStream,java.io.InputStream"%>
<%@page import="org.apache.commons.configuration.PropertiesConfiguration"%>
<%@page import="org.apache.commons.configuration.ConfigurationException"%>
<%@page import="org.apache.commons.configuration.reloading.FileChangedReloadingStrategy"%>
<% 
	String configFile = getServletContext().getRealPath("/")+"WEB-INF/classes/csrf.properties";
	String fullPath = request.getRequestURL()+"?"+request.getQueryString();

	//doc cau hinh file
	PropertiesConfiguration props = new PropertiesConfiguration();
	File is = new File(configFile);
	if (!is.exists()) {
		throw new IOException("Could not found properties file " + is.getName());
	}
	props.setFile(is);
	props.setReloadingStrategy(new FileChangedReloadingStrategy());
	props.setAutoSave(false);
	props.load();
	String param = request.getServletPath();
	if(request.getQueryString()!= null){
		param = param + request.getQueryString();
	}
	String out_param = param.replaceAll("=","");
	//out.println("param "+param);
	//out.println("|out"+out_param);
	String value = props.getString(out_param);
	//out.println("|value"+value);
	//out.println(request.getServletPath() +"<br>"+ request.getRequestURI() + "<br>" +"<br>"+request.getContextPath());

	//neu value ton tai nghia la ton tai trong file cau hinh thi
	//tien hanh set cookie cho gia tri tuong ung
	if(value != null){
		StringTokenizer parser = new StringTokenizer(value , "|");
		String[] arr = new String[parser.countTokens()];
		int i = 0;
		while (parser.hasMoreTokens()) {
			arr[i] = parser.nextToken();
			i++;
		}
		//out.print(arr[0]+"<br>"+ arr[1]+"<br>"+ arr[2]);
		SecureRandom random = new SecureRandom();
		String val = random.nextLong()+"";
		Cookie cookies = new Cookie(arr[0],val);
		cookies.setHttpOnly(true);
		cookies.setSecure(true);
		cookies.setPath(request.getRequestURL().toString());
		cookies.setMaxAge(Integer.valueOf(arr[1]));
		response.addCookie(cookies);
		request.setAttribute(arr[2], val);
		session.setAttribute(arr[2], val);
	}
	%>