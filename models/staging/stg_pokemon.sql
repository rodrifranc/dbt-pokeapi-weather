WITH source AS (
    SELECT * FROM {{ source('raw', 'pokemon') }}
),
-- Creamos un paso intermedio para enumerar duplicados
deduplicated AS (
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY id ORDER BY _airbyte_extracted_at DESC) as rn
    FROM source
),
renamed AS (
    SELECT
        id AS pokemon_id,
        name AS pokemon_name,
        height,
        weight,
        base_experience,
        types,
        _airbyte_extracted_at AS loaded_at
    FROM deduplicated
    WHERE rn = 1 -- ¡Aquí filtramos y eliminamos los clones!
)

SELECT 
    pokemon_id,
    pokemon_name,
    height,
    weight,
    base_experience,
    types,
    loaded_at
FROM renamed