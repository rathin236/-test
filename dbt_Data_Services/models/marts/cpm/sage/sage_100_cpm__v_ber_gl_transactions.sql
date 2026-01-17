with unn as (

    select
        company,
        transaction_date,
        period,
        journal_entry_number,
        account_number,
        main_account_number,
        sub_account,
        detail,
        account_description,
        sub_account_description,
        detail_description,
        debitamount,
        creditamount,
        postingcomment,
        originating_document_number,
        originating_id,
        originating_name
    from {{ ref('int_sage_100_ber__cpm_beginning_balance') }}

    union all

    select
        company,
        transaction_date,
        period,
        journal_entry_number,
        account_number,
        main_account_number,
        sub_account,
        detail,
        account_description,
        sub_account_description,
        detail_description,
        debitamount,
        creditamount,
        postingcomment,
        originating_document_number,
        originating_id,
        originating_name
    from {{ ref('int_sage_100_ber__cpm_transactions') }}

),

seq as (

    select
        unn.*,

        row_number() over (
            partition by
                unn.company,
                unn.transaction_date,
                unn.journal_entry_number,
                unn.account_number,
                (unn.debitamount + unn.creditamount)
            order by
                unn.originating_document_number,
                unn.originating_id,
                unn.postingcomment,
                unn.main_account_number,
                unn.sub_account,
                unn.detail
        ) as record_sequence

    from unn

)

select
    seq.*,

    {{ dbt_utils.generate_surrogate_key([
        'transaction_date',
        'journal_entry_number',
        'account_number',
        'to_varchar(debitamount + creditamount)',
        'to_varchar(record_sequence)'
    ]) }} as surrogate_key

from seq
