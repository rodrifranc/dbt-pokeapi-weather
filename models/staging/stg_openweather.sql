WITH source AS (
    SELECT * FROM {{ source('raw', 'onecall') }}
),
renamed AS (
    SELECT
        lat AS latitud,
        lon AS longitud,
        timezone AS zona_horaria,
        current, -- Aquí viene el JSON complejo con la temperatura actual
        _airbyte_extracted_at AS loaded_at
    FROM source
)

SELECT * FROM renamed