package org.cola.bonus.dao;

import java.sql.SQLException;

import org.cola.bonus.bean.BonusJudgeBean;
import org.cola.frame.ServiceRequest;
import org.cola.util.db.DBResult;

/**
 * Description:
 * <br/>Copyright (C), 2001-2014, Jason Chan
 * <br/>This program is protected by copyright laws.
 * <br/>Program Name:BonusJudgeDao
 * <br/>Date:2014年3月24日
 * @author	ChenMan
 * @version	1.0
 */
public interface BonusJudgeDao {

    /**
     * @param bean
     * @param reqObj
     * @return
     * @throws SQLException 
     */
    DBResult actionTypeAdd(BonusJudgeBean bean, ServiceRequest reqObj) throws SQLException;

    /**
     * @param bean
     * @param reqObj
     * @return
     * @throws SQLException 
     */
    DBResult actionTypeDelete(BonusJudgeBean bean, ServiceRequest reqObj) throws SQLException;

    /**
     * @param bean
     * @param reqObj
     * @return
     * @throws SQLException 
     */
    DBResult actionTypeModify(BonusJudgeBean bean, ServiceRequest reqObj) throws SQLException;

    /**
     * @param bean
     * @param reqObj
     * @param start
     * @param pageCount
     * @return
     * @throws SQLException 
     * @throws NumberFormatException 
     */
    DBResult actionTypeQuery(BonusJudgeBean bean, ServiceRequest reqObj,
            String start, String pageCount) throws NumberFormatException, SQLException;

    /**
     * @param bean
     * @param reqObj
     * @param start
     * @param pageCount
     * @return
     */
    DBResult actionTypeQueryStaff(BonusJudgeBean bean, ServiceRequest reqObj,
            String start, String pageCount) throws NumberFormatException, SQLException;

    /**
     * @param bean
     * @param reqObj
     * @param start
     * @param pageCount
     * @return
     */
    DBResult actionTypeQueryRank(BonusJudgeBean bean, ServiceRequest reqObj,
            String start, String pageCount) throws NumberFormatException, SQLException;

}
