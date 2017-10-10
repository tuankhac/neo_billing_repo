<!DOCTYPE html>
<%@page import="java.io.OutputStream,java.io.InputStream"%>
<%@page import="java.util.List"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.IOException"%>
<%@page import="org.apache.commons.io.IOUtils"%>
<%!
	String path_app_1 = "D:/_app/billing/company";
	String path_app_2 = "D:/_app/billing/voice";
	String path_app_3 = "D:/_app/billing/data_rating";
	
%>
<html>
   <head>
      <script src="/assets/bootstrap/plugins/jQuery/jQuery-2.1.4.min.js"></script>
      <script type="text/javascript">
         jQuery(document).ready(function()
         {
			var d = new Date();
			d = d.getTime();
			if (jQuery('#reloadValue').val().length == 0){
					jQuery('#reloadValue').val(d);
					jQuery('body').show();
			}
			else{
					jQuery('#reloadValue').val('');
					location.reload();
			}
         });
      </script>
      <style>
         .switch {
         margin-top:9px;
         position: relative;
         display: inline-block;
         width: 80px;
         height: 44px;
         }
         .switch input {display:none;}
         .slider {
         position: absolute;
         cursor: pointer;
         top: 0;
         left: 0;
         right: 0;
         bottom: 0;
         background-color: #ccc;
         -webkit-transition: .4s;
         transition: .4s;
         }
         .slider:before {
         position: absolute;
         content: "";
         height: 36px;
         width: 36px;
         left: 4px;
         bottom: 4px;
         background-color: white;
         -webkit-transition: .4s;
         transition: .4s;
         }
         input:checked + .slider {
         background-color: #2196F3;
         }
         input:focus + .slider {
         box-shadow: 0 0 1px #2196F3;
         }
         input:checked + .slider:before {
         -webkit-transform: translateX(36px);
         -ms-transform: translateX(36px);
         transform: translateX(36px);
         }
         /* Rounded sliders */
         .slider.round {
         border-radius: 34px;
         }
         .slider.round:before {
         border-radius: 50%;
         }
         .ui-dialog-osx {
         -moz-border-radius: 0 0 8px 8px;
         -webkit-border-radius: 0 0 8px 8px;
         border-radius: 0 0 8px 8px;
         border-width: 0 8px 8px 8px;
         }
      </style>
   </head>
   <%@include file="header.jsp"%>
   <div class="content-wrapper">
   <!-- Content Header (Page header) -->
   <section class="main content-header">
      <h1>
      </h1>
   </section>
   <section class="main content" style="width: 91%; float: right;">
   <div style="display:none">
      <input id="reloadValue" type="text" name="reloadValue" value="" />
   </div>
   <div class="row">
      <div class="col-md-12">
         <div class ="box box-primary">
            <div class ="box-body padding">
               <div class="box-header with-border">
                  <h1 class="box-title">${n.i18n.start_stop_app}</h1>
                </div>
               <div class="row">
				<div class="col-md-2"></div>
                  <div class="col-md-5">
                     <div class="box-header with-border"><h1 class="box-title">${n.i18n.start_app_1}</h1></div>
                  </div>
                  <div class="col-md-4">
				  <div class="box-header with-border">
                     <%
                        String check1 = startApp("SQL Loader","/1090/API");
                         if(check1.equals("Started")){
							String html ="<label class=\"switch\"><input id= \"myAnchor1\" type=\"checkbox\" checked onclick=\"beginApp(1,'D:/_app/billing/company')\"><span class=\"slider round\"></span></label>";
							out.println(html);
                         }else{
							String html ="<label class=\"switch\"><input id= \"myAnchor1\" type=\"checkbox\" onclick=\"beginApp(1,'D:/_app/billing/company')\"><span class=\"slider round\"></span></label>";
							out.println(html);
                         }
                        %>
					</div>
                  </div>
               </div>
               <br>
               <div class="row">
			   <div class="col-md-2"></div>
                  <div class="col-md-5">
                     <div class="box-header with-border"><h1 class="box-title">${n.i18n.start_app_2}</h1></div>
                  </div>
                  <div class="col-md-4">
					<div class="box-header with-border">
                     <%
                        String check2 = startApp("CDR Voice","/1090/API");
                        if(check2.equals("Started")){
							String html ="<label class=\"switch\"><input id= \"myAnchor2\" type=\"checkbox\" checked onclick=\"beginApp(2,'D:/_app/billing/voice')\"><span class=\"slider round\"></span></label>";
							out.println(html);
                         }else{
							String html ="<label class=\"switch\"><input id= \"myAnchor2\" type=\"checkbox\" onclick=\"beginApp(2,'D:/_app/billing/voice')\"><span class=\"slider round\"></span></label>";
							out.println(html);
                         }
                        %>
					</div>
                  </div>
               </div>
               <br>
               <div class="row">
			   <div class="col-md-2"></div>
                  <div class="col-md-5">
                     <div class="box-header with-border"><h1 class="box-title">${n.i18n.start_app_3}</h1></div>
                  </div>
                  <div class="col-md-4">
				  <div class="box-header with-border">
                     <%
                        String check3 = startApp("CDR Data","/1090/API");
                         if(check3.equals("Started")){
							String html ="<label class=\"switch\"><input id= \"myAnchor3\" type=\"checkbox\" checked onclick=\"beginApp(3,'D:/_app/billing/data_rating')\"><span class=\"slider round\"></span></label>";
							out.println(html);
                         }else{
							String html ="<label class=\"switch\"><input id= \"myAnchor3\" type=\"checkbox\" onclick=\"beginApp(3,'D:/_app/billing/data_rating')\"><span class=\"slider round\"></span></label>";
							out.println(html);
                         }
                        %>
					</div>
                  </div>
               </div>
               </br></br></br>
            </div>
         </div>
      </div>
   </div>
<%@include file="footer.jsp"%> 
<script src = "/assets/bootstrap/js/jquery-ui.min.js"></script>
<script>
	function beginApp(idApp,pathApp){
   event.preventDefault();
   $('<div></div>').appendTo('body')
   .html('<div><h3>${n.i18n.crud_confirm_message}</h3></div>')
   .dialog({
     modal: true,
     title: 'Message',
     zIndex: 10002,
     autoOpen: true,
     width: '30%',
     resizable: false,
     
     buttons: {
       Yes: function () {
         if($("#myAnchor"+idApp).is(':checked')){
          $.ajax({
           url: 'deploy_app/stop.jsp?path='+pathApp,
           success: function(data){ 
				if(data.indexOf("STOPPED")){
					$("#myAnchor"+idApp).prop( "checked", false );
					alert("Bạn đã tắt ứng dụng");
				}
           }
         });
        }
        else{
          $.ajax({
           url: 'deploy_app/start.jsp?path='+pathApp,
           success: function(data){ 
				if(data.indexOf("RUNNING")){
					$("#myAnchor"+idApp).prop( "checked", true );
					alert("Bạn đã bật ứng dụng");
				}
           }
         });
        }
        $(this).dialog("close");
      },
      No: function () {
        $(this).dialog("close");
      }
    },
    close: function (event, ui) {
      $(this).remove();
    }
  });
}
</script>
<%!
	String startApp(String titleWindow,String pathLinux){
		  Process p;
		  String os_name =System.getProperty("os.name");
		  String pidInfo = "";
		  String line;
		  //nhan dien he dieu hanh
		  if(os_name.toUpperCase().contains("WINDOW")){
			  try {
			  p = Runtime.getRuntime().exec(System.getenv("windir") + "\\system32\\" + "tasklist /FI \"windowtitle eq "+titleWindow+"\"");
			  BufferedReader input = new BufferedReader(new InputStreamReader(p.getInputStream()));

			  while ((line = input.readLine()) != null) {
				  pidInfo += line;
				}
				input.close();
			  } catch (IOException e) {
					e.printStackTrace();
			  }
			  if(pidInfo.contains("Image")){
				return "Started";
			 }
		 }
		 //neu la 1 ho cua Linux
		 if(os_name.toUpperCase().contains("LINUX")){
			try {
				String []id;
				Process p1 = Runtime.getRuntime().exec(new String[] { "ps", "-ef"});
				InputStream input = p1.getInputStream();
				Process p2 = Runtime.getRuntime().exec(new String[] { "grep", "java"});
				OutputStream output = p2.getOutputStream();
				IOUtils.copy(input, output);
				output.close(); // signals grep to finish
				List<String> result = IOUtils.readLines(p2.getInputStream());
				for(int i =0; i < result.size(); i++){
					id = result.get(i).split(" ");
					
					p1 = Runtime.getRuntime().exec(new String[] { "pwdx",id[6]});
					input = p1.getInputStream();
					List<String> resultID = IOUtils.readLines(input);
					
					//kiem tra duong dan cua tien trinh mong muon check
					if(resultID.get(0).contains(pathLinux)){
						return "Started";
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		 }
		 return "NoStart";
	}
%>
</html>