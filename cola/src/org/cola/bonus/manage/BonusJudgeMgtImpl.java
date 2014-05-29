package org.cola.bonus.manage;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.cola.bonus.bean.BonusJudgeBean;
import org.cola.bonus.dao.BonusJudgeDao;
import org.cola.bonus.dao.BonusJudgeDaoImpl;
import org.cola.frame.QueryBean;
import org.cola.frame.ServiceRequest;
import org.cola.util.common.Constants;
import org.cola.util.db.DBResult;

/**
 * Description: <br/>
 * Copyright (C), 2001-2014, Jason Chan <br/>
 * This program is protected by copyright laws. <br/>
 * Program Name:BonusJudgeMgtImpl <br/>
 * Date:2014年3月24日
 * 
 * @author ChenMan
 * @version 1.0
 */
public class BonusJudgeMgtImpl implements BonusJudgeMgt {

    private Map resultMap = new HashMap();
    BonusJudgeDao dao = new BonusJudgeDaoImpl();

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
        BonusJudgeBean bean = (BonusJudgeBean) queryBean;
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
    private Map operatorManage(BonusJudgeBean bean, ServiceRequest reqObj,
            String start, String pageCount) throws SQLException {
        String operType = bean.getOper_type();
        if ("ADD".equals(operType)) {// 新增
            actionTypeAdd(bean, reqObj);
        } else if ("DEL".equals(operType)) {// 删除
            actionTypeDelete(bean, reqObj);
        } else if ("MODIFY".equals(operType)) {// 修改
            actionTypeModify(bean, reqObj);
        } else if ("QUERY".equals(operType)) {// 查询
            actionTypeQuery(bean, reqObj, start, pageCount);
        } else if ("QUERY_STAFF".equals(operType)) {// 查询员工
            actionTypeQueryStaff(bean, reqObj, start, pageCount);
        } else if ("QUERY_RANK".equals(operType)) {// 查询排名
            actionTypeQueryRank(bean, reqObj, start, pageCount);
        }
        return resultMap;
    }

    /**
     * @param bean
     * @param reqObj
     * @throws SQLException
     */
    private void actionTypeAdd(BonusJudgeBean bean, ServiceRequest reqObj)
            throws SQLException {

        List resultList = new Vector();

        DBResult rs = dao.actionTypeAdd(bean, reqObj);

        // 结果代码
        resultMap.put(Constants.ERROR_CODE, "0");
        // 总记录数
        resultMap.put(Constants.TOTAL_COUNT, 0);
        // 查询的数据列表
        resultMap.put(Constants.DATA_LIST, resultList);
        // 数据列表存放的是列表类型的数据,如果是bean类型的数据则为false
        resultMap.put(Constants.IS_LIST, "true");
        // 需求编号
        resultMap.put(Constants.OTHER_FLAG, rs.iErrorCode + "|" + rs.sErrorDesc
                + "|" + bean.getEdit_month_id());

    }

    /**
     * @param bean
     * @param reqObj
     * @throws SQLException
     */
    private void actionTypeDelete(BonusJudgeBean bean, ServiceRequest reqObj)
            throws SQLException {

        List resultList = new Vector();

        DBResult rs = dao.actionTypeDelete(bean, reqObj);

        // 结果代码
        resultMap.put(Constants.ERROR_CODE, "0");
        // 总记录数
        resultMap.put(Constants.TOTAL_COUNT, 0);
        // 查询的数据列表
        resultMap.put(Constants.DATA_LIST, resultList);
        // 数据列表存放的是列表类型的数据,如果是bean类型的数据则为false
        resultMap.put(Constants.IS_LIST, "true");
        // 需求编号
        resultMap.put(Constants.OTHER_FLAG, rs.iErrorCode + "|" + rs.sErrorDesc
                + "|" + bean.getEdit_month_id());

    }

    /**
     * @throws SQLException
     * @param bean
     * @param reqObj
     * @throws
     */
    private void actionTypeModify(BonusJudgeBean bean, ServiceRequest reqObj)
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
        resultMap.put(Constants.OTHER_FLAG, rs.iErrorCode + "|" + rs.sErrorDesc
                + "|" + bean.getEdit_month_id());
    }

    /**
     * @param bean
     * @param reqObj
     * @param start
     * @param pageCount
     * @throws SQLException
     * @throws NumberFormatException
     */
    private void actionTypeQuery(BonusJudgeBean bean, ServiceRequest reqObj,
            String start, String pageCount) throws NumberFormatException,
            SQLException {
        DBResult result = null;
        List resultList = new Vector();
        resultMap.clear();
        // 调dao方法

        result = dao.actionTypeQuery(bean, reqObj, start, pageCount);
        resultList.add(result.titleList);
        List rowData = null;
        if (result.iErrorCode == 0 && result.iRowsCnt > 0) {
            for (int row = 0; row < result.iRowsCnt; row++) {
                rowData = new Vector();

                for (int col = 0; col < result.iColsCnt; col++) {
                    rowData.add(result.aaRes[row][col]);
                }
                resultList.add(rowData);
            }
        }

        // 查询结果代码
        resultMap.put(Constants.ERROR_CODE, String.valueOf(result.iErrorCode));
        // 总记录数
        resultMap.put(Constants.RECORD_CNT, result.iTotalCnt);
        // 查询的数据列表
        resultMap.put(Constants.DATA_LIST, resultList);
        // 数据列表存放的是列表类型的数据,如果是bean类型的数据则为false
        resultMap.put(Constants.IS_LIST, "true");

    }
    
    private void actionTypeQueryStaff(BonusJudgeBean bean, ServiceRequest reqObj,
            String start, String pageCount) throws NumberFormatException,
            SQLException {
        DBResult result = null;
        List resultList = new Vector();
        resultMap.clear();
        // 调dao方法

        result = dao.actionTypeQueryStaff(bean, reqObj, start, pageCount);
//        resultList.add(result.titleList);
        List rowData = null;
        if (result.iErrorCode == 0 && result.iRowsCnt > 0) {
            for (int row = 0; row < result.iRowsCnt; row++) {
                rowData = new Vector();

                for (int col = 0; col < result.iColsCnt; col++) {
                    rowData.add(result.aaRes[row][col]);
                }
                resultList.add(rowData);
            }
        }

        // 查询结果代码
        resultMap.put(Constants.ERROR_CODE, String.valueOf(result.iErrorCode));
        // 总记录数
        resultMap.put(Constants.RECORD_CNT, result.iTotalCnt);
        // 查询的数据列表
        resultMap.put(Constants.DATA_LIST, resultList);
        // 数据列表存放的是列表类型的数据,如果是bean类型的数据则为false
        resultMap.put(Constants.IS_LIST, "true");

    }

    private void actionTypeQueryRank(BonusJudgeBean bean, ServiceRequest reqObj,
            String start, String pageCount) throws NumberFormatException,
            SQLException {
        DBResult result = null;
        List resultList = new Vector();
        resultMap.clear();
        // 调dao方法

        result = dao.actionTypeQueryRank(bean, reqObj, start, pageCount);
        resultList.add(result.titleList);
        List rowData = null;
        if (result.iErrorCode == 0 && result.iRowsCnt > 0) {
            for (int row = 0; row < result.iRowsCnt; row++) {
                rowData = new Vector();

                for (int col = 0; col < result.iColsCnt; col++) {
                    rowData.add(result.aaRes[row][col]);
                }
                resultList.add(rowData);
            }
        }

        // 查询结果代码
        resultMap.put(Constants.ERROR_CODE, String.valueOf(result.iErrorCode));
        // 总记录数
        resultMap.put(Constants.RECORD_CNT, result.iTotalCnt);
        // 查询的数据列表
        resultMap.put(Constants.DATA_LIST, resultList);
        // 数据列表存放的是列表类型的数据,如果是bean类型的数据则为false
        resultMap.put(Constants.IS_LIST, "true");

    }

}
