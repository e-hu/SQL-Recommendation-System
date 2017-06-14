insert into ITEM_ITEM_SIMILARITY 

with
target_log_data as (
    select *
    from SHOPPING_LOG
    where LOG_DATE >= '${CALCULATE_START_DATE}'
),
user_purchased_item_cnt as (
    select USER_ID, count(distinct ITEM_ID) CNT
    from target_log_data
    group by USER_ID
),
item_be_purchased_user_cnt as (
    select ITEM_ID, count(distinct USER_ID) CNT
    from target_log_data
    group by ITEM_ID
),
temp_similarity as (
    select ITEM_ID, SIM_ITEM_ID, count(distinct USER_ID) as ITEM_COMMON_UU, sum(USER_LOG_VALUE) as TOTAL_USER_LOG_VALUE
    from (
        select A.ITEM_ID, B.ITEM_ID as SIM_ITEM_ID, A.USER_ID, CAST(1 AS DECIMAL) / log(1 + CNT) as USER_LOG_VALUE
        from target_log_data as A
        join target_log_data as B on (A.ITEM_ID != B.ITEM_ID and A.USER_ID = B.USER_ID)
        join user_purchased_item_cnt upi_cnt on A.USER_ID = upi_cnt.USER_ID
    ) as item_log
    group by ITEM_ID, SIM_ITEM_ID
)

select
    temp.ITEM_ID,
    SIM_ITEM_ID,
    item_cnt.CNT     as ITEM_UU,
    sim_item_cnt.CNT as SIM_ITEM_UU,
    ITEM_COMMON_UU,
    CAST(ITEM_COMMON_UU AS DECIMAL) / (item_cnt.CNT + sim_item_cnt.CNT - ITEM_COMMON_UU)                                       as JACCARD,
    CAST(ITEM_COMMON_UU AS DECIMAL) / sqrt(item_cnt.CNT * sim_item_cnt.CNT)                                                    as COSINE,
    CAST(ITEM_COMMON_UU AS DECIMAL) / case when item_cnt.CNT < sim_item_cnt.CNT then item_cnt.CNT else sim_item_cnt.CNT end as SIMPSON,
    CAST(ITEM_COMMON_UU AS DECIMAL) / item_cnt.CNT                                                                             as CONFIDENCE,
    CAST(TOTAL_USER_LOG_VALUE as DECIMAL) / sqrt(item_cnt.CNT * sim_item_cnt.CNT)                                              as IMPROVE
from temp_similarity as temp
join item_be_purchased_user_cnt as item_cnt     on (temp.ITEM_ID = item_cnt.ITEM_ID)
join item_be_purchased_user_cnt as sim_item_cnt on (temp.SIM_ITEM_ID = sim_item_cnt.ITEM_ID)
order by ITEM_ID, SIM_ITEM_ID
