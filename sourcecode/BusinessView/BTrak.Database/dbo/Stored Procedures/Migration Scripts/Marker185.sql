CREATE PROCEDURE [dbo].[Marker185]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

	IF(NOT EXISTS(SELECT * FROM CustomWidgets WHERE CustomWidgetName ='Training assignments overdue' AND CompanyId = @CompanyId))
	BEGIN
		
		UPDATE CustomAppDetails SET YCoOrdinate ='Training assignments overdue'
		WHERE CustomApplicationId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Training assignments over due' AND CompanyId = @CompanyId)
		
		UPDATE CustomWidgets SET WidgetQuery = 'SELECT COUNT(1) [Training assignments overdue]   
		        FROM TrainingAssignment TA INNER JOIN AssignmentStatus ASS ON ASS.Id = TA.StatusId AND TA.IsActive = 1 
				       INNER JOIN TrainingCourse TC ON TC.Id = TA.TrainingCourseId AND (TC.IsArchived IS NULL OR TC.IsArchived = 0)  
					    INNER JOIN [User]U ON U.Id = TA.UserId AND U.InActiveDateTime IS NULL     
					   INNER JOIN Employee E ON E.UserId =U.Id AND E.InActiveDateTime IS NULL   
		           WHERE ASS.IsActive = 1 AND (ASS.IsDefaultStatus = 1 OR (IsSelectable = 1 AND AddsValidity = 0)) 
					   AND ASS.CompanyId =''@CompanyId''     AND (''@UserId''   = '''' OR TA.UserId = ''@UserId'')  
					   AND ((@DateFrom IS NULL OR CAST(DATEADD(MONTH,TC.ValidityInMonths,TA.CreatedDateTime) AS date) >= CAST(@DateFrom AS date)) 
					   AND ((@DateTo IS NULL OR CAST(DATEADD(MONTH,TC.ValidityInMonths,TA.CreatedDateTime) AS date) <= CAST(@DateTo AS date))))  
		               AND CAST(DATEADD(MONTH,TC.ValidityInMonths,TA.CreatedDateTime) AS date) < CAST(GETDATE() AS date)' 
					   ,CustomWidgetName ='Training assignments overdue' WHERE CustomWidgetName ='Training assignments over due' AND CompanyId = @CompanyId
		
	END
END
GO