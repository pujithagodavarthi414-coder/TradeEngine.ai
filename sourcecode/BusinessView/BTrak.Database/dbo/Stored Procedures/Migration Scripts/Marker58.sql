CREATE PROCEDURE [dbo].[Marker58]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

	DELETE FROM WidgetModuleConfiguration WHERE WidgetId IN (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = N'Priority wise bugs count' AND CompanyId = @CompanyId)
	
	DELETE FROM CustomAppDetails WHERE CustomApplicationId IN (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = N'Priority wise bugs count' AND CompanyId = @CompanyId)
	
	DELETE FROM CustomAppColumns WHERE CustomWidgetId IN (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = N'Priority wise bugs count' AND CompanyId = @CompanyId)
	
	DELETE FROM CustomWidgetRoleConfiguration WHERE CustomWidgetId IN (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = N'Priority wise bugs count' AND CompanyId = @CompanyId)
	
	DELETE FROM CustomWidgetHistory WHERE CustomWidgetId IN (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = N'Priority wise bugs count' AND CompanyId = @CompanyId)
	
	DELETE FROM CustomTags WHERE ReferenceId IN (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = N'Priority wise bugs count' AND CompanyId = @CompanyId)
	
	DELETE FROM CustomWidgets WHERE CustomWidgetName = N'Priority wise bugs count' AND CompanyId = @CompanyId

	UPDATE CustomWidgets SET WidgetQuery='SELECT G.GoalName as [Goal name],COUNT(US.Id) [Work items count],COUNT(US1.Id) [Bugs count]  FROM UserStory US 
									                   INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL
									                           AND G.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL
														INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
														INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL  AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
														LEFT JOIN UserStory US1 ON US1.ParentUserStoryId = US.Id AND US1.InActiveDateTime IS NULL
														LEFT JOIN Goal G2 ON G2.Id = US1.GoalId AND G2.InActiveDateTime IS NULL AND G2.ParkedDateTime IS NULL
														WHERE G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
														      AND (US1.ParentUserStoryId IS NULL OR (US1.ParentUserStoryId IS Not NULL AND G2.Id IS Not NULL))
														GROUP BY G.GoalName' 
	WHERE CustomWidgetName = 'Goal work items VS bugs count' AND CompanyId = @CompanyId
	
	UPDATE CustomWidgets SET WidgetQuery = 'SELECT FORMAT(E.ExpenseDate, ''MMMM yyyy'') [Month],
												   SUM(CASE WHEN ES.IsApproved = 1 THEN ECC.Amount END)[Approved amount],
												   SUM(CASE WHEN ES.IsPaid = 1 THEN ECC.Amount END)[Paid amount],
												   SUM(CASE WHEN ES.IsRejected = 1 THEN ECC.Amount END)[Rejected amount]
		                                    FROM Expense E
		                                         INNER JOIN ExpenseCategoryConfiguration ECC ON ECC.ExpenseId = E.Id AND E.InActiveDateTime IS NULL AND ECC.InActiveDateTime IS NULL
			                                     INNER JOIN ExpenseCategory EC ON EC.Id = ECC.ExpenseCategoryId AND EC.InActiveDateTime IS NULL
			                                     INNER JOIN ExpenseStatus ES ON ES.Id = E.ExpenseStatusId 
		                                    WHERE E.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
		                                    GROUP BY FORMAT(E.ExpenseDate, ''MMMM yyyy'')' 
	WHERE CustomWidgetName = 'Monthly expenses'

END
GO