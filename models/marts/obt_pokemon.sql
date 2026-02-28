-- One Big Table final: Une Pokémon con el contexto del clima
WITH pokemon AS (
    SELECT * FROM {{ ref('int_pokemon_with_types') }}
),
weather AS (
    -- Tomamos solo el último registro del clima extraído para no duplicar filas
    SELECT 
        zona_horaria,
        latitud,
        longitud
    FROM {{ ref('stg_openweather') }}
    ORDER BY loaded_at DESC
    LIMIT 1
),
final AS (
    SELECT 
        p.pokemon_id,
        p.pokemon_name,
        p.height,
        p.weight,
        p.base_experience,
        p.type_primary,
        p.type_secondary,
        CASE
            WHEN p.base_experience >= 200 THEN 'Legendary'
            WHEN p.base_experience >= 100 THEN 'Strong'
            ELSE 'Normal'
        END AS power_tier,
        -- Traemos las columnas del clima
        w.zona_horaria AS clima_zona_horaria,
        w.latitud AS clima_latitud,
        w.longitud AS clima_longitud
    FROM pokemon p
    CROSS JOIN weather w
)

SELECT * FROM final