<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/neotag.tld" prefix="n" %>
<jsp:useBean id="n" class="neo.velocity.common.NeoContext" scope="session"/>
<n:check value="${param.crud_type}" minLength="3" maxLength="200" type="string" exp="[0-9a-zA-Z_/.]+">Tham số không chính xác, vui lòng kiểm tra lại!</n:check>
<html>

<%@include file="header.jsp"%>
<!--value="${sessionScope.lang}" -->
<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
  <!-- Content Header (Page header) -->
  <section class="main content-header" style="width: 91%; float: right;">
    <h1>
      ${n.i18n(param.crud_type)}
    </h1>
  </section>
  <section class="main content" style="width: 91%; float: right;">
    <div class="row">
      <div class="col-md-12">
        <!-- Block buttons -->
        <div class="box box-primary">
          <div class="box-body no-padding">
            <n:velocity>
            #parse ("${param.crud_type}")
          </n:velocity>
        </div><!-- /.box-body -->
      </div><!-- /.box -->
    </div><!-- /.col -->            
  </div><!-- /. row -->
</section>
</div><!-- /.content-wrapper -->
</div><!-- ./wrapper -->
<%@include file="footer.jsp"%> 