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
<title>绩效互评</title>
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
    setButtonState('NORMAL');
    setFormEnable(editForm, false);
    
    var param = {
		oper_type : "QUERY_STAFF"
	};
	$.post("cfgBonusAction.jsf", param,
		function(rs) {
// 	    	alert(rs);
			var data = eval(rs);
			$('#edit_staff_id option').remove();
			appendOption('-1', '--请选择--');
			$(data).each(function (key) {
			    appendOption(data[key][0], data[key][1]);
			});
		});
}

function appendOption(value, text) {
	$("#edit_staff_id").append("<option value='" + value + "'>"+ text + "</option>");
}
    
//查询
function getSearch() {
    searchSubmit.oper_type.value = "QUERY";
    setButtonState('NORMAL');
    setFormEnable(editForm, false);
    reportProcessSearch('searchSubmit', 'cfgBonusIframe.jsf', "<%=path%>", 'isQueryOk');
}

//导出
function exportOut() {
    searchSubmit.oper_type.value = "QUERY";
    setButtonState('NORMAL');
    setFormEnable(editForm, false);
    exportExcel('searchSubmit', 'cfgBonusIframe.jsf?1=1', "<%=path%>", 'isExportQryOk');
}

//设置按键状态
function setButtonState(sState) {
    var btnAdd = document.getElementById("add");
    var btnEdit = document.getElementById("edit");
    var btnDel = document.getElementById("del");
    var btnSave = document.getElementById("save");
    var btnCancel = document.getElementById("cancel");
    
    if ((sState=='EDIT') || (sState=='ADD')) { 
        btnAdd.disabled = true;
        btnEdit.disabled = true;
        btnDel.disabled = true;
        btnSave.disabled = false;
        btnCancel.disabled = false; 
    } else if (sState == 'NORMAL') { //正常
        btnAdd.disabled = false;
        btnEdit.disabled = true;
        btnDel.disabled = true;
        btnSave.disabled = true;
        btnCancel.disabled = true;
    } else if (sState == 'CANDEL') { //正常
        btnAdd.disabled = false;
        btnEdit.disabled = false;
        btnDel.disabled = false;
        btnSave.disabled = true;
        btnCancel.disabled = true;
    }
}

//表单状态设置
function setFormEnable(formObj,Benable) {
    try {
        if (Benable) {
            setFormEditEnable(formObj, true);
        } else {
            setFormEditEnable(formObj, false);
        }
    } catch(ex) {
        alert("setFormEnable " + ex.description); //弹出错误信息
    }
}

function setFormEditEnable(formObj, bEnable) {
    try {
        //逐个循环检测FORM对象中的无素;
        for (var i = 0; i < formObj.elements.length; i++) {
            setEditEnable(formObj.elements[i], bEnable);
        }
    }
    catch(ex) {
        alert(ex.description); //弹出错误信息
    }
}

function setEditEnable(edtObj, bEnable) {
    try {
        var Obj = edtObj;
        if (Obj.tagName.toUpperCase() == "INPUT" //控件名称为INPUT的;
        &&
        //类型为下面几种的;
        (Obj.type.toUpperCase() == "BUTTON" || Obj.type.toUpperCase() == "SUBMIT" || Obj.type.toUpperCase() == "RESET" || Obj.type.toUpperCase() == "HIDDEN")) {
            return;
        }else {
            setInputEnable(Obj, bEnable);
        }
    }catch(ex) {
        alert(ex.description); //弹出错误信息
    }
}

//设定某个编辑框是否可读；
function setInputEnable(inputObj, bEnable) {
    //如果不是按钮类的话;
    inputObj.disabled = !(bEnable);
    if (bEnable) {
        //设为不只读
        inputObj.style.backgroundColor = "#FFFFFF";
    }else {
        //设为只读
        inputObj.style.backgroundColor = "#EEEEEE";
    }
}

//清空表单
function clearForm(formObj) {
    for (var i = 0; i < formObj.elements.length; i++) {
        var Obj = formObj.elements[i];
        if (Obj.tagName.toUpperCase() == "INPUT" &&(Obj.type.toUpperCase() == "TEXT" || Obj.type.toUpperCase() == "HIDDEN")) {
            Obj.value = "";
        }else if (Obj.tagName.toUpperCase() == "TEXTAREA") {
            Obj.value = "";
        }
    }

    document.getElementById("edit_staff_id").value = -1;
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

var operType = "";
//增加
function addContent() {
    //设置操作类型 
    //editForm.oper_type.value = "ADD";
    operType  = "ADD";
    //设置编辑区按钮状态
    setButtonState('ADD');
    
    //设置编辑框为可写
    setFormEnable(editForm, true);  
    document.getElementById("edit_staff_id").disabled=false;
    //清空编辑区文本框中的内容
    clearForm(editForm);
    var now = new Date();
    var year = now.getFullYear();
    var month = now.getMonth();
    
    if (month == 0) {
        year--;
        month = 11;
    } else {
        month--;
    }
    
    var last_month = new Date(year, month);
    document.getElementById("edit_month_id").value = last_month.Format('YYYYMM');
    document.getElementById("edit_month_id").readOnly=true;
}

//修改
function editContent() {
    operType  = "MODIFY";
    setFormEnable(editForm, true);
    document.getElementById("edit_month_id").readOnly=true;
    document.getElementById("edit_staff_id").disabled=true;
    setButtonState('EDIT');
}

//删除
function delContent(){
    if(confirm("确定要删除该选中记录吗？")){
        setFormEnable(editForm, true);
        editForm.oper_type.value = "DEL";
        editForm.submit();          
    }
}

// 保存
function saveContent() {
    if (checkInput()) {
       document.getElementById("edit_staff_id").disabled=false;
       submitContent();
       document.getElementById("edit_staff_id").disabled=true;
    }
}

// 取消
function cancelContent() {
    //设置编辑区按钮状态
    clearForm(editForm);
    setButtonState('NORMAL');
    setFormEnable(editForm, false);
}

//检查数据有效性       
function checkInput() {
	if (document.getElementById("edit_staff_id").value == "" || document.getElementById("edit_staff_id").value == "-1") {
        alert("被评人不能为空!");
        document.getElementById("edit_staff_id").focus();
        return false;
    }
	
	var wld_score = $('#edit_wld_score').val().trim();
	var dfc_score = $('#edit_dfc_score').val().trim();
	var qua_score = $('#edit_qua_score').val().trim();
	
	if (wld_score == "" || isNaN(wld_score) || wld_score < 0 || wld_score > 50) {
        alert("工作量得分不为空，且需为0~50的数值!");
        document.getElementById("edit_wld_score").focus();
        return false;
	}

	if (dfc_score == "" || isNaN(dfc_score) || dfc_score < 0 || dfc_score > 35) {
        alert("难度得分不为空，且需为0~35的数值!");
        document.getElementById("edit_dfc_score").focus();
        return false;
	}

	if (qua_score == "" || isNaN(qua_score) || qua_score < 0 || qua_score > 15) {
        alert("完成情况得分不为空，且需为0~15的数值!");
        document.getElementById("edit_qua_score").focus();
        return false;
	}
    return true;
}

//保存
function submitContent() {
	if(confirm("确认提交该任务？")){
	    //设置操作类型 
	    editForm.oper_type.value = operType;
        editForm.submit();
    }
}

function selectRow(month_id, judge_id, staff_id, wld_score, dfc_score, qua_score) {
    document.getElementById("edit_month_id").value = month_id;
    document.getElementById("edit_staff_id").value = staff_id;
    document.getElementById("edit_wld_score").value = wld_score;
    document.getElementById("edit_dfc_score").value = dfc_score;
    document.getElementById("edit_qua_score").value = qua_score;

    setButtonState('CANDEL');
    setFormEnable(editForm, false);
    
    if (judge_id != <%=userId%>) {
        document.getElementById("edit").disabled = true;
        document.getElementById("del").disabled = true;
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
                            String iframPage = "cfgBonusIframe.jsf";
                            String selectedPage = "";
                            String columnInfoPage = "";
                            /*** WEB开发 endding ***/
                        %>
                        <%@include file="/common/reportListDiv.jsp"%>
                    </table></td>
            </tr>
        </form>
        <form id="editForm" action="cfgBonusAction.jsf" method="post"
            target="editIframe">
            <input type="hidden" id="oper_type" name="oper_type" />
            <tr>
                <td class="down_bg8" height="24"><table width="100%"
                        height="24" border="0" cellpadding="0" cellspacing="0"
                        background="<%=path%>/images/table_title_bg3.gif">
                        <tr>
                            <td width="3%"><div align="center">
                                    <img src="<%=path%>/images/arrow_green.gif">
                                </div></td>
                            <td align="left">编辑区</td>
                        </tr>
                    </table></td>
            </tr>
            <tr>
                <td height="10%" class="down_bg8">
                    <table id="InfoPage1" width="100%">
                        <tr>
                            <td width="13%" align="right">月份:</td>
                            <td width="20%" align="left"><input
                                id="edit_month_id" name="edit_month_id" value=""
                                style="width: 150px" /></td>
                            <td width="13%" align="right">工号:</td>
                            <td width="54%" align="left" colspan="3">
                                <select id="edit_staff_id" name="edit_staff_id" style="width: 150px"></select>
                            </td>
                        </tr>
                        <tr>
                            <td width="13%" align="right">工作量得分:</td>
                            <td width="20%" align="left"><input
                                name="edit_wld_score" id="edit_wld_score"
                                style="width: 150px" value="" /><font color="red">0~50</font></td>
                            <td width="13%" align="right">难度得分:</td>
                            <td width="20%" align="left"><input
                                id="edit_dfc_score" name="edit_dfc_score"
                                style="width: 150px" value="" /><font color="red">0~35</font></td>
                            <td width="13%" align="right">完成质量得分:</td>
                            <td width="20%" align="left"><input
                                id="edit_qua_score" name="edit_qua_score"
                                style="width: 150px" value="" /><font color="red">0~15</font></td>
                        </tr>
                        <tr>
                            <td colspan="6" align="right"><table>
                                    <tr>
                                        <td><input id="add"
                                            class="td_Input" name="add"
                                            type="button"
                                            style="cursor: hand; width: 50px"
                                            onClick="addContent();" value="添加" /></td>
                                        <td><input id="edit"
                                            class="td_Input" type="button"
                                            style="cursor: hand; width: 50px;"
                                            onClick="editContent();" value="修改" /></td>
                                        <td><input id="del"
                                            class="td_Input" name="del"
                                            type="button"
                                            style="cursor: hand; width: 50px"
                                            onClick="delContent();" value="删除" /></td>
                                        <td><input id="save"
                                            class="td_Input" name="save"
                                            type="button"
                                            style="cursor: hand; width: 50px"
                                            onClick="saveContent();" value="保存" /></td>
                                        <td><input id="cancel"
                                            class="td_Input" name="cancel"
                                            type="button"
                                            style="cursor: hand; width: 50px"
                                            onClick="cancelContent();"
                                            value="取消" /></td>
                                    </tr>
                                </table></td>
                        </tr>
                    </table>
                </td>
                <iframe src="" width="0" height="0" frameborder="0"
                    name="editIframe"></iframe>
                <iframe src="" width="0" height="0" frameborder="0"
                    name="excelExportIframe"></iframe>
            </tr>
        </form>
    </table>
</body>
</html>