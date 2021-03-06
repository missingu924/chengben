<!DOCTYPE html> 
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage=""%> 
<!-- 引入类 --> 
<%@page import="java.util.List"%> 
<%@page import="java.util.ArrayList"%> 
<%@page import="com.wuyg.common.util.StringUtil"%> 
<%@page import="com.wuyg.common.obj.PaginationObj"%> 
<%@page import="com.inspur.common.dictionary.util.DictionaryUtil"%> 
<%@page import="com.hz.dict.service.DictionaryService"%> 
<%@page import="com.chengben.obj.DepartmentObj"%> 
<!-- 基本信息 --> 
<% 
	// 当前上下文路径 
	String contextPath = request.getContextPath(); 
 
	// 该功能对象实例 
	DepartmentObj domainInstance = (DepartmentObj) request.getAttribute("domainInstance"); 
	// 该功能路径 
	String basePath = domainInstance.getBasePath(); 
	// 同步结果信息
	Object message = request.getAttribute("message");
%> 
<html> 
	<head> 
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
		<meta name="viewport" content="width=device-width, initial-scale=1,user-scalable=no" />		<title><%=domainInstance.getCnName() %>列表</title> 
		<link href="../css/global.css" rel="stylesheet" type="text/css"> 
		<link href="../css/table.css" rel="stylesheet" type="text/css"> 
		<script type="text/javascript" src="../js/jquery-2.0.3.min.js"></script> 
		<script type="text/javascript" src="../js/utils.js"></script> 
		<script type="text/javascript" src="../My97DatePicker/WdatePicker.js"></script> 
	</head> 
	<body> 
		<form name="pageForm" id="pageForm" method="post" action="<%=request.getContextPath()%>/<%=basePath%>/Servlet?method=list4this"> 
			 
			<!-- 查询条件 --> 
			<table class="search_table" align="center" width="98%"> 
				<tr> 
					<td align="left"> 
					
						<input name="source_system" type="hidden" id="source_system" value="<%=StringUtil.getNotEmptyStr(request.getAttribute("source_system")) %>">
						<input name="list4notOk" type="hidden" id="list4notOk" value="<%=StringUtil.getNotEmptyStr(request.getAttribute("list4notOk")) %>">
						
						<%=domainInstance.getPropertyCnName("department_code") %> 
						<input name="department_code" type="text" id="department_code" value="<%=StringUtil.getNotEmptyStr(domainInstance.getDepartment_code())%>" size="20" > 
						&nbsp;  
						<%=domainInstance.getPropertyCnName("department_name") %> 
						<input name="department_name" type="text" id="department_name" value="<%=StringUtil.getNotEmptyStr(domainInstance.getDepartment_name())%>" size="20" > 
						&nbsp;  
						<%=domainInstance.getPropertyCnName("department_type_code") %> 
						<%=DictionaryUtil.getSelectHtml(new DictionaryService().getDictItemsByDictName("科室类别字典", false), "department_type_code", "", StringUtil.getNotEmptyStr(domainInstance.getDepartment_type_code(), ""), "notEmpty")%> 
						&nbsp;  
						<input name="searchButton" type="button" class="button button_search" value="查询" onClick="toPage(1)"> 
					</td> 
					<td align="right"> 
						<!-- 
						<input name="addButton" type="button" class="button button_add" value="增加" onClick="openBigModalDialog('<%=contextPath%>/<%=basePath%>/Servlet?method=preModify4this')"> 
						 -->
						<input name="uploadButton" type="button" class="button button_sync" value="同步" onClick="sync()">
						<input name="uploadButton" type="button" class="button button_set" value="批量设置" onClick="openBigModalDialog('<%=contextPath%>/<%=basePath%>/Servlet?method=preModify4Batch')">
					</td> 
				</tr> 
			</table> 
			
			<!-- 同步结果信息 -->
			<%if(!StringUtil.isEmpty(message+"")){ %>
			<div align="center"><font color="#ff6600"><%=message %></font></div>
			<%} %>
 
			<!-- 查询结果 --> 
			<% 
				PaginationObj pagination = null; 
				List list = new ArrayList(); 
 
				Object paginationObj = request.getAttribute("domainPagination"); 
				if (paginationObj != null) 
				{ 
					pagination = (PaginationObj) paginationObj; 
					list = (List) pagination.getDataList(); 
				} 
				if (paginationObj == null) 
				{ 
					out.print("没有符合条件的数据，请重新设置条件再查询。"); 
				} else 
				{ 
			%> 
			<table class="table table-bordered table-striped" align="center" width="98%"> 
				<thead> 
					<tr> 
						<th><%=domainInstance.getPropertyCnName("id") %></th> 
						<th><%=domainInstance.getPropertyCnName("department_code") %></th> 
						<th><%=domainInstance.getPropertyCnName("department_name") %></th> 
						<th><%=domainInstance.getPropertyCnName("department_type_code") %></th> 
						<th>操作</th> 
					</tr> 
				</thead> 
				<% 
					for (int i = 0; i < list.size(); i++) 
						{ 
							DepartmentObj o = (DepartmentObj) list.get(i); 
				%> 
				<tr> 
					<td> 
						<a href="#" onClick="openBigModalDialog('<%=contextPath%>/<%=basePath%>/Servlet?method=detail4this&<%=o.findKeyColumnName()%>=<%=o.getKeyValue()%>')"> <%=StringUtil.getNotEmptyStr(o.getKeyValue())%> </a> 
					</td> 
					<td><%=StringUtil.getNotEmptyStr(o.getDepartment_code())%></td> 
					<td><%=StringUtil.getNotEmptyStr(o.getDepartment_name())%></td> 
					<td><%=new DictionaryService().getDictValueByDictKey("科室类别字典",o.getDepartment_type_code())%></td>  
					<td align="left" style="cursor: pointer"> 
						<input type="button" class="button button_modify" title="修改" onClick="openBigModalDialog('<%=contextPath%>/<%=basePath%>/Servlet?method=preModify4this&<%=o.findKeyColumnName()%>=<%=o.getKeyValue()%>')" /> 
						<!-- 
						&nbsp; 
						<input type="button" class="button button_delete" title="删除" 
							onClick="javascript: 
								$('#pageForm').attr('action','<%=contextPath%>/<%=basePath%>/Servlet?method=delete4this&<%=o.findKeyColumnName()%>_4del=<%=o.getKeyValue()%>'); 
								$('#pageForm').submit(); 
								" /> 
						 -->
					</td> 
				</tr> 
				<% 
					} 
				%> 
			</table> 
 
			<!-- 翻页操作栏 --> 
			<jsp:include page="../ToolBar/pagination_toolbar.jsp"> 
				<jsp:param name="basePath" value="<%=basePath%>"/> 
			</jsp:include> 
 
			<% 
				} 
			%> 
		</form>  
 	<script type="text/javascript">
 	function sync()
 	{
 		$('#pageForm').attr('action','<%=contextPath%>/<%=basePath%>/Servlet?method=sync'); 
		$('#pageForm').submit(); 
 	}
 	</script>
	</body> 
</html> 
