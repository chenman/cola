package org.cola.admin.manage;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.cola.admin.bean.UserPwdBean;
import org.cola.admin.dao.UserPwdDao;
import org.cola.admin.dao.UserPwdDaoImpl;
import org.cola.frame.QueryBean;
import org.cola.frame.ServiceRequest;
import org.cola.util.common.Constants;
import org.cola.util.db.DBResult;

/**
 * Description: <br/>
 * Copyright (C), 2001-2014, Jason Chan <br/>
 * This program is protected by copyright laws. <br/>
 * Program Name:UserPwdMgtImpl <br/>
 * Date:2014年3月24日
 * 
 * @author ChenMan
 * @version 1.0
 */
public class UserPwdMgtImpl implements UserPwdMgt {

    private Map resultMap = new HashMap();
    UserPwdDao dao = new UserPwdDaoImpl();

    /*
     * (non-Javadoc)
     * 
     * @see
     * org.cola.bonus.frame.QueryMgt#getData(org.cola.bonus.frame.QueryBean,
     * org.cola.bonus.frame.ServiceRequest, java.lang.String, java.lang.String)
     */
    public Map getData(QueryBean queryBean, ServiceRequest reqObj,
            String start, String pageCount) throws SQLException,
            IllegalArgumentException {
        UserPwdBean bean = (UserPwdBean) queryBean;
        return operatorManage(bean, reqObj, start, pageCount);
    }

    /**
     * @param bean
     * @param reqObj
     * @param start
     * @param pageCount
     * @return
     * @throws SQLException
     */
    private Map operatorManage(UserPwdBean bean, ServiceRequest reqObj,
            String start, String pageCount) throws SQLException {
        actionTypeModify(bean, reqObj);
        return resultMap;
    }

    /**
     * @throws SQLException
     * @param bean
     * @param reqObj
     * @throws
     */
    private void actionTypeModify(UserPwdBean bean, ServiceRequest reqObj)
            throws SQLException {

        List resultList = new Vector();

        DBResult rs;
        rs = dao.actionTypeModify(bean, reqObj);
        // 结果代码
        resultMap.put(Constants.ERROR_CODE, "0");
        // 总记录数
        resultMap.put(Constants.TOTAL_COUNT, 0);
        // 查询的数据列表
        resultMap.put(Constants.DATA_LIST, resultList);
        // 数据列表存放的是列表类型的数据,如果是bean类型的数据则为false
        resultMap.put(Constants.IS_LIST, "true");
        // 需求编号
        resultMap.put(Constants.OTHER_FLAG, rs.iErrorCode + "|" + rs.sErrorDesc);
    }

}
