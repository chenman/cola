package org.cola.bonus.dao;

import java.sql.SQLException;

import org.cola.bonus.bean.BonusBatchJudgeBean;
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
public interface BonusBatchJudgeDao {

    /**
     * @param bean
     * @param reqObj
     * @return
     * @throws SQLException 
     */
    DBResult actionTypeAdd(BonusBatchJudgeBean bean, ServiceRequest reqObj) throws SQLException;

}
