with calendar as (
    select * from {{ ref('stg_ancillary__calendar') }}
),

date_dimension as (
    select

        hdate."Key_Date",
        cdate."Number_FiscalYear" as "CurrentFiscalYear",
        cdate."Number_FiscalQuarter" as "CurrentQuarterFiscalYear",
        cdate."Number_FiscalWeek" as "CurrentWeekNumberFiscalYear",
        cdate."Number_CalendarWeek" as "CurrentWeekNumberCalendarYear",
        hdate."Number_FiscalYear" as "Date_FiscalYear",
        hdate."Name_DayOfWeekEnglish" as "Date_DayOfWeekNameEnglish",
        hdate."Name_DayOfWeekSpanish" as "Date_DayOfWeekNameSpanish",
        hdate."Name_MonthSpanish" as "Date_MonthNameSpanish",
        hdate."Number_DayOfWeek" as "Date_DayNumberCalendarWeek",
        hdate."Number_FiscalQuarter" as "Date_QuarterNumberFiscalYear",
        hdate."Number_FiscalWeek" as "Date_WeekNumberFiscalYear",
        hdate."Number_CalendarWeek" as "Date_WeekNumberCalendarYear",
        date(cdate."Key_Date") as "CurrentDate",
        getdate() as "CurrentDateTime",
        date_part(year, cdate."Key_Date") as "CurrentCalendarYear",
        date_trunc(month, cdate."Key_Date") as "CurrentFirstDayOfMonth",
        month(cdate."Key_Date") as "CurrentMonthNumberFiscalYear",
        month(cdate."Key_Date") as "CurrentMonthNumberCalendarYear",
        quarter(cdate."Key_Date") as "CurrentQuarterCalendarYear",
        year(hdate."Key_Date") as "Date_CalendarYear",
        to_char(hdate."Key_Date", 'MMMM') as "Date_MonthNameEnglish",
        date_part(day, hdate."Key_Date") as "Date_DayNumberCalendarMonth",
        dayofyear(hdate."Key_Date") as "Date_DayNumberCalendarYear",
        month(hdate."Key_Date") as "Date_MonthNumberFiscalYear",
        month(hdate."Key_Date") as "Date_MonthNumberCalendarYear",
        quarter(hdate."Key_Date") as "Date_QuarterNumberCalendarYear",
        concat('Wk', lpad(hdate."Number_CalendarWeek", 2, '0'), '-', year(hdate."Key_Date")) as "Date_WeekLabelCalendarYear",
        concat(year(hdate."Key_Date"), '-', lpad(hdate."Number_CalendarWeek", 2, '0')) as "Date_WeekYear",
        date_trunc('month', hdate."Key_Date") as "Date_FirstDayOfMonth",
        date_trunc('year', hdate."Key_Date") as "Date_FirstDayOfYear",
        (hdate."Key_Date" - (hdate."Number_DayOfWeek" - 1)) as "Date_WeekStart",
        (hdate."Key_Date" - (hdate."Number_DayOfWeek" - 1) + 6) as "Date_WeekEnd",
        concat((hdate."Key_Date" - (hdate."Number_DayOfWeek" - 1)), ' - ', (hdate."Key_Date" - (hdate."Number_DayOfWeek" - 1) + 6))
            as "Date_WeekRange_Numeric",
        concat(
            to_varchar((hdate."Key_Date" - (hdate."Number_DayOfWeek" - 1))::date, 'mon dd, yyyy'),
            ' - ',
            to_varchar((hdate."Key_Date" - (hdate."Number_DayOfWeek" - 1) + 6)::date, 'mon dd, yyyy')
        ) as "Date_WeekRange",
        case
            when (month(hdate."Key_Date") = month(cdate."Key_Date")) and (date_part(year, hdate."Key_Date") = date_part(year, cdate."Key_Date"))
                then 1
            else 0
        end as "Flag_IsCurrentCalendarMonth",
        case
            when (quarter(hdate."Key_Date") = quarter(cdate."Key_Date")) and (date_part(year, hdate."Key_Date") = date_part(year, cdate."Key_Date"))
                then 1
            else 0
        end as "Flag_IsCurrentCalendarQuarter",
        case
            when (hdate."Number_CalendarWeek" = cdate."Number_CalendarWeek")
                and (date_part(year, hdate."Key_Date") = date_part(year, cdate."Key_Date"))
                then 1
            else 0
        end as "Flag_IsCurrentCalendarWeek",
        case
            when (date_part(year, hdate."Key_Date") = date_part(year, cdate."Key_Date"))
                then 1
            else 0
        end as "Flag_IsCurrentCalendarYear",
        case
            when hdate."Key_Date" = cdate."Key_Date"
                then 1
            else 0
        end as "Flag_IsCurrentDay",
        case
            when (month(hdate."Key_Date") = month(cdate."Key_Date")) and (hdate."Number_FiscalYear" = cdate."Number_FiscalYear")
                then 1
            else 0
        end as "Flag_IsCurrentFiscalMonth",
        case
            when (quarter(hdate."Key_Date") = quarter(cdate."Key_Date")) and (hdate."Number_FiscalYear" = cdate."Number_FiscalYear")
                then 1
            else 0
        end as "Flag_IsCurrentFiscalQuarter",
        case
            when (hdate."Number_FiscalWeek" = cdate."Number_FiscalWeek") and (hdate."Number_FiscalYear" = cdate."Number_FiscalYear")
                then 1
            else 0
        end as "Flag_IsCurrentFiscalWeek",
        case
            when hdate."Number_FiscalYear" = cdate."Number_FiscalYear"
                then 1
            else 0
        end as "Flag_IsCurrentFiscalYear",
        case
            when hdate."Key_Date" = date_trunc('month', hdate."Key_Date")
                then 1
            else 0
        end as "Flag_IsFirstDayOfMonth",
        case
            when hdate."Key_Date" = date_trunc('year', hdate."Key_Date")
                then 1
            else 0
        end as "Flag_IsFirstDayOfYear",
        case
            when hdate."Key_Date" = current_date
                then 'Today'
            else (hdate."Key_Date")::string
        end as "Default_KeyDate_Today",
        case
            when hdate."Key_Date" = current_date - 1
                then 'Yesterday'
            else (hdate."Key_Date")::string
        end as "Default_KeyDate_Yesterday",
        case
            when hdate."Key_Date" = current_date then 'Today'
            when hdate."Key_Date" = current_date - 1 then 'Yesterday'
            else (hdate."Key_Date")::string
        end as "Default_KeyDate_Combined",
        case
            when date_part(year, hdate."Key_Date") = date_part(year, cdate."Key_Date") - 1
                then 1
            else 0
        end as "Flag_IsPreviousYear",
        case
            when date_part(year, hdate."Key_Date") = date_part(year, cdate."Key_Date") - 1
                or (date_part(year, hdate."Key_Date") = date_part(year, cdate."Key_Date"))
                then 1
            else 0
        end as "Flag_IsInPreviousTwoYears",
        case
            when hdate."Key_Date" <= cdate."Key_Date"
                then 1
            else 0
        end as "Flag_IsTodayOrBefore",
        case
            when hdate."Key_Date" = (hdate."Key_Date" - (hdate."Number_DayOfWeek" - 1))
                then 1
            else 0
        end as "Flag_IsWeekStart",
        case
            when hdate."Key_Date" = (hdate."Key_Date" - (hdate."Number_DayOfWeek" - 1) + 6)
                then 1
            else 0
        end as "Flag_IsWeekEnd",
        case
            when hdate."Key_Date" = (cdate."Key_Date" - 1)
                then 1
            else 0
        end as "Flag_IsPreviousDay",
        case
            when hdate."Number_CalendarWeek" = (cdate."Number_CalendarWeek" - 1)
                and (date_part(year, hdate."Key_Date") = date_part(year, cdate."Key_Date"))
                then 1
            else 0
        end as "Flag_IsPreviousWeek",
        case
            when hdate."Number_FiscalWeek" = (cdate."Number_FiscalWeek" - 1)
                and (date_part(year, hdate."Key_Date") = date_part(year, cdate."Key_Date"))
                then 1
            else 0
        end as "Flag_IsPreviousFiscalWeek",
        case
            when month(hdate."Key_Date") = (month(cdate."Key_Date") - 1)
                and (date_part(year, hdate."Key_Date") = date_part(year, cdate."Key_Date"))
                then 1
            else 0
        end as "Flag_IsPreviousMonth",
        case
            when hdate."Key_Date" between (dateadd(day, -10, getdate())) and cdate."Key_Date"
                then 1
            else 0
        end as "Flag_RollingTenDays",
        case
            when hdate."Key_Date" between (dateadd(day, -50, getdate())) and cdate."Key_Date"
                then 1
            else 0
        end as "Flag_RollingFiftyDays",
        case
            when hdate."Key_Date" between (dateadd(day, -90, getdate())) and cdate."Key_Date"
                then 1
            else 0
        end as "Flag_RollingNinetyDays",
        case
            when hdate."Name_DayOfWeekEnglish" in ('Saturday', 'Sunday')
                and hdate."Key_Date" between (cdate."Key_Date" - 2) and (cdate."Key_Date" - 1)
                then 1
            when hdate."Name_DayOfWeekEnglish" not in ('Saturday', 'Sunday')
                and hdate."Key_Date" = (cdate."Key_Date" - 1)
                then 1
            else 0
        end as "Flag_IsPreviousDayOrWeekend"

    from calendar as hdate

    inner join calendar as cdate
        on cdate."Key_Date" = current_date()
)

select * from date_dimension
