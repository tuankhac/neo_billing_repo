<%@ page import="java.io.File"%><%@page import="java.io.BufferedReader"%><%@page import="java.io.InputStreamReader"%><%@page import="java.io.IOException,java.lang.management.ManagementFactory"%><%@page import="org.apache.commons.io.IOUtils"%>
<%	String path = request.getParameter("path");	String os_name =System.getProperty("os.name");
	System.out.println("Creating Process...");
	Process p = null;
	try {
		if(os_name.toUpperCase().contains("WINDOW")){
			p = Runtime.getRuntime().exec("cmd.exe /c start startup.bat", null, new File(path));
			p.waitFor();
			if(p.exitValue() == 0){
				out.println("RUNNING");
			}else{
				out.println("ERROR");
			}
		}else if(os_name.toUpperCase().contains("LINUX")){
			p = Runtime.getRuntime().exec("./startup.sh start", null, new File(path));
			p.waitFor();
			BufferedReader reader = new BufferedReader(new InputStreamReader(p.getInputStream()));
			String line = null;
			while ((line = reader.readLine()) != null){
				out.println(line);
			}
		}
	} catch (Exception ex) {
         ex.printStackTrace();
    }
	// when you manually close notepad.exe program will continue here
	System.out.println("Waiting over.");
%>