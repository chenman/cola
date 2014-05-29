package org.cola.bonus.bean;

import org.cola.frame.QueryBean;

/**
 * Description:
 * <br/>Copyright (C), 2001-2014, Jason Chan
 * <br/>This program is protected by copyright laws.
 * <br/>Program Name:BonusJudgeBean
 * <br/>Date:2014年3月24日
 * @author	ChenMan
 * @version	1.0
 */
public class BonusJudgeBean extends QueryBean {
    
    /**
     * 
     */
    private static final long serialVersionUID = 1L;

    private String oper_type;
    
    private String qry_month_id;
    
    private String edit_staff_id;
    
    private String edit_month_id;
    
    private String edit_wld_score;
    
    private String edit_dfc_score;
    
    private String edit_qua_score;
    
    private String score;

    public String getOper_type() {
        return oper_type;
    }

    public void setOper_type(String oper_type) {
        this.oper_type = oper_type;
    }

    public String getQry_month_id() {
        return qry_month_id;
    }

    public void setQry_month_id(String qry_month_id) {
        this.qry_month_id = qry_month_id;
    }
    
    public String getEdit_staff_id() {
        return edit_staff_id;
    }

    public void setEdit_staff_id(String edit_staff_id) {
        this.edit_staff_id = edit_staff_id;
    }

    public String getEdit_month_id() {
        return edit_month_id;
    }

    public void setEdit_month_id(String edit_month_id) {
        this.edit_month_id = edit_month_id;
    }

    public String getEdit_wld_score() {
        return edit_wld_score;
    }

    public void setEdit_wld_score(String edit_wld_score) {
        this.edit_wld_score = edit_wld_score;
    }

    public String getEdit_dfc_score() {
        return edit_dfc_score;
    }

    public void setEdit_dfc_score(String edit_dfc_score) {
        this.edit_dfc_score = edit_dfc_score;
    }

    public String getEdit_qua_score() {
        return edit_qua_score;
    }

    public void setEdit_qua_score(String edit_qua_score) {
        this.edit_qua_score = edit_qua_score;
    }

    public String getScore() {
        return score;
    }

    public void setScore(String score) {
        this.score = score;
    }
    
}
