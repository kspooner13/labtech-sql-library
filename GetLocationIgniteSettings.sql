SELECT
    locations.locationid                                                        AS 'location id',
    clients.name                                                                AS 'client name',
    locations.name                                                              AS 'location name',
    MAX(IF(cedfs.edfname = 'Audit Plan', cedfs.edfvalue, ''))                   AS 'audit plan',
    MAX(IF(cedfs.edfname = 'Workstation Service Plan', cedfs.edfvalue, ''))     AS 'workstation service plan',
    MAX(IF(cedfs.edfname = 'Workstations Under Contract', cedfs.edfvalue, ''))  AS 'workstations under contract',
    MAX(IF(cedfs.edfname = 'Enable Patching Workstations', cedfs.edfvalue, '')) AS 'enable patching workstations',
    MAX(IF(cedfs.edfname = 'Patch Day Workstations', cedfs.edfvalue, ''))       AS 'patch day workstations',
    MAX(IF(cedfs.edfname = 'DayTime Patching', cedfs.edfvalue, ''))             AS 'daytime patching',
    MAX(IF(cedfs.edfname = 'Daytime Patch Missed Windows', cedfs.edfvalue, '')) AS 'daytime patch missed windows',
    MAX(IF(cedfs.edfname = 'Server Service Plan', cedfs.edfvalue, ''))          AS 'server service plan',
    MAX(IF(cedfs.edfname = 'Servers Under Contract', cedfs.edfvalue, ''))       AS 'servers under contract',
    MAX(IF(cedfs.edfname = 'Enable Patching Servers', cedfs.edfvalue, ''))      AS 'enable patching servers',
    MAX(IF(cedfs.edfname = 'Patch Day Servers', cedfs.edfvalue, ''))            AS 'patch day servers',
    MAX(IF(cedfs.edfname = 'Patch Based on Server Role', cedfs.edfvalue, ''))   AS 'patch based on server role',
    MAX(IF(cedfs.edfname = 'Enable Onboarding', cedfs.edfvalue, ''))            AS 'enable onboarding',
    MAX(IF(cedfs.edfname = 'Exclude Offline Check', cedfs.edfvalue, ''))        AS 'exclude offline check'
FROM locations
    LEFT JOIN clients ON locations.clientid = clients.clientid
    LEFT JOIN (SELECT
                   extrafielddata.id    AS edfid,
                   extrafield.name      AS edfname,
                   extrafielddata.value AS edfvalue
               FROM extrafielddata
                   LEFT JOIN extrafield ON extrafield.id = extrafielddata.extrafieldid) AS cedfs ON locations.locationid = cedfs.edfid
GROUP BY locations.locationid
ORDER BY clients.name ASC, locations.name ASC;