with source as (

    select * from {{ source('raw_bronze', 'olist_orders_dataset') }}

),

renamed as (

    select
        order_id::varchar as order_id,
        customer_id::varchar as customer_id,
        order_status::varchar as order_status,
        order_purchase_timestamp::timestamp_ntz as order_purchase_timestamp,
        order_approved_at::timestamp_ntz as order_approved_at,
        order_delivered_carrier_date::timestamp_ntz as order_delivered_carrier_date,
        order_delivered_customer_date::timestamp_ntz as order_delivered_customer_date,
        order_estimated_delivery_date::timestamp_ntz as order_estimated_delivery_date

    from source
    qualify row_number() over (
        partition by order_id
        order by order_purchase_timestamp desc
    ) = 1

)

select * from renamed
