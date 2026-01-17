with main as (
    select
        form_name,
        created_date,
        executionid,
        parse_json(json_data) as json_data
    from {{ ref('stg_pronto__health_and_safety__raw') }}
    where form_name = 'Field Level Hazard Assessment'
),

parsing as (
    select
        main.executionid,
        main.created_date,
        main.form_name as form_type,
        main.json_data:"name"::string as form_name,
        main.json_data:"deviceSubmitDate":"provided":"time"::timestamp_ntz as submitdate,
        answer.value:question::string as question,
        all_values.value::string as "value",
        main.json_data:user:"username"::string as "login_name"
    from main,
        lateral flatten(input => main.json_data:pages) as page,
        lateral flatten(input => page.value:sections) as section,
        lateral flatten(input => section.value:answers) as answer,
        lateral flatten(input => answer.value:values) as all_values
),

pivoted as (
    select
        executionid,
        form_name,
        created_date,
        submitdate,
        "login_name",
        to_char(submitdate, 'MM-YYYY') as submit_monthyear,
        max(case when question = 'Company / Division' then "value" end) as company_division,
        max(case when question = 'Supervisor / Manager' then "value" end) as supervisor_manager,
        max(case when question = 'Vessel' then "value" end) as vessel,
        max(case when question = 'Completed By' then "value" end) as completed_by,
        max(case when question = 'Date:' then "value" end) as response_date,
        max(case when question = 'Muster Point:' then "value" end) as muster_point,
        max(case when question = '1. Work Area Clean / Housekeeping' then "value" end) as q01_work_area_clean,
        max(case when question = '2. Material Storage Identified' then "value" end) as q02_material_storage,
        max(case when question = '3. Dust / Mist / Fumes' then "value" end) as q03_dust_mist_fumes,
        max(case when question = '4. Noise in Area' then "value" end) as q04_noise_area,
        max(case when question = '5. Extreme Temperatures' then "value" end) as q05_extreme_temperatures,
        max(case when question = '6. Spill Potential' then "value" end) as q06_spill_potential,
        max(case when question = '7. Waste Properly Managed' then "value" end) as q07_waste_managed,
        max(case when question = '8. Excavation Permit Required' then "value" end) as q08_excavation_permit,
        max(case when question = '9. Other Workers in Area' then "value" end) as q09_other_workers,
        max(case when question = '10. Weather Conditions' then "value" end) as q10_weather_conditions,
        max(case when question = '11. MSDS Reviewed' then "value" end) as q11_msds_reviewed,
        max(case when question = '12. Awkward Body Position' then "value" end) as q12_awkward_position,
        max(case when question = '13. Over Extension' then "value" end) as q13_over_extension,
        max(case when question = '14. Prolonged Twistion / Bending Motion' then "value" end) as q14_twisting_bending,
        max(case when question = '15. Working in Tight Area' then "value" end) as q15_tight_area,
        max(case when question = '16. Lift Too Heavy / Awkward to Lift' then "value" end) as q16_lift_heavy_awkward,
        max(case when question = '17. Hands Not in Line Of Sight' then "value" end) as q17_hands_not_visible,
        max(case when question = '18. Working Above your Head' then "value" end) as q18_working_above_head,
        max(case when question = '19. Site Access / Road Conditions' then "value" end) as q19_site_access,
        max(case when question = '20. Scaffold (Inspected & Tagged)' then "value" end) as q20_scaffold_inspected,
        max(case when question = '21. Ladders (tied off)' then "value" end) as q21_ladders_tied_off,
        max(case when question = '22. Slips / Trips' then "value" end) as q22_slips_trips,
        max(case when question = '23. Hoisting (tools, equipment, etc.)' then "value" end) as q23_hoisting,
        max(case when question = '24. Excavation (alarms, routes, ph.#)' then "value" end) as q24_excavation_routes,
        max(case when question = '25. Confined Space Entry Permit Required' then "value" end) as q25_confined_space,
        max(case when question = '26. Barricades & Signs in Place' then "value" end) as q26_barricades_signs,
        max(case when question = '27. Hole Coverings Identified' then "value" end) as q27_hole_coverings,
        max(case when question = '28. Trenching / Underground Structures' then "value" end) as q28_trenching_structures,
        max(case when question = '29. Rig Guide Lines' then "value" end) as q29_rig_guidelines,
        max(case when question = '30. Power Lines' then "value" end) as q30_power_lines,
        max(case when question = '31. Falling Items' then "value" end) as q31_falling_items,
        max(case when question = '32. Hoisting or Moving Loads Overhead' then "value" end) as q32_hoisting_overhead,
        max(case when question = '33. Proper Tools For The Job' then "value" end) as q33_proper_tools,
        max(case when question = '34. Equipment / Tools Inspected' then "value" end) as q34_equipment_inspected,
        max(case when question = '35. Tank Plumbing' then "value" end) as q35_tank_plumbing,
        max(case when question = '36. Hoses Inspected' then "value" end) as q36_hoses_inspected,
        max(case when question = '37. High Pressure' then "value" end) as q37_high_pressure,
        max(case when question = '38. High Temperature Fluids' then "value" end) as q38_high_temp_fluids,
        max(case when question = '39. Procedure Not Available for Task' then "value" end) as q39_no_procedure,
        max(case when question = '40. Confusing Instructions' then "value" end) as q40_confusing_instructions,
        max(case when question = '41. No Training For Task or Tools to be used' then "value" end) as q41_no_training,
        max(case when question = '42. First Time Performing the Task' then "value" end) as q42_first_time,
        max(case when question = '43. Working Alone' then "value" end) as q43_working_alone,
        max(case when question = '44. PPE Inspected / Used Properly' then "value" end) as q44_ppe_inspected,
        max(case when question = '45. Communtications Plan' then "value" end) as q45_communications_plan,
        max(case when question = '46. Other Hazard' then "value" end) as q46_other_hazard_1,
        max(case when question = '47. Other Hazard' then "value" end) as q47_other_hazard_2,
        max(case when question = '48. Other Hazard' then "value" end) as q48_other_hazard_3,
        max(case when question = '49. Other Hazard' then "value" end) as q49_other_hazard_4,
        max(case when question = 'Has A Pre-Use Inspection of Tools / Equipment Been Completed?' then "value" end) as preuse_inspection_done,
        max(case when question = 'Is The Worker Working Alone?' then "value" end) as is_worker_alone,
        max(case when question = 'If YES Explain:' then "value" end) as explain_if_alone,
        max(case when question = 'Are All Permit(s) Closed Out?' then "value" end) as permits_closed_out,
        max(case when question = 'Are There Hazards Remaining?' then "value" end) as hazards_remaining,
        max(case when question = 'If YES Explain:' then "value" end) as explain_hazards_remaining,
        max(case when question = 'Are There Any Incidents / Injuries?' then "value" end) as incidents_or_injuries,
        max(case when question = 'If YES Explain:' then "value" end) as explain_incidents_injuries,
        max(case when question = 'Was The Area Cleaned Up at End of Job / Shift?' then "value" end) as area_cleaned_after_shift,
        max(case when question = 'Worker Name' then "value" end) as worker_name_1,
        max(case when question = 'Worker Name' then "value" end) as worker_name_2,
        max(case when question = 'Worker Name' then "value" end) as worker_name_3,
        max(case when question = 'Worker Name' then "value" end) as worker_name_4
    from parsing
    group by executionid, form_name, created_date, submitdate, "login_name"
),

latest as (
    select * from pivoted
    qualify row_number() over (
        partition by company_division, vessel, submit_monthyear
        order by submitdate desc
    ) = 1
)

select * from latest
