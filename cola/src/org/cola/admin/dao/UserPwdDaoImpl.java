package org.cola.admin.dao;

import java.sql.SQLException;

import org.cola.admin.bean.UserPwdBean;
import org.cola.dao.DaoImpl;
import org.cola.frame.ServiceRequest;
import org.cola.util.common.MD5Util;
import org.cola.util.db.DBResult;

/**
 * Description: <br/>
 * Copyright (C), 2001-2014, Jason Chan <br/>
 * This program is protected by copyright laws. <br/>
 * Program Name:UserPwdDaoImpl <br/>
 * Date:2014年3月24日
 * 
 * @author ChenMan
 * @version 1.0
 */
public class UserPwdDaoImpl extends DaoImpl implements UserPwdDao {

    public DBResult actionTypeModify(UserPwdBean bean, ServiceRequest reqObj)
            throws SQLException {
        DBResult result = null;
        StringBuffer sb = new StringBuffer();
        
        sb.append("select passwd from CFG_SUPP_STAFF_INFO where staff_id = " + reqObj.getUserId());
        result = executeQuery(sb.toString());
        if (!MD5Util.md5Encode(bean.getEdit_old_pwd().trim()).equals(
                result.aaRes[0][0].toUpperCase())) {

            result = new DBResult(); 
            result.iErrorCode = 2;
            result.sErrorDesc = "原密码错误！";
            return result;
        }
        
        sb.setLength(0);
        sb.append("update CFG_SUPP_STAFF_INFO set passwd = '" + MD5Util.md5Encode(bean.getEdit_new_pwd().trim()) + "' where staff_id = " + reqObj.getUserId());
        System.out.println(sb.toString());
        result = executeSql(sb.toString());

        return result;
    }
}
