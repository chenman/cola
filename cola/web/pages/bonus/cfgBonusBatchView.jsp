<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="org.cola.bean.UserInfoBean"%>
<%
    String path = request.getContextPath();
    UserInfoBean userInfo = (UserInfoBean) session.getAttribute("userInfoBean");
    if (userInfo == null) {
    	response.sendRedirect("login.jsf");
    	return;
    }
    String userId = userInfo.getUserId();
    String userType = userInfo.getUserType();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>绩效互评</title>
<link href="<%=path%>/css/css.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="<%=path%>/js/jquery.min.js"></script>
<script type="text/javascript" src="<%=path%>/js/dateUtil.js"></script>
<style type="text/css">
.transInput {
    border: 0px;
    background-color: transparent;
    width: 65px;
}

.fontStyle {
    background-repeat: repeat-x;
    background-color: #EAEFFA;
    font-family: "宋体";
    font-size: 16px;
    text-align: left;
    height: 30px;
}

.editTable {
    border-top: 1px solid #C8DDF9;
    border-left: 1px solid #C8DDF9;
    border-right: 1px solid #C8DDF9;
    border-bottom: 1px solid #C8DDF9;
}
</style>
<script>
    String.prototype.trim = function() {
        return this.replace(/(^\s*)|(\s*$)/g, "");
    };

    var userType = <%=userType%>;
    function pageLoad() {
		if (userType == 2) {
			$("#desc").text("");
		}
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

        document.getElementById("edit_month_id").value = last_month
            .Format('YYYYMM');
        document.getElementById("edit_month_id").readOnly = true;

        var param = {
            oper_type : "QUERY_STAFF"
        };
        $.post("cfgBonusAction.jsf", param, function(rs) {
            var data = eval(rs);
            $(data).each(function(key) {
                appendEditRows(data[key][0], data[key][1]);
            });
        });
    }

    function appendEditRows(staff_id, staff_name) {
        $('#bonusTbl')
            .append(
                "<tr><td><input type='text' name='staff_id' value='"
                    + staff_id
                    + "' class='transInput' readOnly='true'/></td><td>"
                    + staff_name
                    + "</td><td>"
                    + "<input type='text' name='wld_score' value='' style='width: 150px' onkeyup='checkWld(this);updateScore(this);'/> </td><td>"
                    + "<input type='text' name='dfc_score' value='' style='width: 150px' onkeyup='checkDfc(this);updateScore(this);'/> </td><td>"
                    + "<input type='text' name='qua_score' value='' style='width: 150px' onkeyup='checkQua(this);updateScore(this);'/> </td><td>"
                    + "<input name='score' class='transInput' readOnly='true' value=''/> </td></tr>");
    }
    
    function checkWld(e) {
        var wld_score = e.value.trim();
    	if (wld_score == "" || isNaN(wld_score) || wld_score < 0 || wld_score > 50) {
            alert("工作量得分不为空，且需为0~50的数值!");
            e.value = "";
            e.focus();
    	}
    }

    function checkDfc(e) {
        var dfc_score = e.value.trim();
    	if (dfc_score == "" || isNaN(dfc_score) || dfc_score < 0 || dfc_score > 35) {
            alert("难度得分不为空，且需为0~35的数值!");
            e.value = "";
            e.focus();
    	}
    }

    function checkQua(e) {
        var qua_score = e.value.trim();
    	if (qua_score == "" || isNaN(qua_score) || qua_score < 0 || qua_score > 15) {
            alert("完成情况得分不为空，且需为0~15的数值!");
            e.value = "";
            e.focus();
    	}
    }
    
    function updateScore(e) {
        var i = e.parentNode.parentNode.rowIndex - 1;
        var wld_score = document.getElementsByName("wld_score")[i].value.trim();
        var dfc_score = document.getElementsByName("dfc_score")[i].value.trim();
        var qua_score = document.getElementsByName("qua_score")[i].value.trim();
        var score = 0;
        
        wld_score = Number((wld_score == "") ? 0 : wld_score);
        dfc_score = Number((dfc_score == "") ? 0 : dfc_score);
        qua_score = Number((qua_score == "") ? 0 : qua_score);
        
        score = wld_score + dfc_score + qua_score;
        
        if (score > 0) {
            document.getElementsByName("score")[i].value = score;
        }
    }

    function checkInput() {
        
        var staff_ids = document.getElementsByName("staff_id");
        var wld_scores = document.getElementsByName("wld_score");
        var dfc_scores = document.getElementsByName("dfc_score");
        var qua_scores = document.getElementsByName("qua_score");
        
        var staff_id;
        var wld_score;
        var dfc_score;
        var qua_score;
        var score;
        
        var v_staff_id = '';
        var v_wld_score = '';
        var v_dfc_score = '';
        var v_qua_score = '';
        
        var a_cnt = 0;
        var b_cnt = 0;
        var c_cnt = 0;
        var d_cnt = 0;

        for (var i = 0; i < bonusTbl.rows.length - 1; ++i) {
            staff_id = staff_ids[i].value.trim();
        	wld_score = wld_scores[i].value.trim();
        	dfc_score = dfc_scores[i].value.trim();
        	qua_score = qua_scores[i].value.trim();
        	
        	if (wld_score == "" || isNaN(wld_score) || wld_score < 0 || wld_score > 50) {
                alert("工作量得分不为空，且需为0~50的数值!");
                document.getElementsByName("wld_score")[i].focus();
                return false;
        	}

        	if (dfc_score == "" || isNaN(dfc_score) || dfc_score < 0 || dfc_score > 35) {
                alert("难度得分不为空，且需为0~35的数值!");
                document.getElementsByName("dfc_score")[i].focus();
                return false;
        	}

        	if (qua_score == "" || isNaN(qua_score) || qua_score < 0 || qua_score > 15) {
                alert("完成情况得分不为空，且需为0~15的数值!");
                document.getElementsByName("qua_score")[i].focus();
                return false;
        	}
        	score = Number(wld_score) + Number(dfc_score) + Number(qua_score);
        	if (score >= 90) {
        	    ++a_cnt;
        	} else if (score >= 85 && score < 90) {
                ++b_cnt;
            } else if (score >= 75 && score < 85) {
                ++c_cnt;
            } else {
                ++d_cnt;
            }
        	
        	if (i == 0) {
        	    v_staff_id += staff_id;
        	    v_wld_score += wld_score;
        	    v_dfc_score += dfc_score;
        	    v_qua_score += qua_score;
        	} else {
        	    v_staff_id += ',' + staff_id;
        	    v_wld_score += ',' + wld_score;
        	    v_dfc_score += ',' + dfc_score;
        	    v_qua_score += ',' + qua_score;
        	}
        }
        if (userType != 2 && (a_cnt != 2 || b_cnt != 4 || c_cnt != 5 || d_cnt != 1)) {
            alert("不符合评分分布规则!");
            return false;
        }
        
        $("#edit_staff_id").val(v_staff_id);
        $("#edit_wld_score").val(v_wld_score);
        $("#edit_dfc_score").val(v_dfc_score);
        $("#edit_qua_score").val(v_qua_score);
        
        return true;
    }

    function saveContent() {
        if (checkInput()) {
    	    editForm.oper_type.value = "ADD";
            editForm.submit();
        }
    }
</script>
</head>
<body onload="pageLoad();">
    <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0"
        align="center">
        <form id="editForm" action="cfgBonusBatchAction.jsf" method="post"
            target="editIframe">
            <input type="hidden" id="oper_type" name="oper_type" value="" /> 
            <input type="hidden" id="edit_staff_id" name="edit_staff_id" value="" /> 
            <input type="hidden" id="edit_wld_score" name="edit_wld_score" value="" /> 
            <input type="hidden" id="edit_dfc_score" name="edit_dfc_score" value="" /> 
            <input type="hidden" id="edit_qua_score" name="edit_qua_score" value="" /> 
            <table width="720px" height="100%" cellpadding="0" cellspacing="0"
                class="editTable">
                <tr>
                    <td class="down_bg8 fontStyle" align="left">月份: <input
                        id="edit_month_id" name="edit_month_id" value=""
                        class="transInput" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <table id="bonusTbl" width="720px">
                            <tr>
                                <th>工号</th>
                                <th>姓名</th>
                                <th>工作量得分0~50</th>
                                <th>难度得分0~35</th>
                                <th>完成质量得分0~15</th>
                                <th>总分</th>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td align="left"><font id="desc">分布规则：90分及以上2人，85-89分4人，75-84分5人，75分以下1人!</font></td>
                            <td align="right">
                            <input id="save" class="td_Input"
                                name="save" type="button"
                                style="cursor: hand; width: 50px"
                                onClick="saveContent();" value="提交" valign="right"/>
                            </td>
                        </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <iframe src="" width="0" height="0" frameborder="0"
                name="editIframe"></iframe>
        </form>
    </table>
</body>
</html>