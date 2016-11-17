/*

Description       : Get monitor stuck removing and installing.
Source URL        : http://github.com/jesseconnr/labtech-sql-library

Tested Versions   :
  MySQL 5.7
  LabTech 11.0

*/

SELECT
    cmd.computerid,
    c.name,
    c.lastcontact   AS 'agent last contact',
    cmd.dateupdated AS 'cmd last updated',
    COUNT(*)        AS cmdcount
FROM commands cmd LEFT JOIN computers c ON (c.computerid = cmd.computerid)
WHERE cmd.status = 2
      AND cmd.dateupdated > TIME(DATE_SUB(NOW(), INTERVAL 2 HOUR))
GROUP BY cmd.computerid
HAVING cmdcount > 25
ORDER BY COUNT(*) DESC