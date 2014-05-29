package org.cola.admin.dao;

import java.sql.SQLException;

import org.cola.admin.bean.UserPwdBean;
import org.cola.frame.ServiceRequest;
import org.cola.util.db.DBResult;

/**
 * Description:
 * <br/>Copyright (C), 2001-2014, Jason Chan
 * <br/>This program is protected by copyright laws.
 * <br/>Program Name:UserPwdDao
 * <br/>Date:2014年3月24日
 * @author	ChenMan
 * @version	1.0
 */
public interface UserPwdDao {

    /**
     * @param bean
     * @param reqObj
     * @return
     * @throws SQLException 
     */
    DBResult actionTypeModify(UserPwdBean bean, ServiceRequest reqObj) throws SQLException;


}
