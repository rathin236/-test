with images as (
    select
        id as qcs_dataaggimages_id,
        dataagg as qcs_dataaggimages_dataagg,
        image2dname as qcs_dataaggimages_image2dname,
        image3dname as qcs_dataaggimages_image3dname
    from {{ ref('stg_innova_fbdag__qcs_dataaggimages') }}
)

select * from images
