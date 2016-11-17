/*

Description       : Set all groups except safe groups to specific auto-join search.
Source URL        : http://github.com/jesseconnr/labtech-sql-library

Tested Versions   :
  MySQL 5.7
  LabTech 11.0

Table Aliases     :
  Groups                - mastergroups

*/

SELECT @GROUP_COUNT := (COUNT(*) * 5) FROM mastergroups;

SET SESSION GROUP_CONCAT_MAX_LEN = @GROUP_COUNT;

SELECT @SAFE_GROUPS := GROUP_CONCAT(DISTINCT(mastergroups.GroupID))
FROM mastergroups
WHERE
  (mastergroups.FullName LIKE '_System Automation%'
   OR mastergroups.FullName LIKE 'All Agents'
   OR mastergroups.FullName LIKE 'All Clients%'
   OR mastergroups.FullName LIKE 'Agent Types%'
   OR mastergroups.FullName LIKE 'Patching%'
   OR mastergroups.FullName LIKE 'Network Devices%'
   OR mastergroups.FullName LIKE 'Windows Updates%'
   OR mastergroups.FullName LIKE '__SF - %'); # custom groups

SET @AUTO_JOIN_SEARCH_ID = 1068; # my custom auto-join prevention group

UPDATE mastergroups SET
  mastergroups.AutoJoinScript = @AUTO_JOIN_SEARCH_ID,
  mastergroups.LimitToParent = 1
WHERE (find_in_set(mastergroups.GroupID, @SAFE_GROUPS) <= 0);

SELECT
  Groups.GroupId            AS `GroupId`,
  Groups.FullName           AS `FullName`,
  IFNULL(Searches.Name, '') AS `AutoJoinScript`,
  Groups.LimitToParent      AS `LimitToParent`
FROM `mastergroups` AS Groups
  LEFT JOIN `sensorchecks` AS Searches ON Groups.AutoJoinScript = Searches.SensID
WHERE (find_in_set(Groups.GroupId, @SAFE_GROUPS) <= 0)
ORDER BY Groups.FullName ASC;