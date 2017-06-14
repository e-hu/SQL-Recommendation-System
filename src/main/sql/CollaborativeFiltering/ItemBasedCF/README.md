## Item based collaborative filtering recommendation system

### Environment

#### Execute

> Spark 2.1.1 SparkSQL

#### Table

* SHOPPING_LOG
<pre><code>
SHOPPING_LOG (
    USER_ID Int,
    ITEM_ID Int,
    LOG_DATE Timestamp
)
</code></pre>

* ITEM_ITEM_SIMILARITY
<pre><code>
SHOPPING_LOG (
    ITEM_ID Int,
    SIM_ITEM_ID Int,
    ITEM_UU Int,
    SIM_ITEM_UU Int,
    ITEM_COMMON_UU Int,
    JACCARD Decimal,
    COSINE Decimal,
    SIMPSON Decimal,
    CONFIDENCE Decimal,
    IMPROVE Decimal
)
</code></pre>


