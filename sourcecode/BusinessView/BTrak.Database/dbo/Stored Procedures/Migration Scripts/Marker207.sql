CREATE PROCEDURE [dbo].[Marker207]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

UPDATE CustomStoredProcWidget SET Inputs = '[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@DateTo","DataType":"datetime","InputData":"@DateTo"},{"ParameterName":"@DateFrom","DataType":"datetime","InputData":"@DateFrom"},{"ParameterName":"@Date","DataType":"datetime","InputData":"@Date"}]' 
WHERE CustomWidgetId IN (SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Employees Overview Details' AND CompanyId = @CompanyId)
UPDATE CustomStoredProcWidget SET Inputs = '[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@DateTo","DataType":"datetime","InputData":"@DateTo"},{"ParameterName":"@DateFrom","DataType":"datetime","InputData":"@DateFrom"},{"ParameterName":"@Date","DataType":"datetime","InputData":"@Date"}]' 
WHERE CustomWidgetId IN (SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Employees Details Project Wise' AND CompanyId = @CompanyId)
	
   UPDATE CustomWidgets SET WidgetQuery = 'SELECT COUNT(1)[Invoices Overdue] FROM Invoice_New I INNER JOIN InvoiceStatus SS ON I.InvoiceStatusId = SS.Id AND I.InactiveDateTime IS NULL AND SS.InActiveDateTime IS NULL
                                  WHERE I.CompanyId = ''@CompanyId''
                                  AND SS.InvoiceStatusName <> ''Paid''
                                  AND CAST(I.DueDate AS date) < CAST(GETDATE() AS date)
                                   AND ((ISNULL(@DateFrom,@Date) IS NULL OR CAST(I.DueDate AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
                                   AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(I.DueDate AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))' ,
								   [Description] ='This app provides the count of invoices that are crossed due date' WHERE CustomWidgetName ='Invoices Overdue' AND CompanyId = @CompanyId
   UPDATE CustomWidgets SET WidgetQuery = 'SELECT COUNT(1)[Invoices Due] FROM Invoice_New I INNER JOIN InvoiceStatus SS ON I.InvoiceStatusId = SS.Id AND I.InactiveDateTime IS NULL AND SS.InActiveDateTime IS NULL
          WHERE I.CompanyId = ''@CompanyId'' AND SS.InvoiceStatusName <> ''Paid''
            AND ((ISNULL(@DateFrom,@Date) IS NULL OR CAST(I.DueDate AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
            AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(I.DueDate AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date)))) ',[Description] ='This app provides the count of due invoices'
			WHERE CustomWidgetName ='Invoices Due' AND CompanyId = @CompanyId
   UPDATE CustomWidgets SET WidgetQuery = 'SELECT COUNT(1)[Expenses To Be Paid] FROM Expense E INNER JOIN ExpenseStatus ES ON ES.Id = E.ExpenseStatusId AND E.InActiveDateTime IS NULL AND ES.InActiveDateTime IS NULL
                                       WHERE (ES.IsApproved = 1 AND (IsPaid IS NULL OR IsPaid = 0)) AND E.CompanyId = ''@CompanyId''
         AND ((ISNULL(@DateFrom,@Date) IS NULL OR CAST(E.ExpenseDate AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
         AND ((ISNULL(@DateTo,@Date) IS NULL OR CAST(E.ExpenseDate AS date) <= CAST(ISNULL(@DateTo,@Date) AS date))))'  WHERE CustomWidgetName ='Expenses To Be Paid' AND CompanyId = @CompanyId
   UPDATE CustomWidgets SET WidgetQuery = 'SELECT E.EmployeeNumber [Employee ID],U.FirstName [First Name],U.SurName [Last Name],U.RegisteredDateTime [DOJ],E.DateofBirth [DOB],DesignationName [Designation],
 STUFF((SELECT '','' + ISNULL(U1.FirstName,'''')+'' ''+ISNULL(U1.SurName ,'''')
                          FROM [User] U1 INNER JOIN Employee  E2 ON E2.UserId = U1.Id AND U1.InActiveDateTime IS NULL AND E2.InActiveDateTime IS NULL
						                 INNER JOIN EmployeeReportTo ER ON ER.ReportToEmployeeId= E2.Id AND ER.InActiveDateTime IS NULL
                          WHERE ER.EmployeeId = E.Id AND (CONVERT(DATE,ER.ActiveFrom) < GETDATE()) AND (ER.ActiveTo IS NULL OR (CONVERT(DATE,ER.ActiveTo) > GETDATE()))
                    FOR XML PATH(''''), TYPE).value(''.'',''NVARCHAR(MAX)''),1,1,'''') AS [Repoting Manager], CAST((Amount -ES.NetPayAmount) / 12.00 AS decimal(10,2)) [Monthly CTC],Amount- ES.NetPayAmount AS [Annual CTC]
					FROM [User]U INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL AND U.InActiveDateTime IS NULL AND U.IsActive = 1
                      LEFT JOIN EmployeeDesignation ED ON ED.EmployeeId = E.Id AND E.InActiveDateTime IS NULL
					  LEFT JOIN Designation DD ON DD.Id = ED.DesignationId AND DD.InActiveDateTime IS NULL
					  LEFT JOIN Gender G ON G.Id = E.GenderId AND G.InActiveDateTime IS NULL
					  LEFT JOIN EmployeeSalary ES ON ES.EmployeeId = E.Id AND (CONVERT(DATE,ES.ActiveFrom) < cast(GETDATE() as date)) AND (ES.ActiveTo IS NULL OR (CONVERT(DATE,ES.ActiveTo) > cast(GETDATE() as date)))
					  WHERE U.CompanyId = ''@CompanyId''
					        AND CAST(U.RegisteredDateTime AS date) >= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)
                            AND CAST(U.RegisteredDateTime AS date) <= CAST(ISNULL(ISNULL(@DateTo,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)'
							 WHERE CustomWidgetName ='Headcount Report' AND CompanyId = @CompanyId
						 	
MERGE INTO [dbo].[WidgetModuleConfiguration] AS Target 
	USING (VALUES 
 (NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Audit rating' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Audits' ),@UserId,GETDATE())
)
AS Source ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET
		   [WidgetId] = Source.[WidgetId],
		   [ModuleId] = Source.[ModuleId],
		   [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime]) VALUES ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime]);	

END
GO