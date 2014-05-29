package org.cola.admin.bean;

import org.cola.frame.QueryBean;

/**
 * Description:
 * <br/>Copyright (C), 2001-2014, Jason Chan
 * <br/>This program is protected by copyright laws.
 * <br/>Program Name:UserPwdBean
 * <br/>Date:2014年4月3日
 * @author	ChenMan
 * @version	1.0
 */
public class UserPwdBean extends QueryBean {

    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
    private String edit_old_pwd;
    
    private String edit_new_pwd;

    public String getEdit_old_pwd() {
        return edit_old_pwd;
    }

    public void setEdit_old_pwd(String edit_old_pwd) {
        this.edit_old_pwd = edit_old_pwd;
    }

    public String getEdit_new_pwd() {
        return edit_new_pwd;
    }

    public void setEdit_new_pwd(String edit_new_pwd) {
        this.edit_new_pwd = edit_new_pwd;
    }
    
}
