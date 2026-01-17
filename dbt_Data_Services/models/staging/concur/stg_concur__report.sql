with

source as (

    select * from {{ source('concur', 'report') }}

),

renamed as (

    select
        id,
        last_modified_date,
        submit_date,
        approver_login_id,
        receipts_received,
        create_date,
        name,
        currency_code,
        total_claimed_amount,
        last_comment,
        ledger_name,
        payment_status_name,
        policy_id,
        workflow_action_url,
        owner_login_id,
        amount_due_company_card,
        has_exception,
        country_subdivision,
        ever_sent_back,
        processing_payment_date,
        country,
        total_approved_amount,
        owner_name,
        paid_date,
        approver_name,
        approval_status_name,
        user_defined_date,
        personal_amount,
        total,
        amount_due_employee
    from source
    where approval_status_name not in ('Sent Back to Employee')
        and ledger_name in ('NA')
        and owner_name not in (
            'Glenn Cooke',
            'Pam Cooke',
            'Mike Cooke',
            'Star Cooke',
            'Bethany Cooke',
            'Brett J Cooke',
            'William Cooke',
            'Allison Cooke',
            'Debbie Szemerda',
            'Michael Szemerda',
            'James Trask',
            'Seth Dunlop',
            'Len Stewart',
            'Peter Buck',
            'Kris Nicholls',
            'Adam Todd',
            'Bret Scholes',
            'Catherine McBride',
            'Corey MacKinnon',
            'Dwayne Stoddart',
            'Jaime Montesinos',
            'Joel Richardson',
            'Ross Butler',
            'Shannon Sears',
            'Montgomery Deihl',
            'Alistair Walsh'
        )
)

select * from renamed
