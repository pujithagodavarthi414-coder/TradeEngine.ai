CREATE PROCEDURE [dbo].[Marker136]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

--Script for CustomAppSubQueryType
--UPDATE [CustomAppSubQueryType] SET [SubQueryType] = 'CUSTOMSUBQUERY' WHERE [SubQueryType] =  'CustomSubQuery'
--UPDATE [CustomAppSubQueryType] SET [SubQueryType] = 'LEAVES' WHERE [SubQueryType] =  'Leaves'
--UPDATE [CustomAppSubQueryType] SET [SubQueryType] = 'VERSIONS' WHERE [SubQueryType] =  'Versions'
--UPDATE [CustomAppSubQueryType] SET [SubQueryType] = 'GOALTYPE' WHERE [SubQueryType] =  'Goal'
--UPDATE [CustomAppSubQueryType] SET [SubQueryType] = 'SCENARIOS' WHERE [SubQueryType] =  'Scenarios'
--UPDATE [CustomAppSubQueryType] SET [SubQueryType] = 'SPRINT' WHERE [SubQueryType] =  'Sprint'
--UPDATE [CustomAppSubQueryType] SET [SubQueryType] = 'GOAL_REPLANHISTORY' WHERE [SubQueryType] =  'GoalReplanHistory'
--UPDATE [CustomAppSubQueryType] SET [SubQueryType] = 'GOALSTYPE' WHERE [SubQueryType] =  'Goals'
--UPDATE [CustomAppSubQueryType] SET [SubQueryType] = 'PROJECTYPE' WHERE [SubQueryType] =  'Project'
--UPDATE [CustomAppSubQueryType] SET [SubQueryType] = 'USERSTORIES' WHERE [SubQueryType] =  'Userstories'
--UPDATE [CustomAppSubQueryType] SET [SubQueryType] = 'RUNS' WHERE [SubQueryType] =  'Runs'
--UPDATE [CustomAppSubQueryType] SET [SubQueryType] = 'USERSTORYTYPE' WHERE [SubQueryType] =  'Userstory'
--UPDATE [CustomAppSubQueryType] SET [SubQueryType] = 'EMPLOYEEINDEX' WHERE [SubQueryType] =  'EmployeeIndex'

UPDATE [CustomAppSubQueryType] SET [SubQueryType] = 'CustomSubQuery' WHERE [SubQueryType] =  'CUSTOMSUBQUERY'
UPDATE [CustomAppSubQueryType] SET [SubQueryType] = 'Leaves' WHERE [SubQueryType] =  'LEAVES'
UPDATE [CustomAppSubQueryType] SET [SubQueryType] = 'Versions' WHERE [SubQueryType] =  'VERSIONS'
UPDATE [CustomAppSubQueryType] SET [SubQueryType] = 'Goal' WHERE [SubQueryType] =  'GOALTYPE'
UPDATE [CustomAppSubQueryType] SET [SubQueryType] = 'Scenarios' WHERE [SubQueryType] =  'SCENARIOS'
UPDATE [CustomAppSubQueryType] SET [SubQueryType] = 'Sprint' WHERE [SubQueryType] =  'SPRINT'
UPDATE [CustomAppSubQueryType] SET [SubQueryType] = 'GoalReplanHistory' WHERE [SubQueryType] =  'GOAL_REPLANHISTORY'
UPDATE [CustomAppSubQueryType] SET [SubQueryType] = 'Goals' WHERE [SubQueryType] =  'GOALSTYPE'
UPDATE [CustomAppSubQueryType] SET [SubQueryType] = 'Project' WHERE [SubQueryType] =  'PROJECTYPE'
UPDATE [CustomAppSubQueryType] SET [SubQueryType] = 'Userstories' WHERE [SubQueryType] =  'USERSTORIES'
UPDATE [CustomAppSubQueryType] SET [SubQueryType] = 'Runs' WHERE [SubQueryType] =  'RUNS'
UPDATE [CustomAppSubQueryType] SET [SubQueryType] = 'Userstory' WHERE [SubQueryType] =  'USERSTORYTYPE'
UPDATE [CustomAppSubQueryType] SET [SubQueryType] = 'EmployeeIndex' WHERE [SubQueryType] =  'EMPLOYEEINDEX'

END
GO
