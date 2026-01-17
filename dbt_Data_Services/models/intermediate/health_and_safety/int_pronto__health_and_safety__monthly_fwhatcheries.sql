with main as (
    select
        form_name,
        created_date,
        executionid,
        parse_json(json_data) as json_data
    from {{ ref('stg_pronto__health_and_safety__raw') }}
    where form_name = 'Monthly Safety Inspection Checklist - Freshwater Hatcheries'
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
        main.json_data:user:username::string as "login_name",
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
        max(case when question = 'Location' then "value" end) as "location",
        max(case when question = 'Supervisor/Manager' then "value" end) as supervisor_manager,
        max(case when question = 'Hatchery Name' then "value" end) as hatchery_name,
        max(case when question = 'Inspection Completed By:' then "value" end) as inspection_completed_by,
        max(case when question = 'Date of Inspection' then "value" end) as date_of_inspection,
        max(case when question = 'Meets Requirements: (Y) Yes OR (N) No OR (NA) Not Applicable' then "value" end) as meets_requirements_1,
        max(case when question = 'Housekeeping. Area free of Debris with No Tripping Hazards.' then "value" end) as housekeeping_area_clear,
        max(case when question = 'Employee comfort recognized: (drinking water, warm/cool area per climate conditions).' then "value" end)
            as employee_comfort,
        max(case when question = 'Adequate lunchroom, rest areas, 
        washrooms, furniture and office equipment.' then "value" end) as lunchroom_facilities,
        max(case when question = 'Exits/Entrances marked and unobstructed.' then "value" end) as exits_marked,
        max(case when question = 'Exit signs and emergency lights operational.' then "value" end) as exit_signs_operational,
        max(case when question = 'Fire Extinguishers visable/unobstructed. Operational & inspected monthly/yearly.' then "value" end)
            as fire_extinguishers_operational,
        max(case when question = 'Pull stations, sprinkler system, 18” clearance to sprinkler heads/hose cabinets unobstructed.' then "value" end)
            as sprinkler_clearance,
        max(
            case
                when
                    question = 'Eyewash stations & showers maintained and accessible w/15 minute flushing capability and inspected monthly.'
                    then "value"
            end
        ) as eyewash_accessible,
        max(case when question = 'First Aid Kits stocked. AED operational. First Aiders list posted.' then "value" end) as first_aid_kits,
        max(case when question = 'Updated SMS Program Manual accessible.' then "value" end) as sms_manual_accessible,
        max(case when question = 'Health & Safety policy posted and current.' then "value" end) as health_safety_policy,
        max(case when question = 'JHSC Members list and up to date Meeting Minutes posted.' then "value" end) as jhsc_list_minutes,
        max(case when question = 'Emergency Response Plan posted. Muster Station identified.' then "value" end) as emergency_plan_muster_station,
        max(
            case
                when question = 'Appropriate PPE available when required (respirator, safety glasses, 
                footwear, high vis vest, hard hat).' then "value"
            end
        ) as ppe_available,
        max(case when question = 'PPE Policy in Place and ignage posted.' then "value" end) as ppe_policy_signage,
        max(case when question = 'Up to Date Safety Data Sheets (SDS) and accessible.' then "value" end) as sds_accessible,
        max(case when question = 'Cylinders capped, secured upright and stored in an adequate, ventilated area.' then "value" end)
            as cylinders_stored_safely,
        max(case when question = 'Proper supplier and workplace labels.' then "value" end) as proper_labels,
        max(case when question = 'Drums or Tanks properly bonded and grounded (if applicable) with spill containment.' then "value" end)
            as drums_grounded,
        max(case when question = 'Proper containers for recycling, waste disposal. Emptied regularly, not overflowing.' then "value" end)
            as waste_disposal_proper,
        max(case when question = 'Hazardous Waste Program in place.' then "value" end) as hazardous_waste_program,
        max(case when question = 'Spill Response Kit(s) available (if applicable).' then "value" end) as spill_kit_available,
        max(
            case
                when
                    question = 'Fluorescent bulbs stored in proper container safely to avoid breakage. Disposed of properly. (if applicable)'
                    then "value"
            end
        ) as fluorescent_bulbs_handled,
        max(case when question = 'Adequate lighting, heating, ventilation and plumbing fixtures.' then "value" end) as facility_conditions,
        max(
            case
                when
                    question = 'Windows, doors and fire doors are operational (including O/H and large swinging doors properly maintained).'
                    then "value"
            end
        ) as windows_doors_operational,
        max(case when question = 'Clear stairs with adequate handrails, guardrails and lighting.' then "value" end) as stairs_safety,
        max(case when question = 'Site Security and Safety Signage (fencing, barricades, speed limit).' then "value" end) as site_security_signage,
        max(case when question = 'Ensure clear route to and from buildings/site for emergency vehicles.' then "value" end) as emergency_route_clear,
        max(
            case
                when question = 'Yards have proper signage for vehicle/people movement. Grounds, yard and travel areas level and firm.' then "value"
            end
        ) as yard_signage,
        max(case when question = 'Downstream Sampling Trail clear and accessible (if applicable)' then "value" end) as downstream_trail_accessible,
        max(case when question = 'Guards in place and safety features operable; sharp tools/knives adequate for the job.' then "value" end)
            as safety_guards_tools,
        max(case when question = 'Load rated and pneumatic tools used according to manufacturer specs.' then "value" end)
            as tools_rated_used_properly,
        max(case when question = '3-pronged plug and/or double insulated for proper grounding (if applicable).' then "value" end) as proper_grounding,
        max(
            case
                when
                    question
                    = 'Extension cords in good condition with no frays or signs of wear 
                    and equipped with 3- prong plug for grounding. GFCI Protection (if applicable).'
                    then "value"
            end
        ) as extension_cord_safety,
        max(case when question = 'Power bars UL/CSA approved. No receptacle block adapters.' then "value" end) as power_bars_approved,
        max(
            case
                when
                    question
                    = 'Safe work clearances from power utility lines and no underground line disturbances; no low hanging lines that pose a danger.'
                    then "value"
            end
        ) as electrical_clearances_safe,
        max(case when question = 'Pre-Use inspections on Mobile Equipment (forklifts, hoists, cranes).' then "value" end)
            as mobile_equipment_inspection,
        max(case when question = 'Adequate Machine & Equipment Guarding.' then "value" end) as equipment_guarding,
        max(case when question = 'Adequate Energy Isolation, Zero Energy State and Emergency Stop Functions-LOTO.' then "value" end)
            as loto_energy_isolation,
        max(
            case
                when question = 'Wheel chocks applied to trucks/heavy equipment in areas and when loading/unloading (if applicable).' then "value"
            end
        ) as wheel_chocks_applied,
        max(
            case
                when question = 'Scaffolding, ladders, step stools and platforms erected properly and secured (inspected if applicable).' then "value"
            end
        ) as scaffolding_secure,
        max(case when question = 'If not in use, ladders and step stools stored in one area safely.' then "value" end) as ladders_stored_safely,
        max(case when question = 'Machinery & Equipment have up to date certifications (if applicable).' then "value" end)
            as equipment_certifications,
        max(case when question = 'Heavy items stored on lower shelves, lower racking or ground level.' then "value" end) as heavy_items_stored_safely,
        max(case when question = 'Cabinets and shelves above 60” anchored/secured' then "value" end) as cabinets_secured,
        max(
            case
                when question = 'Industrial racking anchored/secured and shelving weight load posted/signed accordingly (if applicable).' then "value"
            end
        ) as industrial_racking_safe,
        max(case when question = 'Storage area clean and orderly; materials stored safely (secured if potential of rolling/falling)' then "value" end)
            as storage_area_safe,
        max(case when question = 'Pallets and skids in good condition and utilized appropriately.' then "value" end) as pallets_condition,
        max(case when question = 'Adequate ventilation and storage for chemicals.' then "value" end) as chemical_storage_ventilation,
        max(case when question = 'Training Programs and Certificates accessible if required.' then "value" end) as training_certificates_accessible,
        max(case when question = 'Noise levels acceptable and employees wearing hearing protection as required.' then "value" end)
            as noise_levels_acceptable,
        max(case when question = 'Air quality level tests and surveys where applicable.' then "value" end) as air_quality_tests

    from parsing
    group by all
),

latest as (
    select *
    from pivoted
    qualify
        row_number() over (partition by "location", hatchery_name, submit_monthyear order by submitdate desc) = 1
)

select * from latest
