
<%
    /**
			 * @title 互评查询
			 * @Description: 
			 * @author 
			 * @version 1.0.0
			 * @since 2014-03-24
			 * @history 1.0.0 2013-06-24 created by chenm
			 */
%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ page import="org.cola.bonus.bean.BonusJudgeBean"%>
<%@ page import="org.cola.util.common.Function"%>
<%@ page import="org.cola.frame.ReportTr"%>
<%
    //请求Bean参数设置
	Map requestMap = request.getParameterMap();
	BonusJudgeBean bean = new BonusJudgeBean();
	Function.setBeanProperty(requestMap, bean);

	//分页参数
	String start = "1";//开始行
	String page_count = "20";//每页条数
	String row_count = "0";//总记录数
	if (request.getParameter("start") != null) {
		start = request.getParameter("start");
	}
	if (request.getParameter("PageCount") != null
			&& !request.getParameter("PageCount").equals("")) {
		page_count = request.getParameter("PageCount");
	}
	//初始化参数
	Map map = null;
	List rowList = null;

	////////判断是否是第一次加载，第一次加载不做查询/////////////
	String searchStr = "";
	if (request.getParameter("ISSEARCH") != null) {
		searchStr = request.getParameter("ISSEARCH");
	} else {
		searchStr = "NOSEARCH";
	}
	if (searchStr == "NOSEARCH") {

	} else {

		/////////----------导出---------//////////////////////////////////
		if (request.getParameter("isExport") != null) {
			if (request.getParameter("isExport").equals("true")) {
				ReportTr mgmt = new ReportTr();

				map = mgmt.queryExcelReport("20000001", bean, response);
				if (map.get("flag") != null
						&& "false".equals(map.get("flag"))) {
					out.println("<script>alert('导出失败！')</script>");
					return;
				}
				//下面两行代码解决 getOutputStream() has already been called 错误
				out.clear();
				out = pageContext.pushBody();
				return;
			}
		}
		/////////----------查询---------//////////////////////////////////
		ReportTr mgmt = new ReportTr();
		//有进度条的查询
		map = mgmt.queryProcessReport("20000001", bean, start,
				page_count);

		if (map != null) {
			//总纪录数
			if (map.get("record_cnt") != null) {
				row_count = map.get("record_cnt").toString();
			}
			//数据列表
			rowList = (List) map.get("rowList");
		}

	}
%>
<html>
<head>
<title></title>
<script type="text/javascript"
    src="<%=request.getContextPath()%>/js/jquery.min.js"></script>
<link href="<%=request.getContextPath()%>/css/css.css" rel="stylesheet"
    type="text/css" />
</head>
<body BGCOLOR=#FFFFFF LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0>
    <table width="100%" class="box_table" id="table_list" name="table_list"
        jheight="2" border="0" cellpadding="0" cellspacing="1" bgcolor="#CCCCCC">
        <%
            if ((rowList != null) && (rowList.size() > 0)) {
        				for (int i = 0; i < rowList.size(); i++) {
        					if (i == 0) {
        						//titleNum表示展示的标题行个数
        						int titleNum = 0;
        						List titleList = (List) rowList.get(0);
        						out.println("<tr align=\"left\" bordercolor=\"#e7f0fe\" bgcolor=\"#BDE3FF\" class=\"td-title\">");
        						for (titleNum = 0; titleNum < titleList.size(); titleNum++) {
        							out.println("<td align='left'>"
        									+ titleList.get(titleNum).toString().trim()
        									+ "</td>");
        						}
        						out.println("</tr>");
        					} else {
        						List listData = (List) rowList.get(i);
        						if (i % 2 == 0) {
        							out.print("<tr class='tr_odd'");
        						} else {
        							out.print("<tr class='tr_even'");
        						}

        						out.print("onClick=\"$('#table_list').find('.selected').removeClass('selected');$(this).addClass('selected');\">");
        						for (int dataNum = 0; dataNum < listData.size(); dataNum++) {

        							out.println("<td align='left'>"
        									+ listData.get(dataNum).toString().trim()
        									+ "</td>");
        						}
        						out.println("</tr>");
        					}
        				}
        			}
        %>
    </table>
    <script>
                    parent.show_page(
                <%=start%>
                    ,
                <%=page_count%>
                    ,
                <%=row_count%>
                    );
                </script>
</body>