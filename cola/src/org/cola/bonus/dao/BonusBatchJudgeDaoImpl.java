package org.cola.bonus.dao;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.cola.bonus.bean.BonusBatchJudgeBean;
import org.cola.dao.DaoImpl;
import org.cola.frame.ServiceRequest;
import org.cola.util.db.DBResult;

/**
 * Description: <br/>
 * Copyright (C), 2001-2014, Jason Chan <br/>
 * This program is protected by copyright laws. <br/>
 * Program Name:BonusBatchJudgeDaoImpl <br/>
 * Date:2014年3月24日
 * 
 * @author ChenMan
 * @version 1.0
 */
public class BonusBatchJudgeDaoImpl extends DaoImpl implements
        BonusBatchJudgeDao {

    public DBResult actionTypeAdd(BonusBatchJudgeBean bean,
            ServiceRequest reqObj) throws SQLException {
        DBResult result = null;
        StringBuffer sb = new StringBuffer();

        sb.append("select count(0) from cfg_supp_staff_bonus where 1 = 1");
        sb.append(" and month_id = " + bean.getEdit_month_id());
        sb.append(" and judge_id = " + reqObj.getUserId());
        result = executeSql(sb.toString());

        int cnt = Integer.parseInt(result.aaRes[0][0]);
        if (cnt > 0) {
            result = new DBResult();
            result.iErrorCode = 2;
            result.sErrorDesc = "您本月已参与互评，请勿重复提交。";
            return result;
        }
        
        String[] staff_ids = bean.getEdit_staff_id().split(",");
        String[] wld_scores = bean.getEdit_wld_score().split(",");
        String[] dfc_scores = bean.getEdit_dfc_score().split(",");
        String[] qua_scores = bean.getEdit_qua_score().split(",");
        
        int score, level_id;
        List<String> sqlList = new ArrayList<String>();
        for (int i = 0; i < staff_ids.length; ++i) {
            score = Integer.parseInt(wld_scores[i])
                    + Integer.parseInt(dfc_scores[i])
                    + Integer.parseInt(qua_scores[i]);
            level_id = getLevelId(score);

            sb.setLength(0);
            sb.append("insert into cfg_supp_staff_bonus (month_id, staff_id, judge_id, judge_time, wld_score, dfc_score, qua_score, level_id) values (");
            sb.append(bean.getEdit_month_id() + ", ");
            sb.append(staff_ids[i] + ", ");
            sb.append(reqObj.getUserId() + ", ");
            sb.append("now(), ");
            sb.append(wld_scores[i] + ", ");
            sb.append(dfc_scores[i] + ", ");
            sb.append(qua_scores[i] + ",");
            sb.append(level_id + ")");

            sqlList.add(sb.toString());
        }
        result = executeBatch(sqlList);
        return result;
    }

    private int getLevelId(int score) {
        if (score >= 90) {
            return 1;
        } else if (score >= 85 && score < 90) {
            return 2;
        } else if (score >= 75 && score < 85) {
            return 3;
        } else {
            return 4;
        }
    }

}
