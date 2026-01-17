with main as (
    select
        form_name,
        created_date,
        executionid,
        parse_json(json_data) as json_data
    from {{ ref('stg_pronto__health_and_safety__raw') }}
    where form_name = 'Monthly Safety Inspection Checklist - SW Operations'
),

parsing as (
    select
        main.executionid,
        main.form_name as form_type,
        main.json_data:name::string as form_name,
        main.json_data:deviceSubmitDate.provided.time::timestamp_ntz as submitdate,
        main.created_date,
        answer.value:question::string as question,
        all_values.value::string as "value",
        main.json_data:"user":username::string as "login_name",
        to_char(main.created_date, 'MM-YYYY') as created_monthyear
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
        max(case when question = 'Supervisor / Manager:' then "value" end) as supervisor_manager,
        max(case when question = 'Site Location' then "value" end) as site_location,
        max(case when question = 'Inspection Completed By:' then "value" end) as inspection_completed_by,
        max(case when question = 'Date Of Inspection' then "value" end) as date_of_inspection,
        max(case when question = '1. Adequate lighting, heating, ventilation and plumbing fixtures' then "value" end) as q01_facility_conditions,
        max(case when question = '2.  Clear stairs with adequate handrails/guardrails and lighting' then "value" end) as q02_stair_safety,
        max(case when question = '3. Noise levels acceptable and employees wearing hearing protection (where applicable)' then "value" end)
            as q03_noise_levels,
        max(case when question = '4. Workstations and general areas free of debris' then "value" end) as q04_workstations_clear,
        max(case when question = '5. Decks and Floors clear of tripping or slipping hazards and obstructions' then "value" end) as q05_floors_safe,
        max(case when question = '6.  Smoking Areas designated and proper container for disposal of debris available.' then "value" end)
            as q06_smoking_area,
        max(
            case
                when
                    question
                    = '7. Extension cords in good operational condition with no frays or signs of 
                    wear and equipped with 3- prong plug for grounding. GFCI Protection (where applicable).'
                    then "value"
            end
        ) as q07_extension_cords,
        max(
            case
                when
                    question = '8. Power bars UL/CSA approved. No receptacle block adapters (office, building, shop, bridge, engine room etc.)'
                    then "value"
            end
        ) as q08_power_bars,
        max(case when question = '9. All exits/entrances marked and unobstructed. Exit signs and emergency lighting operational' then "value" end)
            as q09_exits_lit_and_clear,
        max(
            case
                when
                    question
                    = '10. Extinguishers clear, visible & operational. Visually inspected monthly and annually certified by an approved vendor'
                    then "value"
            end
        ) as q10_extinguishers_ok,
        max(case when question = 'Date of Expiry' then "value" end) as expiry_date_1,
        max(case when question = '11. Fire alarms in working order' then "value" end) as q11_fire_alarms,
        max(case when question = '12. Eyewash stations operable, maintained and accessible' then "value" end) as q12_eyewash_operable,
        max(case when question = '13. Life boats inspected annually and up to date on vessels as required .' then "value" end)
            as q13_lifeboats_inspected,
        max(case when question = '14. Adequate amount of life saving equipment based on number of crew on board' then "value" end)
            as q14_life_saving_equipment,
        max(case when question = '15. First Aid kits fully stocked with required supplies per provincial regulations' then "value" end)
            as q15_first_aid_kits,
        max(
            case
                when
                    question
                    = '16. Safety, operational and maintenance equipment and certifications required per 
                    size and classification of the vessel (PFD’s, life boat etc.) available.'
                    then "value"
            end
        ) as q16_certification_equipment_available,
        max(case when question = '17. Equipped with proper communications equipment (VHF radio, iPad, cell phone etc.)' then "value" end)
            as q17_comms_equipment,
        max(case when question = '18.    Adequate number of flares on board' then "value" end) as q18_flares_onboard,
        max(case when question = 'Expiry Date (Flares)' then "value" end) as expiry_date_flares,
        max(case when question = '19.  Adequate number of immersion suits on board' then "value" end) as q19_immersion_suits,
        max(case when question = 'How Many' then "value" end) as immersion_suits_count,
        max(case when question = '20.   AED charged and pads current' then "value" end) as q20_aed_status,
        max(case when question = 'Expiry Date (Pads) (If Applicable)' then "value" end) as expiry_date_pads,
        max(case when question = '18. Compliance to recycling/waste disposal methods' then "value" end) as q21_recycling_compliance,
        max(case when question = '19. Trash cans/dumpsters and general waste receptacles emptied regularly' then "value" end) as q22_waste_emptied,
        max(case when question = '20. Proper storage of flammable liquid/paints/gas/oil (room, cabinet, save-all, berm).' then "value" end)
            as q23_flammable_storage,
        max(case when question = '21. Adequate spill containment and spill response kits available (where applicable)' then "value" end)
            as q24_spill_kits_available,
        max(
            case
                when
                    question = '22. Proper containment with disposal procedure in place with no potential for hazardous environmental spill/leakage'
                    then "value"
            end
        ) as q25_containment_procedure,
        max(case when question = '23. Loads on pallets properly positioned on ground, cement pad, racks (where applicable)' then "value" end)
            as q26_pallet_positioning,
        max(case when question = '24. All containers/materials stable and 
        secure against sliding/collapsing' then "value" end) as q27_materials_stable,
        max(case when question = '25. Pallets and skids in good repair and utilized appropriately (where applicable)' then "value" end)
            as q28_pallets_condition,
        max(case when question = '26. Storage area clean and orderly; materials stored safely' then "value" end) as q29_storage_clean,
        max(case when question = '27. Adequate ventilation and storage for chemical storage' then "value" end) as q30_chemical_storage_ventilation,
        max(case when question = '28. Safety Management System Manual accessible and up to date' then "value" end) as q31_sms_manual,
        max(case when question = '29. Health and Safety policy posted' then "value" end) as q32_safety_policy_posted,
        max(
            case
                when
                    question
                    = '30. First Aiders list, Joint Occupational Health and Safety Committee (JHSC) members and minutes posted and accessible'
                    then "value"
            end
        ) as q33_jhsc_materials_posted,
        max(
            case
                when
                    question = '31. Employees trained in Emergency Response Procedures. Emergency Plan and Emergency Evacuation Plan available.'
                    then "value"
            end
        ) as q34_emergency_plan_training,
        max(case when question = '32. Emergency Drills conducted and documented at least annually.' then "value" end) as q35_emergency_drills,
        max(case when question = '33. Smoking/ Drug and Alcohol policies enforced' then "value" end) as q36_smoking_drug_policy,
        max(case when question = '34. Working alone policy understood (where applicable)' then "value" end) as q37_working_alone_policy,
        max(case when question = '35. Fall protection procedures followed  (where applicable)' then "value" end) as q38_fall_protection,
        max(case when question = '36. Confined space procedure followed (where applicable)' then "value" end) as q39_confined_space,
        max(case when question = '37. Hot Work Program followed (where applicable)' then "value" end) as q40_hot_work_program,
        max(case when question = '38. Adequate Machine/Equipment Guarding' then "value" end) as q41_machine_guarding,
        max(case when question = '39. Adequate Energy Isolation, Zero Energy State and Emergency Stop Functions-LOTO' then "value" end) as q42_loto,
        max(
            case
                when
                    question = '40. Scaffolding, ladders, step stools and platforms erected properly, secured and inspected (where applicable)'
                    then "value"
            end
        ) as q43_scaffolding_inspected,
        max(case when question = '41. Pre-Use inspections on mobile equipment ie: forklifts, pallet jacks' then "value" end)
            as q44_mobile_equipment_inspection,
        max(case when question = '42. Crane certifications and inspection logs with proper maintenance repair records' then "value" end)
            as q45_crane_certifications,
        max(case when question = '43. Forklift certifications and inspection logs with proper maintenance repair records' then "value" end)
            as q46_forklift_certifications,
        max(
            case
                when question = '44. Lifting Slings, chains and rigging hardware inspected and in proper condition (load certificates)' then "value"
            end
        ) as q47_rigging_hardware,
        max(case when question = '45. Properly tagged out of service for maintenance repair (as required)' then "value" end)
            as q48_tagged_out_equipment,
        max(case when question = '46. Guards in place and safety features operable; sharp tools/knives adequate for the job' then "value" end)
            as q49_guards_and_tools,
        max(case when question = '47. Load-rated and pneumatic tools used 
        according to manufacturer’s specs.' then "value" end) as q50_load_rated_tools,
        max(case when question = '48. 3-pronged plug and/or double insulated for proper grounding (where applicable)' then "value" end)
            as q51_proper_grounding,
        max(case when question = '49. Accessible up to date SDS’s' then "value" end) as q52_sds_accessible,
        max(case when question = '50. Cylinders capped, secured upright and stored in an adequate ventilated area' then "value" end)
            as q53_cylinders_secured,
        max(case when question = '51. Proper supplier and workplace labels' then "value" end) as q54_labels_proper,
        max(case when question = '52. Drums or tanks properly bonded and grounded (where applicable) with spill containment' then "value" end)
            as q55_drums_bonded,
        max(case when question = '53. PPE provided and worn as per chemical SDS or per job procedure (Lice Treatments)' then "value" end)
            as q56_ppe_provided,
        max(
            case
                when
                    question
                    = '54. Enforcement of PPE policy- hard hats, safety footwear, eye protection, hi-vis clothing . 
                    hearing protection, PFD’s and respiratory as required.'
                    then "value"
            end
        ) as q57_ppe_enforced,
        max(case when question = '55. Employee comfort recognized: (ie: drinking water, warm/cool area per climate conditions)' then "value" end)
            as q58_employee_comfort,
        max(case when question = '56. Adequate lunchroom, rest areas, washrooms, furniture and office equipment' then "value" end)
            as q59_lunchroom_facilities,
        max(case when question = '57. Certificates available for employees operating vessels, forklifts, crane etc.' then "value" end)
            as q60_certificates_available,
        max(case when question = 'Comments / Observations' then "value" end) as general_comments,
        max(case when question = 'Completed By:' then "value" end) as completed_by,
        max(case when question = 'Date Reviewed' then "value" end) as date_reviewed

    from parsing
    group by all
),

latest as (
    select *
    from pivoted
    qualify
        row_number() over (partition by company_division, site_location, submit_monthyear order by submitdate desc) = 1
)

select * from latest
