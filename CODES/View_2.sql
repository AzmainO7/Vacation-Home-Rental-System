CREATE OR REPLACE VIEW TOP5PRICEDPROPERTIES AS
    SELECT
        *
    FROM
        (
            SELECT
                PK.PRP_ID,
                PK.PRP_TITLE,
                PK.PRICE_PER_NIGHT,
                PK.MAX_GUESTS,
                PO.PO_NAME         AS PROPERTY_OWNER
            FROM
                PROPERTY      PK
                JOIN PROPERTYOWNER PO
                ON PK.PO_ID = PO.PO_ID
            ORDER BY
                PK.PRICE_PER_NIGHT DESC
        )
    WHERE
        ROWNUM <= 5;

SELECT
    *
FROM
    TOP5PRICEDPROPERTIES;