/*

 Description    : Get all Ticket Categories for the ConnectWise (CW) plugin, along with their Ticket Category mappings from LabTech.  Found on ##labtech.
 Source URL     : http://github.com/covenanttechnologysolutions/labtech-sql-library

 Returns        :
    TOTAL_RUNNING_SCRIPTS     :   Count of all running scripts
    Run_Script_ID             :   Script ID of highest count running script
    Run_ScriptID_Count        :   Number of Run_Script_ID scripts running
    TOTAL_WAITING_SCRIPTS     :   Count of all waiting scripts
    Waiting_ScriptsID         :   Script ID of highest count running script
    Waiting_ScriptID_Count    :   Number of Waiting_ScriptsID scripts waiting
    TOTAL_PENDING_SCRIPTS     :   Count of all pending scripts
    Pending_ScriptsID         :   Script ID of highest count pending script
    Pending_ScriptID_Count    :   Number of Pending_ScriptsID scripts pending

 Tested Versions:
  LabTech 2013.1, 10.0

 */

SELECT
    (SELECT COUNT(*) AS total
     FROM runningscripts
         JOIN computers USING (computerid)
     WHERE running = 1)                                                               AS total_running_scripts,
    (SELECT run_scriptid
     FROM (SELECT
               scriptid        AS run_scriptid,
               COUNT(scriptid) AS run_scriptid_count
           FROM runningscripts
           GROUP BY scriptid
           ORDER BY run_scriptid_count DESC
           LIMIT 1) AS r)                                                             AS run_script_id,
    (SELECT run_scriptid_count
     FROM (SELECT
               scriptid        AS run_scriptid,
               COUNT(scriptid) AS run_scriptid_count
           FROM runningscripts
           GROUP BY scriptid
           ORDER BY run_scriptid_count DESC
           LIMIT 1) AS rct)                                                           AS run_scriptid_count,
    (SELECT COUNT(*) AS total
     FROM runningscripts
         JOIN computers USING (computerid)
     WHERE running = 0 AND TIMESTAMPDIFF(SECOND, computers.lastcontact, NOW()) < 300) AS total_waiting_scripts,
    (SELECT waiting_scriptsid
     FROM (SELECT
               scriptid        AS waiting_scriptsid,
               COUNT(scriptid) AS waiting_scriptid_count
           FROM runningscripts
               JOIN computers USING (computerid)
           WHERE running = 0 AND TIMESTAMPDIFF(SECOND, computers.lastcontact, NOW()) < 300
           GROUP BY waiting_scriptsid
           ORDER BY waiting_scriptid_count DESC
           LIMIT 1) AS ws)                                                            AS waiting_scriptsid,
    (SELECT waiting_scriptid_count
     FROM (SELECT
               scriptid        AS waiting_scriptsid,
               COUNT(scriptid) AS waiting_scriptid_count
           FROM runningscripts
               JOIN computers USING (computerid)
           WHERE running = 0 AND TIMESTAMPDIFF(SECOND, computers.lastcontact, NOW()) < 300
           GROUP BY waiting_scriptsid
           ORDER BY waiting_scriptid_count DESC
           LIMIT 1) AS ws)                                                            AS waiting_scriptid_count,
    (SELECT COUNT(*) AS total
     FROM runningscripts
         JOIN computers USING (computerid)
     WHERE running = 0 AND TIMESTAMPDIFF(SECOND, computers.lastcontact, NOW()) > 300) AS total_pending_scripts,
    (SELECT pending_scriptsid
     FROM (SELECT
               scriptid        AS pending_scriptsid,
               COUNT(scriptid) AS pending_scriptid_count
           FROM runningscripts
               JOIN computers USING (computerid)
           WHERE running = 0 AND TIMESTAMPDIFF(SECOND, computers.lastcontact, NOW()) > 300
           GROUP BY pending_scriptsid
           ORDER BY pending_scriptid_count DESC
           LIMIT 1) AS ws)                                                            AS pending_scriptsid,
    (SELECT pending_scriptid_count
     FROM (SELECT
               scriptid        AS pending_scriptsid,
               COUNT(scriptid) AS pending_scriptid_count
           FROM runningscripts
               JOIN computers USING (computerid)
           WHERE running = 0 AND TIMESTAMPDIFF(SECOND, computers.lastcontact, NOW()) > 300
           GROUP BY pending_scriptsid
           ORDER BY pending_scriptid_count DESC
           LIMIT 1) AS ws)                                                            AS pending_scriptid_count






