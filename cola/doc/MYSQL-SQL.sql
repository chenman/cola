insert into user (host,user,password) values ('localhost', 'cola', password('123456'));

FLUSH PRIVILEGES;

CREATE DATABASE `cola` /*!40100 DEFAULT CHARACTER SET utf8 */

grant SELECT,INSERT,UPDATE,DELETE,CREATE,DROP on cola.* to 'cola'@'localhost' identified by '123456';

use cola;

CREATE TABLE `cfg_supp_staff_info` (
  `staff_id` int(11) DEFAULT NULL,
  `staff_name` varchar(64) CHARACTER SET utf8 DEFAULT NULL,
  `passwd` varchar(32) CHARACTER SET utf8 DEFAULT NULL,
  `org_id` int(11) DEFAULT NULL,
  `staff_type` int(11) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



insert into cfg_supp_staff_info values (4000221,'李骏洪', md5('123456'), 4000029, 2, now());
insert into cfg_supp_staff_info values (4000335,'陈梅香', md5('123456'), 4000029, 1, now());
insert into cfg_supp_staff_info values (4000330,'周琳萍', md5('123456'), 4000029, 1, now());
insert into cfg_supp_staff_info values (4000350,'许云', md5('123456'), 4000029, 1, now());
insert into cfg_supp_staff_info values (4000336,'林茂宇', md5('123456'), 4000029, 1, now());
insert into cfg_supp_staff_info values (4000352,'林德立', md5('123456'), 4000029, 1, now());
insert into cfg_supp_staff_info values (4000349,'何晓升', md5('123456'), 4000029, 1, now());
insert into cfg_supp_staff_info values (4000353,'陈满', md5('123456'), 4000029, 1, now());
insert into cfg_supp_staff_info values (4000354,'蔡敏敏', md5('123456'), 4000029, 1, now());
insert into cfg_supp_staff_info values (4006826,'江莹莹', md5('123456'), 4000029, 1, now());
insert into cfg_supp_staff_info values (4001086,'汤言捷', md5('123456'), 4000029, 1, now());
insert into cfg_supp_staff_info values (4000860,'王少珠', md5('123456'), 4000029, 1, now());
insert into cfg_supp_staff_info values (4009300,'黄惠娟', md5('123456'), 4000029, 1, now());
insert into cfg_supp_staff_info values (4000054,'杨华', md5('123456'), 4000029, 1, now());

create table cfg_supp_staff_bonus (
  month_id int(6),
  judge_id int,
  staff_id int,
  judge_time datetime,
  wld_score int,
  dfc_score int,
  qua_score int,
  level_id int
);

create table cfg_bonus_level (
  level_id int,
  level_cnt int
);

insert into cfg_bonus_level (level_id, level_cnt) values (1, 2);
insert into cfg_bonus_level (level_id, level_cnt) values (2, 4);
insert into cfg_bonus_level (level_id, level_cnt) values (3, 5);
insert into cfg_bonus_level (level_id, level_cnt) values (4, 1);

insert into cfg_supp_staff_bonus values (201401, 4000353, 4000352, now(), 50, 30, 20);
create table qr_query_conf(priv_id int, class_name varchar(1024), class_desc varchar(4000))
default charset=utf8;

insert into qr_query_conf values (10000001, 'org.cola.admin.manage.UserPwdMgtImpl', '绩效互评');
insert into qr_query_conf values (20000001, 'org.cola.bonus.manage.BonusJudgeMgtImpl', '绩效互评');
insert into qr_query_conf values (20000002, 'org.cola.bonus.manage.BonusBatchJudgeMgtImpl', '绩效互评');

select t1.month_id 月份,
       t1.staff_id 工号,
       t2.staff_name 姓名,
       round(avg(t1.wld_score), 6) 工作量得分,
       round(avg(t1.dfc_score), 6) 难度得分,
       round(avg(t1.qua_score), 6) 完成质量得分,
       round(avg(t1.wld_score + t1.dfc_score + t1.qua_score), 6) 得分
  from cfg_supp_staff_bonus t1
  left join cfg_supp_staff_info t2
    on t2.staff_id = t1.staff_id
 where 1 = 1
   and t1.month_id = 201404
 group by t1.month_id, t1.staff_id, t2.staff_name
 order by t1.month_id, avg(t1.wld_score + t1.dfc_score + t1.qua_score) desc;

--结果排名
select t1.month_id 月份,
       t1.staff_id 工号,
       t3.staff_name 姓名,
       round(0.7 * ifnull(t1.avg_wld_score, 0) + 0.3 * ifnull(t2.avg_wld_score, 0), 6) 工作量得分,
       round(0.7 * ifnull(t1.avg_dfc_score, 0) + 0.3 * ifnull(t2.avg_dfc_score, 0), 6) 难度得分,
       round(0.7 * ifnull(t1.avg_qua_score, 0) + 0.3 * ifnull(t2.avg_qua_score, 0), 6) 完成质量得分,
       round(0.7 * ifnull(t1.avg_score, 0) + 0.3 * ifnull(t2.avg_score, 0), 6) 得分
  from (select t1.month_id,
               t1.staff_id,
               avg(t1.wld_score) avg_wld_score,
               avg(t1.dfc_score) avg_dfc_score,
               avg(t1.qua_score) avg_qua_score,
               avg(t1.wld_score + t1.dfc_score + t1.qua_score) avg_score
          from cfg_supp_staff_bonus t1, cfg_supp_staff_info t2
         where t1.staff_id = t2.staff_id
           and t1.month_id = 201404
           and t2.staff_type = 1
         group by t1.month_id, t1.staff_id) t1
  left join (select t1.month_id,
                    t1.staff_id,
                    avg(t1.wld_score) avg_wld_score,
                    avg(t1.dfc_score) avg_dfc_score,
                    avg(t1.qua_score) avg_qua_score,
                    avg(t1.wld_score + t1.dfc_score + t1.qua_score) avg_score
               from cfg_supp_staff_bonus t1, cfg_supp_staff_info t2
              where t1.staff_id = t2.staff_id
                and t1.month_id = 201404
                and t2.staff_type = 2
              group by t1.month_id, t1.staff_id) t2
    on t1.month_id = t2.month_id
   and t1.staff_id = t2.staff_id
  left join cfg_supp_staff_info t3
    on t1.staff_id = t3.staff_id
 order by round(0.7 * ifnull(t1.avg_score, 0) + 0.3 * ifnull(t2.avg_score, 0), 6) desc;
 
 select t1.month_id 月份,
       t1.staff_id 工号,
       t2.staff_name 姓名,
       round(sum(t1.avg_wld_score * t1.weight) / sum(t1.weight), 6) 工作量得分,
       round(sum(t1.avg_dfc_score * t1.weight) / sum(t1.weight), 6) 难度得分,
       round(sum(t1.avg_qua_score * t1.weight) / sum(t1.weight), 6) 完成质量得分,
       round(sum(t1.avg_score * t1.weight) / sum(t1.weight), 6) 得分
  from (select t1.month_id,
               t1.staff_id,
               if(t2.staff_type = 1, 0.7, 0.3) weight,
               avg(t1.wld_score) avg_wld_score,
               avg(t1.dfc_score) avg_dfc_score,
               avg(t1.qua_score) avg_qua_score,
               avg(t1.wld_score + t1.dfc_score + t1.qua_score) avg_score
          from cfg_supp_staff_bonus t1, cfg_supp_staff_info t2
         where t1.staff_id = t2.staff_id
           and t1.month_id = 201404
         group by t1.month_id, t1.staff_id, t2.staff_type) t1
  left join cfg_supp_staff_info t2
    on t1.staff_id = t2.staff_id
 group by t1.month_id, t1.staff_id, t2.staff_name
 order by t1.month_id, round(sum(t1.avg_score * t1.weight) / sum(t1.weight), 6) desc
