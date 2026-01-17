with qcinfo as (
    select * from {{ ref('innova_fbd__qcinfo') }}
),
images as (
    select * from {{ ref('innova_fbd__images') }}
),
lastday as (
    select
        images.qcs_dataaggimages_id,
        images.qcs_dataaggimages_dataagg,
        images.qcs_dataaggimages_image2dname,
        to_char(try_to_date(left(images.qcs_dataaggimages_image2dname, 8), 'yyyymmdd'), 'yyyy_mm_dd') as formatted_date,
        images.qcs_dataaggimages_image3dname,
        qcinfo.qcs_dataagg_device
    from images
    join qcinfo
        on qcinfo.qcs_dataagg_id = images.qcs_dataaggimages_dataagg
),
final as (
    select 
        qcs_dataaggimages_id,
        qcs_dataaggimages_dataagg,
        qcs_dataaggimages_image2dname,
        formatted_date,
        qcs_dataaggimages_image3dname,
        qcs_dataagg_device,

        --Please contact systems team to generate a new SAS token and store it in the project file. -- 
        {{ "'" ~ var('image_base_url') ~ "'"}} || '/Device' ||
        qcs_dataagg_device || '/' || 
        formatted_date || '/' || 
        qcs_dataaggimages_image2dname || '.jpg' || 
        {{ "'" ~ var('image_sas_token') ~ "'" }} as image_link

    from lastday
)

select * from final
