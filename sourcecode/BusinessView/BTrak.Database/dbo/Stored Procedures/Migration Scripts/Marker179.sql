 CREATE PROCEDURE [dbo].[Marker179]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON
	

 MERGE INTO [dbo].[CustomWidgets] AS TARGET
	USING( VALUES
 (NEWID(),'Employees Overview Details',' 
SELECT E.EmployeeNumber [Emp ID],CASE WHEN U.InActiveDateTime IS NOT NULL THEN ''Active'' ELSE ''InActive'' END [Status],DD.DepartmentName [Division],
	G.Gender Sex,ISNULL(U.FirstName,'''')+'' ''+ISNULL(U.SurName,'''') [Name],D.DesignationName Designation,
  	B.BranchName [Location],STUFF((SELECT '','' + ISNULL(U1.FirstName,'''')+'' ''+ISNULL(U1.SurName ,'''')
                          FROM [User] U1 INNER JOIN Employee  E2 ON E2.UserId = U1.Id AND U1.InActiveDateTime IS NULL AND E2.InActiveDateTime IS NULL
						                 INNER JOIN EmployeeReportTo ER ON ER.ReportToEmployeeId= E2.Id AND ER.InActiveDateTime IS NULL
                          WHERE ER.EmployeeId = E.Id AND (CONVERT(DATE,ER.ActiveFrom) < GETDATE()) AND (ER.ActiveTo IS NULL OR (CONVERT(DATE,ER.ActiveTo) > GETDATE()))
                    FOR XML PATH(''''), TYPE).value(''.'',''NVARCHAR(MAX)''),1,1,'''')	[Reporting Manager],
	U.RegisteredDateTime [Date of Join],E.DateofBirth [Date of Birth],MS.MaritalStatus [Marital status],CAST((DATEDIFF(MONTH,E.DateofBirth,GETDATE())*1.0)/12.0 AS decimal(10,1))	[Age],
	U.UserName [Official Email ID],ECD.OtherEmail [Personal Email ID],U.MobileNo [Contact Number],(SELECT top 1 EC.MobileNo FROM EmployeeEmergencyContact EC  WHERE IsEmergencyContact = 1 AND EC.InActiveDateTime IS NULL AND EC.EmployeeId= E.Id)	[Emergency Contact Number],	
	(SELECT TOP 1 ISNULL(EMC.FirstName,'''')+'' ''+ISNULL(EMC.LastName,'''') FROM EmployeeEmergencyContact EMC  
			WHERE RelationshipId IN (SELECT Id FROM RelationShip WHERE RelationShipName = ''Father'' AND CompanyId = @CompanyId) AND InActiveDateTime IS NULL)[Father''''s Name],
(select SUM(CAST((DATEDIFF(MONTH,we.FromDate,WE.ToDate)*1.0)/12.0 AS decimal(10,1))) from  EmployeeWorkExperience WE where WE.EmployeeId = E.Id AND WE.InActiveDateTime IS NULL) [Total Experience on DOJ]
  ,ECD.Address1	[Permanent Address 1],ECD.Address2	[Permanent Address 2],S.StateName [Permanent Address 3], C.CountryName [Permanent Address 4],EAD.PANNumber [PAN Card],
  EAD.PFNumber [PF Number],EAD.UANNumber [UAN Number],EAD.ESINumber [ESI Number],BD.BankName [Bank Name],BD.AccountNumber [Bank Account] ,
  ER.ResignationDate [Date of Resignation] ,DATEDIFF(DAY,ER.ResignationDate,DATEADD(MONTH,J.NoticePeriodInMonths,ER.ResignationDate)) [Notice Period (in days)],
  ER.CommentByEmployee [Reason For Exit],ER.LastDate [Date of Releiving]
FROM [User] U INNER JOIN Employee E ON E.USERId  = U.Id 
                       LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
					   LEFT JOIN Branch B ON B.Id = EB.BranchId AND B.InActiveDateTime IS NULL
					   LEFT JOIN EmployeeContactDetails ECD ON ECD.EmployeeId = E.Id AND ECD.InActiveDateTime IS NULL
					   LEFT JOIN EmployeeAccountDetails EAD ON EAD.EmployeeId = E.Id AND EAD.InActiveDateTime IS NULL
					   LEFT JOIN Job J ON J.EmployeeId = E.Id AND J.InActiveDateTime IS NULL
					   LEFT JOIN Designation D ON D.Id = J.DesignationId AND D.InActiveDateTime IS NULL
					   LEFT JOIN Department DD ON DD.Id = J.DepartmentId AND J.InActiveDateTime IS NULL
					   LEFT JOIN Gender G ON G.Id = E.GenderId AND G.InActiveDateTime IS NULL
					   LEFT JOIN MaritalStatus MS ON MS.Id = E.MaritalStatusId AND MS.InActiveDateTime IS NULL
					   LEFT JOIN Country C ON C.Id = ECD.CountryId AND C.InActiveDateTime IS NULL
					   LEFT JOIN  [State] S ON S.Id = ECD.StateId AND S.InActiveDateTime IS NULL
					   LEFT JOIN BankDetail BD ON BD.EmployeeId = E.Id AND BD.InActiveDateTime IS NULL AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
					   LEFT JOIN EmployeeResignation ER ON ER.EmployeeId = E.Id AND ER.InactiveDateTime IS NULL 
					   WHERE U.CompanyId = ''@CompanyId''
					        AND CAST(U.RegisteredDateTime AS date) >= CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)
                            AND CAST(U.RegisteredDateTime AS date) <= CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)',@CompanyId)
  ,(NEWID(),'Project Report','SELECT  P.ProjectName,ISNULL(U.FirstName,'''')+'' ''+ISNULL(U.SurName,'''') [Project Manager],
        CAST(P.ProjectStartDate AS DATE) [Start date],
		CAST(P.ProjectEndDate AS DATE) [End Date],
		(SELECT COUNT(1) FROM(SELECT UP.UserId FROM UserProject UP WHERE UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL GROUP BY UP.UserId)T) [Project Members]
       ,(SELECT COUNT(1) FROM Goal G WHERE G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL AND GoalStatusId = ''7A79AB9F-D6F0-40A0-A191-CED6C06656DE'' AND G.ProjectId = P.Id AND G.OnboardProcessDate IS NOT NULL)[Active Goals]
       ,(SELECT COUNT(1) FROM Sprints S WHERE S.InActiveDateTime IS NULL AND S.SprintStartDate IS NULL AND S.ProjectId = P.Id AND ISNULL(S.IsComplete,0) = 0)[Active Sprints]
       ,(SELECT COUNT(1) FROM Goal G WHERE Id IN (SELECT GoalId FROM UserStory US WHERE US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND P.Id = US.ProjectId AND ((ISNULL(P.IsDateTimeConfiguration,0) = 0 AND CAST(US.DeadLineDate AS DATE) < CAST(GETDATE() AS date))) OR ((P.IsDateTimeConfiguration = 1 AND US.DeadLineDate  < GETDATE()))) AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL) [Delayed Goals]
       ,(SELECT COUNT(1) FROM Sprints S WHERE S.ProjectId = P.Id AND CAST(S.SprintEndDate AS date) < CAST( GETDATE() AS date) ) [Delayed Sprints],
        (SELECT COUNT(1) FROM Goal G 
	               LEFT JOIN (SELECT US.GoalId, COUNT(1)Counts FROM UserStory US INNER JOIN UserStoryStatus USS ON USS.ID = US.UserStoryStatusId  AND US.InActiveDateTime IS NULL AND USS.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
       									AND USS.TaskStatusId NOT IN (''884947DF-579A-447A-B28B-528A29A3621D'',''FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'')
                                      GROUP BY US.GoalId)T ON G.Id = T.GoalId
									  WHERE T.GoalId IS NULL AND G.ProjectId = P.Id AND G.OnboardProcessDate IS NOT NULL) [Completed goals],
        (SELECT COUNT(1) FROM Sprints S  WHERE S.ProjectId = P.Id AND S.IsComplete = 1)[Completed Sprints],
        (SELECT COUNT(1) FROM UserStory US INNER JOIN UserStoryType UST ON US.UserStoryTypeId = UST.Id AND UST.IsBug = 1 AND US.ProjectId = P.Id
                                           INNER JOIN UserStoryStatus USS ON USS.ID = US.UserStoryStatusId  
                                           LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND S.SprintStartDate IS NOT NULL AND ISNULL(S.IsReplan,0) = 0
                                           LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL AND G.GoalStatusId = ''7A79AB9F-D6F0-40A0-A191-CED6C06656DE''
                                           WHERE (S.Id IS NOT NULL OR G.Id IS NOT NULL)) [Total Bugs],
        (SELECT COUNT(1) FROM UserStory US INNER JOIN UserStoryType UST ON US.UserStoryTypeId = UST.Id AND UST.IsBug = 1 AND US.ProjectId = P.Id
                                           INNER JOIN UserStoryStatus USS ON USS.ID = US.UserStoryStatusId  AND USS.TaskStatusId  = ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
                                           LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND S.SprintStartDate IS NOT NULL AND ISNULL(S.IsReplan,0) = 0
                                           LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL AND G.GoalStatusId = ''7A79AB9F-D6F0-40A0-A191-CED6C06656DE''
                                           WHERE (S.Id IS NOT NULL OR G.Id IS NOT NULL)) [Resolved bugs],
			(SELECT COUNT(1) FROM UserStory US INNER JOIN UserStoryType UST ON US.UserStoryTypeId = UST.Id AND UST.IsBug = 1 AND US.ProjectId = P.Id
            INNER JOIN UserStoryStatus USS ON USS.ID = US.UserStoryStatusId  AND USS.TaskStatusId  = ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
            LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND S.SprintStartDate IS NOT NULL AND ISNULL(S.IsReplan,0) = 0
            LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL AND G.GoalStatusId = ''7A79AB9F-D6F0-40A0-A191-CED6C06656DE''
            WHERE (S.Id IS NOT NULL OR G.Id IS NOT NULL))[Pending Bugs],
         dbo.Ufn_GetFilesCount(P.Id)  [Nunber Of Documents],
		 CASE WHEN  P.InActiveDateTime IS NULL THEN ''Active''  ELSE ''InActive'' END [Project Status],
		 (SELECT (COUNT(CASE WHEN USS.TaskStatusId IN (''FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'',''884947DF-579A-447A-B28B-528A29A3621D'') THEN 1 END)* 1.0) / (COUNT(1))*1.0 FROM UserStory US INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId WHERE US.ProjectId = P.Id AND US.InActiveDateTime IS NULL  AND US.ParkedDateTime IS NULL)[Project Completion Percentage]
FROM Project P INNER JOIN [User] U ON U.Id = P.ProjectResponsiblePersonId AND P.InActiveDateTime IS NULL
    WHERE P.CompanyId = ''@CompanyId''',@CompanyId)
  )
	AS Source ([Id], [CustomWidgetName], [WidgetQuery], [CompanyId])
	ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
			   	[CompanyId] =  SOURCE.CompanyId,
	            [WidgetQuery] = SOURCE.[WidgetQuery];

 MERGE INTO [dbo].[WidgetModuleConfiguration] AS Target 
	USING (VALUES 
  (NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Employees Details Project Wise' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Projects' ),@UserId,GETDATE())
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName =  'Employees Overview Details' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'HR Management' ),@UserId,GETDATE())
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Attendance report' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Leaves' ),@UserId,GETDATE())
 )
AS Source ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime])
ON Target.[WidgetId] = Source.[WidgetId]  AND Target.[ModuleId] = Source.[ModuleId]  
WHEN MATCHED THEN 
UPDATE SET
		   [WidgetId] = Source.[WidgetId],
		   [ModuleId] = Source.[ModuleId],
		   [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET AND Source.[WidgetId] IS NOT NULL AND Source.[ModuleId] IS NOT NULL THEN 
INSERT ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime]) VALUES ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime]);	

END