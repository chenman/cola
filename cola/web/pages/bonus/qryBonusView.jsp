<%@ page language="java" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ page import="org.cola.bean.UserInfoBean"%>
<%
    String path = request.getContextPath();
    UserInfoBean userInfo = (UserInfoBean) session.getAttribute("userInfoBean");
    if (userInfo == null) {
        response.sendRedirect("login.jsf");
        return;
    }
    String userId = userInfo.getUserId();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>互评查询</title>
<link href="<%=path%>/css/css.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="<%=path%>/js/jquery.min.js"></script>
<script type="text/javascript" src="<%=path%>/js/page.js"></script>
<script type="text/javascript" src="<%=path%>/js/common.js"></script>
<script type="text/javascript" src="<%=path%>/js/commonFunc.js"></script>
<script type="text/javascript" src="<%=path%>/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="<%=path%>/js/dateUtil.js"></script>
<script type="text/javascript">
String.prototype.trim = function(){return this.replace(/(^\s*)|(\s*$)/g, "");};

function pageLoad(){    
}

//查询
function getSearch() {
    searchSubmit.oper_type.value = "QUERY";
    reportProcessSearch('searchSubmit', 'qryBonusIframe.jsf', "<%=path%>", 'isQueryOk');
}

//导出
function exportOut() {
    searchSubmit.oper_type.value = "QUERY";
    exportExcel('searchSubmit', 'qryBonusIframe.jsf?1=1', "<%=path%>", 'isExportQryOk');
}

function openArea(that,closTip,showTip,controllName){
    if(that.title==showTip){
      that.title=closTip;
      that.src="<%=path%>/images/up.gif";
      document.all(controllName).style.display="block";
    }else{
      that.title=showTip;
      that.src="<%=path%>/images/down.gif";
      document.all(controllName).style.display="none";
    }
}

</script>
</head>
<body onLoad="pageLoad();">
    <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
        <form target="InfoPage" id="searchSubmit" name="searchSubmit"
            method="post">
            <input type="hidden" id="start" name="start" value="0" /> 
            <input type="hidden" id="rownum" name="rownum" value="" /> 
            <input type="hidden" id="PageCount" name="PageCount" value="20" /> 
            <input type="hidden" id="endrow" name="endrow" value="" /> 
            <input type="hidden" id="totalnum" name="totalnum" value="" /> 
            <input type="hidden" id="issubmit" name="issubmit" value="" /> 
            <input type="hidden" id="oper_type" name="oper_type" value="" /> 
            <input type="hidden" id="ISSEARCH" name="ISSEARCH" value="ISSEARCH" />
            <tr id="InfoPageSearch">
                <td height="50px" class="down_bg8"><table width="100%"
                        border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td width="13%" align="right">月份:</td>
                            <td width="20%" align="left"><input
                                id="qry_month_id" name="qry_month_id" value=""
                                style="width: 150px" readonly="true"
                                onClick="WdatePicker({dateFmt:'yyyyMM',maxDate:'%y-%M'})"></input>
                            </td>
                            <td align="left"><input type="button"
                                id="search" value="查 询" class="td_Input"
                                style="cursor: hand; width: 50px"
                                onClick="getSearch();" /> <input type="button"
                                id="search2" value="导 出" class="td_Input"
                                style="cursor: hand; width: 50px"
                                onClick="exportOut();" /></td>
                        </tr>
                    </table></td>
            </tr>
            <tr>
                <td height="10px"><table width="100%" border="0"
                        cellspacing="0" cellpadding="0">
                        <tr>
                            <td height="10px"
                                background="<%=path%>/images/line_bg.gif"><table
                                    width="65px" border="0" align="center"
                                    cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td><a href="#"><img
                                                id="InfoPageImg"
                                                src="<%=path%>/images/line_up.gif"
                                                style="cursor: hand;"
                                                onClick="hideSearch('InfoPageSearch');"
                                                alt="收缩" border="0" /> </a></td>
                                    </tr>
                                </table></td>
                        </tr>
                    </table></td>
            </tr>
            <tr>
                <td valign="top"><table width="100%" height="100%"
                        border="0" cellspacing="0" cellpadding="0">
                        <%
                            /*** WEB开发 beginning ***/
                            String iframPage = "qryBonusIframe.jsf";
                            String selectedPage = "";
                            String columnInfoPage = "";
                            /*** WEB开发 endding ***/
                        %>
                        <%@include file="/common/reportListDiv.jsp"%>
                    </table></td>
            </tr>
        </form>
        <iframe src="" width="0" height="0" frameborder="0"
            name="excelExportIframe"></iframe>
    </table>
</body>
</html>