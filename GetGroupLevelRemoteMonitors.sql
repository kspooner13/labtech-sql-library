/*

Description       : Get remote monitors for each group in LabTech.
Source URL        : http://github.com/jesseconnr/labtech-sql-library

Tested Versions   :
  MySQL 5.7
  LabTech 11.0

Table Aliases     :
  Groups                - mastergroups
  RemoteMonitors        - groupagents
  MonitorDetails        - agents
  GroupCategories       - infocategory
  AlertTemplates        - alerttemplate

*/

SET @group_filter = '5,976,977,978,981,982,983,984,985,986,987,988,989,995,996,1023,1579,1580,1581,1582,1584,1585,1593,1606,1609'; # A set of group ids to filter by.

SELECT
  CONCAT_WS(' - ', groups.groupid, groups.name) AS groupname,
  groups.fullname                               AS grouppath,
  monitordetails.name                           AS monitor,
  alerttemplates.name                           AS alerttemplate,
  groupcategories.categoryname                  AS categoryname
FROM groupagents AS remotemonitors
  LEFT JOIN agents AS monitordetails ON remotemonitors.agentid = monitordetails.agentid
  LEFT JOIN mastergroups AS groups ON remotemonitors.groupid = groups.groupid
  LEFT JOIN alerttemplate AS alerttemplates ON remotemonitors.alertaction = alerttemplates.alertactionid
  LEFT JOIN infocategory AS groupcategories ON remotemonitors.ticketcategory = groupcategories.id
  #WHERE (MonitorDetails.Flags & 0x01) = 0
  #WHERE FIND_IN_SET(Groups.GroupID,@group_filter) > 0
  #AND Groups.GroupID = 1580 # Group Id
  #AND MonitorDetails.Name = 'AV - Disabled' # Internal Monitor Name
  #AND AlertTemplates.Name = 'Default - Create LT Ticket' # Alert Template Name
  #AND GroupCategories.CategoryName = 'Anti-Virus' # Ticket Category Name
ORDER BY groups.fullname ASC;