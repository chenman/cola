<%
    /**
     * @title 绩效互评
     * @Description: 
     * @author 
     * @version 1.0.0
     * @since 2014-03-24
     * @history 1.0.0 2014-03-24 created by chenm
     */
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ page import="org.cola.bonus.bean.BonusJudgeBean"%>
<%@ page import="org.cola.util.common.Function"%>
<%@ page import="org.cola.frame.ReportTr"%>
<%@ page import="com.alibaba.fastjson.JSON" %>

<%
    // 分页参数
    String start = "1";// 开始行
    String page_count = "20";// 每页条数
    String row_count = "0";// 总记录数

    // 请求Bean--参数
    Map requestMap = request.getParameterMap();
    BonusJudgeBean bean = new BonusJudgeBean();
    Function.setBeanProperty(requestMap, bean);

    // 设置属性
    ReportTr mgmt = new ReportTr();        

    if (request.getParameter("oper_type") != null && request.getParameter("oper_type").equals("ADD")) {// 添加
        Map map = mgmt.queryProcessReport("20000001", bean, start, page_count);
        if (map != null) {
        	String[] return_str = ((String) map.get("other_flag")).split("\\|");
            String result_code = return_str[0];
            String error_msg = return_str[1];
            String month_id = return_str[2];
            
            if(result_code.equals("0")){
                out.println("<script type='text/javascript' language='javaScript'>");
                out.print("alert('绩效互评创建成功！');");
                out.print("parent.setFormEnable(parent.editForm, false);");
                out.print("parent.setButtonState('NORMAL');");
                out.print("parent.document.getElementById('qry_month_id').value = '"+month_id+"';");
                out.print("parent.getSearch();");
                out.print("</script>");                     
            }else {
                out.println("<script type='text/javascript' language='javaScript'>");
                out.print("alert('绩效互评创建失败，错误信息：" + error_msg + "');");
                out.print("</script>"); 
	        }
        }
    } else if (request.getParameter("oper_type") != null && request.getParameter("oper_type").equals("DEL")) {// 删除
    	Map map = mgmt.queryProcessReport("20000001", bean, start, page_count);
        if (map != null) {
            String[] return_str = ((String) map.get("other_flag")).split("\\|");
            String result_code = return_str[0];
            String error_msg = return_str[1];
            
            if(result_code.equals("0")){
                out.println("<script type='text/javascript' language='javaScript'>");
                out.println("parent.alert('绩效互评删除成功!');");
                out.print("parent.clearForm(parent.editForm);");
                out.print("parent.setButtonState('NORMAL');");
                out.print("parent.getSearch();");
                out.println("</script>");
            }  else {
                out.println("<script type='text/javascript' language='javaScript'>");
                out.print("alert('绩效互评删除失败，错误信息："+ error_msg +"');");
                out.print("</script>"); 
            }
        }
    } else if (request.getParameter("oper_type") != null && request.getParameter("oper_type").equals("MODIFY")) {// 修改
        Map map = mgmt.queryProcessReport("20000001", bean, start, page_count);
        if (map != null) {
            String[] return_str = ((String) map.get("other_flag")).split("\\|");
            String result_code = return_str[0];
            String error_msg = return_str[1];
            String month_id = return_str[2];
            
            if(result_code.equals("0")){
                out.println("<script type='text/javascript' language='javaScript'>");
                out.println("parent.alert('绩效互评修改成功!');");  
                out.print("parent.setFormEnable(parent.editForm, false);");
                out.print("parent.setButtonState('NORMAL');");
                out.print("parent.document.getElementById('qry_month_id').value = '"+month_id+"';");
                out.print("parent.getSearch();");
                out.println("</script>");
            } else {
                out.println("<script type='text/javascript' language='javaScript'>");
                out.print("alert('绩效互评修改失败，错误信息："+ error_msg +"');");
                out.print("</script>");             	
            }
        }
    }  else if (request.getParameter("oper_type") != null && request.getParameter("oper_type").equals("QUERY_STAFF")) {// 修改
        Map map = mgmt.queryProcessReport("20000001", bean, start, page_count);
        if (map != null) {
            List rowList = (List) map.get("rowList");
    		
    		if ((rowList != null) && (rowList.size() > 0)) {
    			String rs = JSON.toJSONString(rowList);
                response.setContentType("text/plain");
    			out.print(rs);
    		}
        }
    } 
%>
