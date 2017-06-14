with
recommend_target_items as (
    select log.USER_ID, SIM_ITEM_ID as ITEM_ID, ${SIMILARITY_TYPE} as SIMILARITY
    from SHOPPING_LOG log
    inner join ITEM_ITEM_SIMILARITY sim on (log.ITEM_ID = sim.ITEM_ID)
)

recommend_items as (
    select distinct
        max_log.USER_ID,
        avg_sum_log.ITEM_ID,
        MAX_SIMILARITY, 
        AVG_SIMILARITY, 
        SUM_SIMILARITY
    from (
        select USER_ID, ITEM_ID, SIMILARITY as MAX_SIMILARITY
        from (
            select ROW_NUMBER() over (partition by USER_ID, ITEM_ID order by SIMILARITY desc) as RANK, items.*
            from recommend_target_items items
        ) as log
        where RANK = 1
    ) as max_log
    inner join (
        select USER_ID, ITEM_ID, avg(SIMILARITY) as AVG_SIMILARITY, sum(SIMILARITY) as SUM_SIMILARITY
        from recommend_target_items
        group by USER_ID, ITEM_ID
   ) as avg_sum_log on (max_log.USER_ID = avg_sum_log.USER_ID and max_log.ITEM_ID = avg_sum_log.ITEM_ID)
)
	
select USER_ID, ITEM_ID, RANK
from (
    select ROW_NUMBER() over (partition by USER_ID order by ${SORT_BY_TYPE} desc) as RANK, items.*
    from recommend_items items
) as recommend_rank
where RANK <= ${TOPN}
order by USER_ID, ITEM_ID, RANK
