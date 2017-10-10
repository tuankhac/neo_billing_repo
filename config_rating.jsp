﻿<%@ taglib uri="/WEB-INF/neotag.tld" prefix="n" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.StringTokenizer"%>
<%@page import="java.io.File,java.io.IOException,java.util.Properties,java.io.FileInputStream,java.io.InputStream"%>
<%@page import="org.apache.commons.configuration.PropertiesConfiguration"%>
<%@page import="org.apache.commons.configuration.ConfigurationException"%>
<%@page import="org.apache.commons.configuration.reloading.FileChangedReloadingStrategy"%>
<%@ page import = "java.util.Map" %>
<%
	//lay danh sach param neu ton tai
	Map<String, String[]> parameters = request.getParameterMap();

	String pathFile ="D:/_app/billing/data_rating/conf/";
	//doc file config.properties
	String config_File = pathFile+"database.properties";
	PropertiesConfiguration prop_Config = new PropertiesConfiguration();
	File isC = new File(config_File);
	if (!isC.exists()) {
		throw new IOException("Could not found properties file " + isC.getName());
	}
	prop_Config.setFile(isC);
	prop_Config.setReloadingStrategy(new FileChangedReloadingStrategy());
	prop_Config.setAutoSave(false);
	prop_Config.load();

	Iterator<String> keys  = prop_Config.getKeys();

	//doc file log4j.properties
	String log_File = pathFile+"log4j.properties";
	PropertiesConfiguration prop_Log = new PropertiesConfiguration();
	File isL = new File(log_File);
	if (!isL.exists()) {
		throw new IOException("Could not found properties file " + isL.getName());
	}
	prop_Log.setFile(isL);
	prop_Log.setReloadingStrategy(new FileChangedReloadingStrategy());
	prop_Log.setAutoSave(false);
	prop_Log.load();
	Iterator<String> keyl  = prop_Log.getKeys();
	
	//doc file task.properties
	String task_File = pathFile+"task.properties";
	PropertiesConfiguration prop_Task = new PropertiesConfiguration();
	File isT = new File(task_File);
	if (!isT.exists()) {
		throw new IOException("Could not found properties file " + isT.getName());
	}
	prop_Task.setFile(isT);
	prop_Task.setDelimiterParsingDisabled(true) ;
	prop_Task.setReloadingStrategy(new FileChangedReloadingStrategy());
	prop_Task.setAutoSave(false);
	prop_Task.load();
	Iterator<String> keyT  = prop_Task.getKeys();

	//neu param ko null nghia la thoa man update lai
	String iden ="";
	boolean start = false;
	if(parameters != null){
		for(String parameter : parameters.keySet()) {
			if(iden.equals("")){
				iden = parameter;
				start = true;
			}
			if(iden.equals("configFile")){
				prop_Config.setProperty(parameter, parameters.get(parameter)[0]);
			}
			if(iden.equals("logFile")){
				prop_Log.setProperty(parameter, parameters.get(parameter)[0]);
			}
			if(iden.equals("taskFile")){
				prop_Task.setProperty(parameter, parameters.get(parameter)[0]);
			}
		}
		if(iden.equals("configFile")){
			prop_Config.save();
		}
		if(iden.equals("configFile")){
			prop_Log.save();
		}
		if(iden.equals("taskFile")){
			prop_Task.save();
		}
	}
%>
<html>
<%@include file="header.jsp"%>
<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
   <!-- Content Header (Page header) -->
   <section class="main content-header">
      <h1>
      </h1>
   </section>
   <section class="main content" style="width: 91%; float: right;">
      <div class="nav-tabs-custom">
         <ul class="nav nav-tabs">
            <li class="active"><a href="#tab_1" data-toggle="tab" aria-expanded="true"><b>${n.i18n.config_configure}</b></a></li>
            <li class=""><a href="#tab_2" data-toggle="tab" aria-expanded="false"><b>${n.i18n.config_log4j}</b></a></li>
			<li class=""><a href="#tab_3" data-toggle="tab" aria-expanded="false"><b>${n.i18n.config_task}</b></a></li>
         </ul>
         <div class="tab-content">
            <div class="tab-pane active" id="tab_1">
               <form action="config_rating.jsp" method="post">
                  <input hidden name="configFile"></input>
                  <table width="100%" class='table table-condensed table-striped table-bordered'>
                    <tr><th><h3>Key</h3></th><td><h3>Value</h3></td></tr>
                    <%
						while(keys.hasNext()) {
						String key = keys.next();
						if(prop_Config.getString(key).length() < 100){
							out.println("<tr><th align=center width='10%'>"+key+"</th><td align=left><input type='text' class='form-control' name='"+
								key+"' id='"+key+"' value='"+prop_Config.getString(key).replace("'","&#39;")+"'></input></td></tr>");
						}else{
							out.println("<tr><th align=center width='10%'>"+key+"</th><td align=left><textarea type='text' class='form-control' name='"+
								key+"' id='"+key+"'>"+prop_Config.getString(key).replace("'","&#39;")+"</textarea></td></tr>");
						}
					 }
					 %>
					 <tr id='control'>
					  <td colspan='2' align='center'><font id="resultC"></font>
						 <button type="submit" id="updateC" class="btn btn-primary"><i class="fa fa-edit"></i> ${n.i18n.crud_edit_button_message}</button>
					  </td>
				   </tr>
				</table>
			 </form>
		  </div>
      
      <!-- /.tab-pane -->
      
      <div class="tab-pane" id="tab_2">
         <form action="config_rating.jsp" method="post">
            <input hidden name="logFile"></input>
            <table width="100%" class='table table-condensed table-striped table-bordered'>
              <tr><th><h3>Key</h3></th><td><h3>Value</h3></td></tr>
              <%
				  while(keyl.hasNext()) {
					  String key = keyl.next();
					  if(prop_Log.getString(key).length() < 100){
						out.println("<tr><th align=center width='10%'>"+key+"</th><td align=left><input type='text' class='form-control' name='"+
							key+"' id='"+key+"' value='"+prop_Log.getString(key).replace("'","&#39;")+"'></input></td></tr>");
					  }else{
						out.println("<tr><th align=center width='10%'>"+key+"</th><td align=left><textarea type='text' class='form-control' name='"+
							key+"' id='"+key+"'>"+prop_Log.getString(key).replace("'","&#39;")+"</textarea></td></tr>");
					  }
				 }
			   %>
			   <tr id='control'>
					<td colspan='2' align='center'><font id="resultL"></font>
					   <button  type="submit" id="updateL" class="btn btn-primary"><i class="fa fa-edit"></i> ${n.i18n.crud_edit_button_message}</button>
					</td>
				 </tr>
			  </table>
		   </form>
		</div>
		
		<div class="tab-pane" id="tab_3">
         <form action="config_rating.jsp" method="post">
            <input hidden name="taskFile"></input>
            <table width="100%" class='table table-condensed table-striped table-bordered'>
              <tr><th><h3>Key</h3></th><td><h3>Value</h3></td></tr>
              <%
              		String read_only = "";
				  while(keyT.hasNext()) {
				  String key = keyT.next();
				  if(key.equals("task-id")){
				  	read_only = "readonly";
				}
				  if(prop_Task.getString(key).length() < 100){
						out.println("<tr><th align=center width='25%'>"+key+"</th><td align=left><input type='text' class='form-control' name='"+
								key+"' id='"+key+"' value='"+prop_Task.getString(key).replace("'","&#39;")+"' "+read_only+"></input></td></tr>");
				  }else{
					out.println("<tr><th align=center width='25%'>"+key+"</th><td align=left><textarea type='text' class='form-control' name='"+
							key+"' id='"+key+"'>"+prop_Task.getString(key).replace("'","&#39;")+"</textarea></td></tr>");
				  }
				  read_only = "";
			   }
			   %>
			   <tr id='control'>
				<td colspan='2' align='center'><font id="resultT"></font>
				   <button  type="submit" id="updateT" class="btn btn-primary"><i class="fa fa-edit"></i> ${n.i18n.crud_edit_button_message}</button>
				</td>
			 </tr>
		  </table>
	   </form>
	</div>
</div>
<!-- /.content-wrapper -->
</div>
<!-- ./wrapper -->
<%@include file="footer.jsp"%> 
<script>
	 var dataControl ="";
	 $('#updateC').click(function(){
		alert("${n.i18n.update_file_succes}");
		
	 });
	 $('#updateL').click(function(){
	   alert("${n.i18n.update_file_succes}");
	});
	 $('#updateT').click(function(){
	   alert("${n.i18n.update_file_succes}");
	});
	 $(document).on('change',"select",function(){
	 });
</script>