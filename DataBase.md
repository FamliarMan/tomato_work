# 本地数据库设计

任务表 TaskInfo

|字段|属性|备注|
|---|---|----|
|id | INTEGER| 主键，自增长|
| name | varchar(100) | 任务名称，不为空|
| status | int | 任务状态，0-未开始，1-开始但未结束，2-结束,默认0|
| estimatedDuration| INTEGER | 预计时长， 单位分钟,not null|
| realDuration| INTEGER | 实际时长，可以为空|
| startTime| INTEGER | 任务开始时间，可以为null|
| createTime| INTEGER| 任务创建时间，时间戳，不为空|


番茄表 TomatoInfo

|字段|属性|备注|
|---|---|----|
|id | INTEGER| 主键，自增长|
| status| INTEGER| 番茄状态，0-已完成，1-废弃，not null|
|duration|INTEGER | 番茄持续时间，配置中可以修改，所以需要记录，不为空 | 
| createTime| INTEGER| 番茄创建时间，时间戳，不为空|



