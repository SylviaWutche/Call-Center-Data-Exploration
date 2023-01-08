
/* This is an exploratory data Analysis on a call center's behavioural trends
    The analysis tries to find trends in customer and agents behaviour between january and march 2021m
*/

USE call_center;

SELECT 
    *
FROM
    call_center_data;

UPDATE call_center_data
SET AvgTalkDuration = str_to_date(AvgTalkDuration, "%H:%i:%s");



-- NO OF UNRESOLVED AND UNANSWERED CALLS EACH MONTH
SELECT 
    MONTHNAME(Date) MONTH,
    COUNT(Call_id) Total_calls,
    COUNT(CASE
        WHEN Resolved = 'No' THEN 1
    END) AS Unresolved_calls,
    COUNT(CASE
        WHEN answered = 'No' THEN 1
    END) AS Unanswered_calls
FROM
   call_center_data
GROUP BY MONTH;


-- 	NO OF ANSWERED AND UNANSWERED CALLS BY AGENT
SELECT 
    *,
    CONCAT(ROUND(Unanswered_calls / Total_calls * 100, 2),
	'%') 'Percentage of Unanswered Calls'
FROM
    (SELECT Agent,
	COUNT(Call_id) Total_calls,
	COUNT(CASE
	  WHEN answered = 'Yes' THEN 1 END) AS Answered_calls,
	COUNT(CASE WHEN answered = 'No' THEN 1 END) AS Unanswered_calls
    FROM
       call_center_data
    GROUP BY Agent) Unanswered;



-- NO OF RESOLVED AND UNRESOLVED CALLS BY AGENT
SELECT 
    *,
CONCAT(ROUND(Unresolved_calls / Total_Calls * 100, 2),
'%') 'Percentage of Unresolved calls'
FROM
	(SELECT Agent,COUNT(Call_id) Total_calls,
	COUNT(CASE WHEN Resolved = 'Yes' THEN 1 END) AS Resolved_calls,
    COUNT(CASE WHEN Resolved = 'No' THEN 1 END) AS Unresolved_calls
 FROM
        call_center_data
    GROUP BY Agent) Reolved;


-- 	AGENT's AVERAGE SPEED OF ANSWER
SELECT 
    Agent, AVG(Speed_of_answer_in_seconds) 'Speed of Answer'
FROM
   call_center_data
GROUP BY Agent
ORDER BY AVG(Speed_of_answer_in_seconds);


-- 	NO OF RESOLVED AND UNRESOLVED CALLS BY TOPIC
SELECT 
    Topic,
    COUNT(Call_Id) Total_calls,
    COUNT(CASE
        WHEN Resolved = 'Yes' THEN 1
    END) AS No_of_Resolved_calls,
    COUNT(CASE
        WHEN Resolved = 'No' THEN 1
    END) AS Unresolved_calls
FROM
    call_center_data
GROUP BY Topic
ORDER BY Unresolved_calls DESC;



-- 	TOPIC WITH SHORTEST AND LONGEST AVERAGE TALK DURATION
SELECT 
    Topic,
    MIN(AvgTalkDuration) 'Minimum Average Talk Duration',
    MAX(AvgTalkDuration) 'Maximum Average Talk Duration'
FROM
   call_center_data
WHERE
    Answered != 'No' AND Resolved != 'No'
GROUP BY Topic;




-- CUSTOMER SATISFACTION RATING BY TOPIC
SELECT 
    Topic,
    ROUND(AVG(satisfaction_rating), 2) 'Avg Satisfaction Rating'
FROM
   call_center_data
GROUP BY Topic
ORDER BY AVG(satisfaction_rating);


-- 	PEAKHOURS
SELECT 
    CASE
        WHEN Time BETWEEN '08:00:00' AND '09:00:00'  THEN '6am to 9am'
        WHEN Time BETWEEN '09:00:01' AND '12:00:00' THEN '9am to 12pm'
        WHEN Time BETWEEN '12:00:01' AND '15:00:00' THEN '12pm to 3pm'
        WHEN Time BETWEEN '15:00:01' AND '18:00:00' THEN '3pm to 6pm'
    END AS Peak_Hour,
    COUNT(Call_id) Total_Calls
FROM
    call_center_data
GROUP BY Peak_Hour
ORDER BY Total_Calls DESC;





 

