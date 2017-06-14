## Item based collaborative filtering recommendation system

### Requirements

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
ITEM_ITEM_SIMILARITY (
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

### Similarity Types

* JACCARD

![Alt text](/docs/img/JACCARD.jpg)

* COSINE

![Alt text](/docs/img/COSINE.jpg)

* SIMPSON

![Alt text](/docs/img/SIMPSON.jpg)

* CONFIDENCE

![Alt text](/docs/img/CONFIDENCE.jpg)

* IMPROVE

![Alt text](/docs/img/IMPROVE.jpg)

### Using ItemBasedCF

* you should fix the syntax error according to your database environment before execute the SQL files.
* execute Calculate_Item_Item_Similarity.sql to calculate Item-Item‘s similarity
* execute ItemBasedCFRecommend.sql to recommend
