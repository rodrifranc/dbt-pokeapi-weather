# 🚀 Pipeline ELT Moderno: Integración de APIs con dbt y MotherDuck

Este repositorio contiene un proyecto práctico de Ingeniería de Datos desarrollado como parte de la Maestría en Inteligencia Artificial y Análisis de Datos. Implementa una arquitectura ELT (Extract, Load, Transform) end-to-end utilizando herramientas del *Modern Data Stack*.

El objetivo principal del proyecto es extraer información de dos APIs distintas, unificarla en un Data Warehouse columnar en la nube y aplicar transformaciones, modelado dimensional (One Big Table) y rigurosos controles de calidad de datos.

### DAG´s requeridos para las tareas en adjunto
- Dbt project.PNG es de la tarea 5
- DBT project con test.PNG es de la tarea 6

## 🛠️ Stack Tecnológico

* **Extracción y Carga (EL):** [Airbyte](https://airbyte.com/) (Desplegado localmente vía Docker).
* **Data Warehouse:** [MotherDuck](https://motherduck.com/) / DuckDB (Motor OLAP columnar serverless).
* **Transformación y Modelado (T):** [dbt Core](https://www.getdbt.com/) (Data Build Tool).
* **Control de Versiones:** Git & GitHub.

## 📡 Fuentes de Datos (Sources)

Se ingesta información en formato crudo (JSON) desde dos fuentes externas hacia el esquema `raw` de la base de datos:
1. **PokeAPI:** Información estática sobre características físicas, tipos y estadísticas base de personajes.
2. **OpenWeather (Onecall API):** Telemetría de clima actual (latitud, longitud, zona horaria, temperatura) simulando un flujo de datos de series temporales.

## 🏗️ Arquitectura de Modelado de Datos

El proyecto dbt está estructurado en tres capas lógicas para garantizar la modularidad y el linaje de los datos:

* **`staging/` (Capa de Preparación):** * Modelos: `stg_pokemon` y `stg_openweather`.
  * Función: Limpieza de datos crudos, estandarización de nombres de columnas y **deduplicación** de registros anómalos (implementado mediante funciones de ventana `ROW_NUMBER()`).
* **`intermediate/` (Capa Intermedia):** * Función: Desanidado de estructuras JSON complejas (arrays de tipos) y preparación de entidades para los cruces finales.
* **`marts/` (Capa de Consumo):** * Modelo: `obt_pokemon`.
  * Función: Implementación del patrón **One Big Table (OBT)**. Cruza la información estática con los datos telemétricos, generando una tabla ancha desnormalizada altamente optimizada para el consumo en herramientas de Business Intelligence (BI).

## 🛡️ Calidad de Datos y Testing

Para evitar el problema de "Garbage In, Garbage Out", el pipeline cuenta con una suite de pruebas automatizadas, asegurando la fiabilidad de la capa analítica:

* **Tests Genéricos (Nativos de dbt):** Control de llaves primarias (`unique`, `not_null`) y validación de dominios categóricos (`accepted_values` para jerarquías de poder).
* **Tests Avanzados (`dbt-expectations`):** * Validación de completitud (conteo de filas esperadas).
  * Validación de formatos mediante expresiones regulares (Regex) para nombres.
  * Comprobación de rangos de distribución lógica numérica (experiencia base).
* **Tests Singulares (Reglas de Negocio):**
  * `assert_pokemon_positive_stats`: Falla si detecta anomalías físicas (pesos o alturas negativas).
  * `assert_legendary_high_experience`: Audita que ningún ente clasificado como "Legendario" infrinja el umbral mínimo de experiencia base predefinido.

## 📊 Documentación y Linaje

El proyecto incluye documentación auto-generada mediante dbt, incluyendo descripciones a nivel de columna y el Grafo Acíclico Dirigido (DAG) interactivo, permitiendo una trazabilidad completa del dato desde la API de origen hasta el modelo de consumo final, incluyendo los nodos de testing asociados.



