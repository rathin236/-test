with req as (
    select * from {{ ref('stg_erequester__requisition') }}
),
users as (
    select * from {{ ref('stg_erequester__user') }}
),
dept as (
    select * from {{ ref('stg_erequester__dept') }}
),
requisitiontype as (
    select * from {{ ref('stg_erequester__requisition_type') }}
),
status as (
    select * from {{ ref('stg_erequester__requisition_status') }}
),
company as (
    select * from {{ ref('stg_erequester__company') }}
),
requesttype as (
    select * from {{ ref('stg_erequester__request_type') }}
),
main as (
    select         
        m.requisitionid,
        m.qtyovertolerance,
        m.state,
        m.postheadernotes,
        m.city,
        m.justification,
        m.contactemail,
        m.notifyuponnonapproval,
        m.paidbycreditcard,
        m.invoicenumber,
        m.phone1,
        m.emreimbursetouserid,
        m.billtolocationid,
        m.locationid,
        m.freight,
        m.shippingccemails,
        m.importtypeid,
        m.datesubmitted,
        m.notifyuponapproval,
        m.contractnumber,
        m.address1,
        m.address4,
        m.userpo,
        m.originaluserid,
        m.budgeted,
        m.accountingsysteminvoicekey,
        m.contactfax,
        m.levelid,
        m.deleted,
        m.changeorderpoid,
        m.popostedby,
        concat(u.firstname,' ',u.lastname) as user_name,
        m.locationname,
        m.noreceiptnotify,
        m.proxynotified,
        m.notifyoncreatepo,
        m.overbudget,
        m.shipmethodid,
        m.ponumber,
        m.dateapproved,
        m.targetcompany,
        m.popostdate,
        m.billtolocationname,
        m.phone2,
        d.description as dept,
        m.projectid,
        m.invoicedate,
        m.address2,
        m.approvallocation,
        m.canpostpostatus,
        m.expensereport,
        m.notifyproxyapprover,
        m.templatetypeid,
        m.poid,
        m.contractreminddate,
        m.pocanceldate,
        m.userrq,
        m.notes,
        m.contractexpiredate,
        m.pototalcostovertolerance,
        m.noticecontractexpdate,
        m.memo,
        m.preapprovalrequest,
        m.accountingsysteminvoicepostedby,
        m.batchid,
        rt.description as requisitiontype,
        m.capitalprojectid,
        m.contactphone,
        m.resubmitstatusid,
        m.commentkey,
        m.receiptid,
        s.description as status,
        c.companyname as company,
        m.discountrateid,
        m.lastnonapprovenote,
        m.matchreceiptid,
        m.lastnonreceiptnote,
        m.fob,
        m.routingseqid,
        m.contactname,
        m.purchasereason,
        m.changeorderponumber,
        m.matchpoid,
        m.costovertolerance,
        m.address3,
        m.receivewhenposted,
        m.taxinclusive,
        m.poformid,
        m.retentionpercent,
        m.zip,
        m.assignedtobuyerid,
        m.title,
        m.daterequested,
        m.shippingcomments,
        reqt.description as requesttype,
        m.country
    from req m

    left join users u 
    on u.userid = m.userid

    left join dept d
    on d.deptid = m.deptid
    and d.companyid = m.companyid

    left join requisitiontype rt
    on rt.requisitiontypeid = m.requisitiontypeid

    left join status s
    on s.requisitionstatusid = m.statusid

    left join company c
    on c.companyid = m.companyid

    left join requesttype reqt
    on reqt.requesttypeid = m.requesttypeid
)
select * from main 
