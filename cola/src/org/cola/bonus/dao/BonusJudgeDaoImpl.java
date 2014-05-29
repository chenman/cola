package org.cola.bonus.dao;

import java.sql.SQLException;

import org.cola.bonus.bean.BonusJudgeBean;
import org.cola.dao.DaoImpl;
import org.cola.frame.ServiceRequest;
import org.cola.util.common.Function;
import org.cola.util.db.DBResult;

/**
 * Description: <br/>
 * Copyright (C), 2001-2014, Jason Chan <br/>
 * This program is protected by copyright laws. <br/>
 * Program Name:BonusJudgeDaoImpl <br/>
 * Date:2014年3月24日
 * 
 * @author ChenMan
 * @version 1.0
 */
public class BonusJudgeDaoImpl extends DaoImpl implements BonusJudgeDao {
    public DBResult actionTypeQuery(BonusJudgeBean bean, ServiceRequest reqObj,
            String start, String pageCount) throws NumberFormatException,
            SQLException {
        DBResult result = null;
        StringBuffer sb = new StringBuffer();
        
        sb.append("select staff_type from cfg_supp_staff_info where staff_id = " + reqObj.getUserId());
        result = executeQuery(sb.toString());
        int staff_type = Integer.parseInt(result.aaRes[0][0]);
        
        sb.setLength(0);
        sb.append("select t1.month_id 月份, t1.judge_id 评分人工号, t3.staff_name 评分人, t1.staff_id 被评人工号, t2.staff_name 被评人, date_format(t1.judge_time,'%Y-%m-%d %T') 评分时间, t1.wld_score 工作量得分, t1.dfc_score 难度得分, t1.qua_score 完成质量得分, t1.wld_score + t1.dfc_score + t1.qua_score 得分 from cfg_supp_staff_bonus t1");
        sb.append(" left join cfg_supp_staff_info t2 on t2.staff_id = t1.staff_id");
        sb.append(" left join cfg_supp_staff_info t3 on t3.staff_id = t1.judge_id where 1 = 1");

        if (!Function.equalsNull(bean.getQry_month_id())) {
            sb.append(" and t1.month_id = " + bean.getQry_month_id());
        }
        
        // 1：普通员工,2:室经理
        if (1 == staff_type) {
            sb.append(" and t1.judge_id = " + reqObj.getUserId());
        }
        
        result = executeQueryByPage(sb.toString(), Integer.parseInt(start),
                Integer.parseInt(pageCount));
        return result;
    }

    public DBResult actionTypeAdd(BonusJudgeBean bean, ServiceRequest reqObj)
            throws SQLException {
        DBResult result = null;
        StringBuffer sb = new StringBuffer();
        
        sb.append("select count(0) from cfg_supp_staff_bonus where 1 = 1");
        sb.append(" and month_id = " + bean.getEdit_month_id());
        sb.append(" and staff_id = " + bean.getEdit_staff_id());
        sb.append(" and judge_id = " + reqObj.getUserId());
        result = executeSql(sb.toString());
        
        int cnt  = Integer.parseInt(result.aaRes[0][0]);
        if (cnt > 0) {
            result = new DBResult(); 
            result.iErrorCode = 2;
            result.sErrorDesc = "该员工已互评过，请勿重复提交。";
            return result;
        }
        
        int score = Integer.parseInt(bean.getEdit_wld_score()) + Integer.parseInt(bean.getEdit_dfc_score()) + Integer.parseInt(bean.getEdit_qua_score());
        int level_id = getLevelId(score);
        
        String errMsg = judgeValidate(bean.getEdit_month_id(), bean.getEdit_staff_id(), reqObj.getUserId(), level_id);
        
        if (!Function.equalsNull(errMsg)) {
            result = new DBResult(); 
            result.iErrorCode = 2;
            result.sErrorDesc = errMsg;
            return result;
        }
        
        sb.setLength(0);
        sb.append("insert into cfg_supp_staff_bonus (month_id, staff_id, judge_id, judge_time, wld_score, dfc_score, qua_score, level_id) values (");
        sb.append(bean.getEdit_month_id() + ", ");
        sb.append(bean.getEdit_staff_id() + ", ");
        sb.append(reqObj.getUserId() + ", ");
        sb.append("now(), ");
        sb.append(bean.getEdit_wld_score() + ", ");
        sb.append(bean.getEdit_dfc_score() + ", ");
        sb.append(bean.getEdit_qua_score() + ",");
        sb.append(level_id + ")");

        result = executeSql(sb.toString());
        return result;
    }

    public DBResult actionTypeDelete(BonusJudgeBean bean, ServiceRequest reqObj)
            throws SQLException {
        DBResult result = null;
        StringBuffer sb = new StringBuffer();
        sb.append("delete from cfg_supp_staff_bonus where 1 = 1");
        sb.append(" and month_id = " + bean.getEdit_month_id());
        sb.append(" and staff_id = " + bean.getEdit_staff_id());
        sb.append(" and judge_id = " + reqObj.getUserId());

        result = executeSql(sb.toString());
        return result;
    }

    public DBResult actionTypeModify(BonusJudgeBean bean, ServiceRequest reqObj)
            throws SQLException {
        DBResult result = null;
        StringBuffer sb = new StringBuffer();

        int score = Integer.parseInt(bean.getEdit_wld_score()) + Integer.parseInt(bean.getEdit_dfc_score()) + Integer.parseInt(bean.getEdit_qua_score());
        int level_id = getLevelId(score);

        String errMsg = judgeValidate(bean.getEdit_month_id(), bean.getEdit_staff_id(), reqObj.getUserId(), level_id);
        
        if (!Function.equalsNull(errMsg)) {
            result = new DBResult(); 
            result.iErrorCode = 2;
            result.sErrorDesc = errMsg;
            return result;
        }
        
        sb.append("update cfg_supp_staff_bonus set judge_time = now(), ");
        sb.append("wld_score = " + bean.getEdit_wld_score() + ", ");
        sb.append("dfc_score = " + bean.getEdit_dfc_score() + ", ");
        sb.append("qua_score = " + bean.getEdit_qua_score() + ", ");
        sb.append("level_id = " + level_id + " ");
        sb.append("where 1 = 1");
        sb.append(" and month_id = " + bean.getEdit_month_id());
        sb.append(" and staff_id = " + bean.getEdit_staff_id());
        sb.append(" and judge_id = " + reqObj.getUserId());

        result = executeSql(sb.toString());
        return result;
    }

    /*
     * (non-Javadoc)
     * 
     * @see
     * org.cola.bonus.dao.BonusJudgeDao#actionTypeQueryStaff(org.cola.bonus.
     * bean.BonusJudgeBean, org.cola.frame.ServiceRequest, java.lang.String,
     * java.lang.String)
     */
    public DBResult actionTypeQueryStaff(BonusJudgeBean bean,
            ServiceRequest reqObj, String start, String pageCount)
            throws NumberFormatException, SQLException {
        DBResult result = null;
        StringBuffer sb = new StringBuffer();

        sb.append("select staff_id, staff_name from cfg_supp_staff_info where staff_type = 1 and staff_id <> "
                + reqObj.getUserId());

        result = executeQuery(sb.toString());
        return result;
    }

    public DBResult actionTypeQueryRank(BonusJudgeBean bean,
            ServiceRequest reqObj, String start, String pageCount)
            throws NumberFormatException, SQLException {
        DBResult result = null;
        StringBuffer sb = new StringBuffer();

        sb.append("select t1.month_id 月份,");
        sb.append("       t1.staff_id 工号,");
        sb.append("       t2.staff_name 姓名,");
        sb.append("       round(sum(t1.avg_wld_score * t1.weight) / sum(t1.weight), 6) 工作量得分,");
        sb.append("       round(sum(t1.avg_dfc_score * t1.weight) / sum(t1.weight), 6) 难度得分,");
        sb.append("       round(sum(t1.avg_qua_score * t1.weight) / sum(t1.weight), 6) 完成质量得分,");
        sb.append("       round(sum(t1.avg_score * t1.weight) / sum(t1.weight), 6) 得分");
        sb.append("  from (select t1.month_id,");
        sb.append("               t1.staff_id,");
        sb.append("               if(t2.staff_type = 1, 0.7, 0.3) weight,");
        sb.append("               round(avg(t1.wld_score), 6) avg_wld_score,");
        sb.append("               round(avg(t1.dfc_score), 6) avg_dfc_score,");
        sb.append("               round(avg(t1.qua_score), 6) avg_qua_score,");
        sb.append("               round(avg(t1.wld_score + t1.dfc_score + t1.qua_score), 6) avg_score");
        sb.append("          from cfg_supp_staff_bonus t1, cfg_supp_staff_info t2");
        sb.append("         where t1.judge_id = t2.staff_id");

        if (!Function.equalsNull(bean.getQry_month_id())) {
            sb.append(" and t1.month_id = " + bean.getQry_month_id());
        }
        
        sb.append("         group by t1.month_id, t1.staff_id, t2.staff_type) t1");
        sb.append("  left join cfg_supp_staff_info t2");
        sb.append("    on t1.staff_id = t2.staff_id");
        sb.append(" group by t1.month_id, t1.staff_id, t2.staff_name");
        sb.append(" order by t1.month_id, round(sum(t1.avg_score * t1.weight) / sum(t1.weight), 6) desc");
        
        result = executeQueryByPage(sb.toString(), Integer.parseInt(start),
                Integer.parseInt(pageCount));
        return result;
    }
    
    private String judgeValidate (String month_id, String staff_id, String judge_id, int level_id) throws SQLException {
        StringBuffer sb = new StringBuffer();
        DBResult result = null;
        
        sb.append("select count(*) from cfg_supp_staff_bonus where 1 = 1");
        sb.append(" and month_id = " + month_id);
        sb.append(" and staff_id <> " + staff_id);
        sb.append(" and judge_id = " + judge_id);
        sb.append(" and level_id = " + level_id);
        result = executeQuery(sb.toString());
        int cnt = Integer.parseInt(result.aaRes[0][0]);
        
        sb.setLength(0);
        sb.append("select level_cnt from cfg_bonus_level where 1 = 1");
        sb.append(" and level_id = " + level_id);
        result = executeQuery(sb.toString());
        int level_cnt = Integer.parseInt(result.aaRes[0][0]);

        sb.setLength(0);
        if (cnt >= level_cnt) {
            switch (level_id) {
            case 1:
                sb.append("90分及以上的人数已达上限：" + level_cnt + "人。");
                break;
            case 2:
                sb.append("85（含）-89分的人数已达上限：" + level_cnt + "人。");
                break;
            case 3:
                sb.append("75（含）-84分的人数已达上限：" + level_cnt + "人。");
                break;
            default:
                sb.append("75分以下的人数已达上限：" + level_cnt + "人。");
                break;
            }
        }
        
        return sb.toString();
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
