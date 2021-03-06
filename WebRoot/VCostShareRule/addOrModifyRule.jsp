<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage=""%>
<!-- 引入类 -->
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.wuyg.common.util.StringUtil"%>
<%@page import="com.inspur.common.dictionary.util.DictionaryUtil"%>
<%@page import="com.hz.dict.service.DictionaryService"%>
<%@page import="com.hz.dict.service.IDictionaryService"%>
<%@page import="com.chengben.obj.VCostShareRuleObj"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.inspur.common.dictionary.pojo.DictItem"%>
<%@page import="com.wuyg.common.util.TimeUtil"%>
<!-- 基本信息 -->
<%
	// 上下文路径 
	String contextPath = request.getContextPath();

	// 对象实例 
	VCostShareRuleObj domainInstance = new VCostShareRuleObj();
	// 该功能基本路径 
	String basePath = domainInstance.getBasePath();

	// 如果是修改，则获取对象信息 
	List<VCostShareRuleObj> ruleList = new ArrayList<VCostShareRuleObj>();
	Object ruleListObj = request.getAttribute("ruleList");
	if (ruleListObj != null)
	{
		ruleList = (List<VCostShareRuleObj>) ruleListObj;
	}

	// 是否是修改 
	boolean isModify = ruleList.size() > 0;
	
	// 所有类别
	String[] departmetTypes = new String[]{VCostShareRuleObj.DEPARTMENT_TYPE_LINCHUANG,VCostShareRuleObj.DEPARTMENT_TYPE_YIJI,VCostShareRuleObj.DEPARTMENT_TYPE_FUZHU};// 临床类、医技类、辅助类
	
	// 月份，今年+去年
	Calendar cal=Calendar.getInstance();
	int year = cal.get(cal.YEAR);
	
	List<DictItem> date_month_list = new ArrayList<DictItem>();
	for(int y=year-1;y<=year;y++)
	{
		for(int i=1; i<=12; i++)
		{
			DictItem item = new DictItem();
			item.setK(y+"-"+(i<10?"0":"")+i);
			item.setV(item.getK());
			date_month_list.add(item);
		}
	}
	
	String date_month = StringUtil.getNotEmptyStr(request.getAttribute("date_month"));
	
	String date_month_current = TimeUtil.nowTime2str("yyyy-MM");
%>
<html>
	<head>
		<base target="_self" />
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title><%=isModify ? "修改" + domainInstance.getCnName() : "增加" + domainInstance.getCnName()%></title>
		<link href="../css/global.css" rel="stylesheet" type="text/css">
		<link href="../css/table.css" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="../js/jquery-2.0.3.min.js"></script>
		<script type="text/javascript" src="../js/utils.js"></script>
		<script type="text/javascript" src="../My97DatePicker/WdatePicker.js"></script>
		<script type="text/javascript" src="../js/css-1.7.0.min.js"></script>
		<script> 
		
		/**
		 ** 加法函数，用来得到精确的加法结果
		 ** 说明：javascript的加法结果会有误差，在两个浮点数相加的时候会比较明显。这个函数返回较为精确的加法结果。
		 ** 调用：accAdd(arg1,arg2)
		 ** 返回值：arg1加上arg2的精确结果
		 **/
		function accAdd(arg1, arg2) {
		    var r1, r2, m, c;
		    try {
		        r1 = arg1.toString().split(".")[1].length;
		    }
		    catch (e) {
		        r1 = 0;
		    }
		    try {
		        r2 = arg2.toString().split(".")[1].length;
		    }
		    catch (e) {
		        r2 = 0;
		    }
		    c = Math.abs(r1 - r2);
		    m = Math.pow(10, Math.max(r1, r2));
		    if (c > 0) {
		        var cm = Math.pow(10, c);
		        if (r1 > r2) {
		            arg1 = Number(arg1.toString().replace(".", ""));
		            arg2 = Number(arg2.toString().replace(".", "")) * cm;
		        } else {
		            arg1 = Number(arg1.toString().replace(".", "")) * cm;
		            arg2 = Number(arg2.toString().replace(".", ""));
		        }
		    } else {
		        arg1 = Number(arg1.toString().replace(".", ""));
		        arg2 = Number(arg2.toString().replace(".", ""));
		    }
		    return (arg1 + arg2) / m;
		}
		
		//给Number类型增加一个add方法，调用起来更加方便。
		Number.prototype.add = function (arg) {
		    return accAdd(arg, this);
		};

		//  新增或修改 
		function addOrModify() 
		{	 
			// 做必要的检查
			<%
			for(int i=1; i<=3; i++)
			{
			%> 			

				if(Number($("#level<%=i%>_total").text())!=100)
				{
					alert("<%=i%>级分摊合计不等于100%，不能保存。");
					return false;
				} 

				
			<%}%>
					
			$("#addOrModifyForm").submit(); 
		} 
		</script>
	</head>
	<body>
		<form name="addOrModifyForm" id="addOrModifyForm" action="<%=contextPath%>/<%=basePath%>/Servlet" method="post">
			<input type="hidden" id="method" name="method" value="addOrModify4this">
			<!-- 表格标题 -->
			<table width="800" align="center" class="title_table">
				<tr>
					<td>
						<img src="../images/svg/heavy/green/list.png" width="18" height="18" align="absmiddle">
						&nbsp;&nbsp;<%=isModify ? "修改" : "增加"%><%=domainInstance.getCnName()%>
					</td>
				</tr>
			</table>
		
			<!-- 查询条件 -->
			<table class="search_table" align="center" width="800">
				<tr>
					<td>
					月份
					<%=DictionaryUtil.getSelectHtml(date_month_list, "date_month", "", date_month, "notEmpty")%> 
					&nbsp;
					<input name="searchButton" type="button" class="button button_search" value="查询" onClick="searchShareRule()">
					</td> 
					<td style="text-align:right">
					
					将当前规则复制到<%=DictionaryUtil.getSelectHtml(date_month_list, "dest_date_month", "", date_month, "notEmpty")%>
					<input type="button" class="green_button" value="确认复制" onclick="copyShareRule()">
					
					</td>
				</tr>
			</table>
			<!-- 保存成功提示信息 -->
			<%if("true".equalsIgnoreCase(request.getAttribute("needRefresh")+"")){ %>
			<div align="center"><font color="#ff6600">分摊规则保存成功</font></div>
			<%} %>
			<!-- 详细信息 -->
			<table class="table report_table table-bordered" align="center" width="800">
				<thead>
					<tr>
						<th colspan="6">成本分摊规则<br><font color="#ff9900"><%=date_month %></font></th>
					</tr>
					<tr>
						<th><%=domainInstance.getPropertyCnName("department_type")%></th>
						<th><%=domainInstance.getPropertyCnName("department_code")%></th>
						<th><%=domainInstance.getPropertyCnName("department_name")%></th>
						<th><%=domainInstance.getPropertyCnName("share_rate_level_1")%></th>
						<th><%=domainInstance.getPropertyCnName("share_rate_level_2")%></th>
						<th><%=domainInstance.getPropertyCnName("share_rate_level_3")%></th>
						<!-- 
						<th><%=domainInstance.getPropertyCnName("income")%></th>
						<th><%=domainInstance.getPropertyCnName("cost_per_bed")%></th>
						<th><%=domainInstance.getPropertyCnName("cost_per_treat")%></th>
						 -->
					</tr>
				</thead>
				<%
					double level1SubTotal = 0, level2SubTotal = 0, level3SubTotal = 0;
					double level1Total = 0, level2Total = 0, level3Total = 0;

					for (int i = 0; i < ruleList.size(); i++)
					{
						VCostShareRuleObj o = (VCostShareRuleObj) ruleList.get(i);

						level1SubTotal += o.getShare_rate_level_1();
						level2SubTotal += o.getShare_rate_level_2();
						level3SubTotal += o.getShare_rate_level_3();

						level1Total += o.getShare_rate_level_1();
						level2Total += o.getShare_rate_level_2();
						level3Total += o.getShare_rate_level_3();

						// 是否最后一行
						boolean last = (i == ruleList.size() - 1);

						// 部门类型改变
						VCostShareRuleObj nextO = null;
						if (!last)
						{
							nextO = ruleList.get(i + 1);
						}
						boolean change = last || (nextO != null && !nextO.getDepartment_type_code().equals(o.getDepartment_type_code()));
				%>
				<tr>
					<td><%=new DictionaryService().getDictValueByDictKey("科室类别字典",StringUtil.getNotEmptyStr(o.getDepartment_type_code())) %><input type="hidden" name="department_type" value="<%=o.getDepartment_type_code()%>">
					</td>
					<td><%=StringUtil.getNotEmptyStr(o.getDepartment_code())%><input type="hidden" name="department_code" value="<%=o.getDepartment_code()%>">
					</td>
					<td><%=StringUtil.getNotEmptyStr(o.getDepartment_name())%><input type="hidden" name="department_name" value="<%=o.getDepartment_name()%>">
					</td>
					<td style="text-align: right">
						<input class="<%=o.getDepartment_type_code() + "_level1"%>" name="share_rate_level1" type="text" size="6" style="text-align: right; padding: 6px 0px" value="<%=StringUtil.formatDouble(o.getShare_rate_level_1(),2)%>" />
					</td>
					<td style="text-align: right">
						<input class="<%=o.getDepartment_type_code() + "_level2"%>" name="share_rate_level2" type="<%=o.isLevel2()?"text":"hidden"%>" size="6" style="text-align: right; padding: 6px 0px" value="<%=StringUtil.formatDouble(o.getShare_rate_level_2(),2)%>">
					</td>
					<td style="text-align: right">
						<input class="<%=o.getDepartment_type_code() + "_level3"%>" name="share_rate_level3" type="<%=o.isLevel3()?"text":"hidden"%>" size="6" style="text-align: right; padding: 6px 0px" value="<%=StringUtil.formatDouble(o.getShare_rate_level_3(),2)%>">
					</td>
					<!-- 
					<td style="text-align: right">
						<input name="income" type="<%=o.isLevel3()?"text":"hidden"%>" size="6" style="text-align: right; padding: 6px 0px" value="<%=StringUtil.getNotEmptyStr(o.getIncome())%>">
					</td>
					<td style="text-align: right">
						<input name="cost_per_bed" type="<%=o.isLevel3()?"text":"hidden"%>" size="6" style="text-align: right; padding: 6px 0px" value="<%=StringUtil.getNotEmptyStr(o.getCost_per_bed())%>">
					</td>
					<td style="text-align: right">
						<input name="cost_per_treat" type="<%=o.isLevel3()?"text":"hidden"%>" size="6" style="text-align: right; padding: 6px 0px" value="<%=StringUtil.getNotEmptyStr(o.getCost_per_treat())%>">
					</td>
					 -->
				</tr>
				<%
					if (change)
						{
				%>
				<tr style="color: blue; text-align: right">
					<td colspan="3"><%=new DictionaryService().getDictValueByDictKey("科室类别字典",StringUtil.getNotEmptyStr(o.getDepartment_type_code())) %>小计:
					</td>
					<td id="<%=o.getDepartment_type_code() + "_level1_subtotal"%>"><%=StringUtil.formatDouble(level1SubTotal,2)%></td>
					<td id="<%=o.getDepartment_type_code() + "_level2_subtotal"%>">
						<%
							if (o.isLevel2())
									{
						%><%=StringUtil.formatDouble(level2SubTotal,2)%>
						<%
							}
						%>
					</td>
					<td id="<%=o.getDepartment_type_code() + "_level3_subtotal"%>">
						<%
							if (o.isLevel3())
									{
						%><%=StringUtil.formatDouble(level3SubTotal,2)%>
						<%
							}
						%>
					</td>
					<!-- 
					<td></td>
					<td></td>
					<td></td>
					 -->
				</tr>
				<%
							level1SubTotal = 0;
							level2SubTotal = 0;
							level3SubTotal = 0;
						}
				%>
				<%
					}
				%>
				<tr style="color: green; text-align: right">
					<td colspan="3">
						合计:
					</td>
					<td id="level1_total"><%=StringUtil.formatDouble(level1Total,2)%></td>
					<td id="level2_total"><%=StringUtil.formatDouble(level2Total,2)%></td>
					<td id="level3_total"><%=StringUtil.formatDouble(level3Total,2)%></td>
					<!-- 
					<td></td>
					<td></td>
					<td></td>
					 -->
				</tr>
			</table>

			<!-- 工具栏 -->
			<table align="center" width="100%" class="toolbar_table">
				<tr>
					<td>
					<input name="saveButton" type="button" class="button button_save" value="保存" title="保存" onClick="addOrModify()">
					</td>
				</tr>
			</table>

		</form>
		<script type="text/javascript">
		var sum = 0.00;
		<%
			for(int n=1; n<=3 ; n++)
			{
				for(int i=0; i<departmetTypes.length ; i++)
				{
					String departmentType = departmetTypes[i];
		%>
			// 一级分摊小计合计
			$(".<%=departmentType%>_level<%=n%>").change(function(){
					$(".<%=departmentType%>_level<%=n%>").each(function(){
						//sum = Math.round((sum + Number($(this).val()))*100)/100;
						sum=sum.add(Number($(this).val()));
						});
					//更新小计
					$("#<%=departmentType%>_level<%=n%>_subtotal").text(sum);
					sum = 0;
					
					//更新合计
					<%
						for(int j=0; j<departmetTypes.length ; j++)
						{
							departmentType = departmetTypes[j];
					%>
					//sum += Math.round(Number($("#<%=departmentType%>_level<%=n%>_subtotal").text()*100)/100);
					sum=sum.add(Number($("#<%=departmentType%>_level<%=n%>_subtotal").text()));
					<%}%>
					if(sum>100)
					{
						alert("<%=n%>级分摊合计超过100了")
						$("#level<%=n%>_total").css("color","red");
					}
					else
					{
						$("#level<%=n%>_total").css("color","green");
					}
					$("#level<%=n%>_total").text(sum);
					sum = 0;
			});
			
		<%
			}
		}
		%>
		
		
		// 绑定enter事件
			$('body').keydown(function(){
			   if(event.keyCode == 13)
			   {
				 event.keyCode = 9;
			   }
			});
			

		
		// 重新查询
		function searchShareRule(){
			$("#addOrModifyForm").attr("action","<%=contextPath%>/<%=basePath%>/Servlet?method=preModify4this");
			$("#addOrModifyForm").submit();
		}
		
		
		// 复制规则
		function copyShareRule()
		{
			var date_month=$("#date_month").val();;
			var dest_date_month=$("#dest_date_month").val();
			
			if(date_month==dest_date_month)
			{
				alert("同一个月份之间不能互相复制，请重新选择需要复制到哪个月份。");
				return false;
			}
			
			$("#addOrModifyForm").attr("action","<%=contextPath%>/<%=basePath%>/Servlet?method=copyShareRule");
			$("#addOrModifyForm").submit();
		}
		</script>
	</body>
</html>
