CREATE OR REPLACE VIEW TOPBOOKEDPROPERTIES AS
    SELECT
        T.PRP_ID,
        T.PRP_TITLE,
        T.PRICE_PER_NIGHT,
        T.MAX_GUESTS,
        T.PROPERTY_OWNER,
        T.TOTAL_BOOKINGS
    FROM
        (
            SELECT
                PK.PRP_ID,
                PK.PRP_TITLE,
                PK.PRICE_PER_NIGHT,
                PK.MAX_GUESTS,
                PO.PO_NAME         AS PROPERTY_OWNER,
                COUNT(BK.BK_ID)    AS TOTAL_BOOKINGS
            FROM
                PROPERTY      PK
                JOIN PROPERTYOWNER PO
                ON PK.PO_ID = PO.PO_ID LEFT JOIN BOOKING BK
                ON PK.PRP_ID = BK.PRP_ID
            GROUP BY
                PK.PRP_ID,
                PK.PRP_TITLE,
                PK.PRICE_PER_NIGHT,
                PK.MAX_GUESTS,
                PO.PO_NAME
            ORDER BY
                TOTAL_BOOKINGS DESC
        ) T
    WHERE
        ROWNUM <= 10;

SELECT
    *
FROM
    TOPBOOKEDPROPERTIES;