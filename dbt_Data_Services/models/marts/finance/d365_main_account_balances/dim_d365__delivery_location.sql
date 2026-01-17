with final as (
        select
            *
            -- cust_account_number as sk_cust_id,
            -- company,
            -- cust_account_number,
            -- party_name,
            -- invoice_account_number,
            -- custgroup,
            -- isprimary,
            -- isrolebusiness,
            -- isroledelivery,
            -- isroleinvoice,
            -- isrolehome,

            -- -- Primary Address
            -- primary_add,
            -- primary_street,
            -- primary_city,
            -- primary_state,
            -- primary_country,

            -- -- Delivery Address (Fill with Primary if Blank)
            -- coalesce(delivery_add, primary_add) as delivery_add,
            -- coalesce(delivery_street, primary_street) as delivery_street,
            -- coalesce(delivery_city, primary_city) as delivery_city,
            -- coalesce(delivery_state, primary_state) as delivery_state,
            -- coalesce(delivery_country, primary_country) as delivery_country,

            -- -- Invoice Address (Remains the same)
            -- invoice_add,
            -- invoice_street,
            -- invoice_city,
            -- invoice_state,
            -- invoice_country
        from {{ ref("int_d365__delivery_location") }}
    )
select * from final
-- where sk_cust_id = '5637150670'