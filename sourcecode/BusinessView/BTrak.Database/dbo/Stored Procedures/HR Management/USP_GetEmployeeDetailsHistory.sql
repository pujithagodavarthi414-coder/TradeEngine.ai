CREATE PROCEDURE [dbo].[USP_GetEmployeeDetailsHistory]
(
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @UserId UNIQUEIDENTIFIER = NULL,
 @Category NVARCHAR(MAX) = NULL,
 @PageNumber INT = 1,
 @PageSize INT = 25
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY

         DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
         IF(@UserId IS NULL) SET @UserId = @OperationsPerformedBy

        IF (@HavePermission = '1')
        BEGIN
            SELECT *,COUNT(1) OVER() AS TotalCount FROM (
            SELECT EDH.Id AS EmployeeHistoryId,
                   EDH.Category,
                   CASE WHEN EDH.FieldName = 'Archive' THEN  CU.FirstName + ' ' + ISNULL(CU.SurName,'') + ' has ' + LOWER(EDH.NewValue) + ' ' + ISNULL(EDH.RecordTitle,'this') + ' details.' ELSE 
                   CASE WHEN EDH.OldValue IS NULL THEN CU.FirstName + ' ' + ISNULL(CU.SurName,'') + ' added ' + LOWER(EDH.FieldName) + ' as ' + LOWER(EDH.NewValue) + IIF(EDH.RecordTitle IS NULL,'',' of ' + LOWER(EDH.RecordTitle)) + '.'
                        ELSE CU.FirstName + ' ' + ISNULL(CU.SurName,'') + ' changed ' + LOWER(EDH.FieldName) + ' details from ' + LOWER(EDH.OldValue) 
                             + ' to ' + LOWER(EDH.NewValue) + IIF(EDH.RecordTitle IS NULL,'',' of ' + LOWER(EDH.RecordTitle)) + '.' END END AS [Description],
                   EDH.CreatedDateTime,
                   EDH.CreatedByUserId,
                   CU.FirstName + ' ' + ISNULL(CU.SurName,'') AS UserName
                   FROM EmployeeDetailsHistory EDH 
                   JOIN Employee E ON E.Id = EDH.EmployeeId AND (@Category IS NULL OR EDH.Category = @Category)
                   JOIN [User] U ON U.Id = E.UserId AND (@UserId IS NULL OR U.Id = @UserId) AND EDH.UserId IS NULL
                   JOIN [User] CU ON CU.Id = EDH.CreatedByUserId

                   UNION ALL

                   SELECT EDH.Id AS EmployeeHistoryId,
                   EDH.Category,
                   CASE WHEN EDH.FieldName = 'Archive' THEN  'You had ' + LOWER(EDH.NewValue) + ' ' + ISNULL(EDH.RecordTitle,'this') + ' details' +  IIF(EDH.RecordTitle = U.FirstName + ' ' + ISNULL(U.SurName,''),'',' of ' +U.FirstName + ' ' + ISNULL(U.SurName,'')) + '.' ELSE 
                   CASE WHEN EDH.OldValue IS NULL THEN 'You had ' + ' added ' + LOWER(EDH.FieldName) + ' as ' + LOWER(EDH.NewValue) + IIF(EDH.RecordTitle IS NULL,'',' of ' + LOWER(EDH.RecordTitle)) + IIF(EDH.RecordTitle = U.FirstName + ' ' + ISNULL(U.SurName,''),'',' for ' +U.FirstName + ' ' + ISNULL(U.SurName,''))  + '.'
                        ELSE 'You had ' + ' changed ' + LOWER(EDH.FieldName) + ' details from ' + LOWER(EDH.OldValue) 
                             + ' to ' + LOWER(EDH.NewValue) + IIF(EDH.RecordTitle IS NULL,'',' of ' + LOWER(EDH.RecordTitle))  +  IIF(EDH.RecordTitle = U.FirstName + ' ' + ISNULL(U.SurName,''),'',' of ' + U.FirstName + ' ' + ISNULL(U.SurName,''))  + '.' END END AS [Description],
                   EDH.CreatedDateTime,
                   EDH.CreatedByUserId,
                   CU.FirstName + ' ' + ISNULL(CU.SurName,'') AS UserName
                   FROM EmployeeDetailsHistory EDH 
                   JOIN Employee E ON E.Id = EDH.EmployeeId AND (@Category IS NULL OR EDH.Category = @Category)
                   JOIN [User] U ON U.Id = E.UserId AND E.UserId <> @UserId AND EDH.UserId IS NULL
                   JOIN [User] CU ON CU.Id = EDH.CreatedByUserId AND (@UserId IS NULL OR CU.Id = @UserId)
				   
				   UNION ALL

                   SELECT EDH.Id AS EmployeeHistoryId,
                   EDH.Category,
				   CASE WHEN EDH.[Description] IS NOT NULL THEN EDH.[Description] + IIF(EDH.RecordTitle = U.FirstName + ' ' + ISNULL(U.SurName,''),'',' of ' + U.FirstName + ' ' + ISNULL(U.SurName,'')) + '.' ELSE
                   CASE WHEN EDH.FieldName = 'Archive' THEN  'You had ' + LOWER(EDH.NewValue) + ' ' + ISNULL(EDH.RecordTitle,'this') + ' details' +  IIF(EDH.RecordTitle = U.FirstName + ' ' + ISNULL(U.SurName,''),'',' of ' +U.FirstName + ' ' + ISNULL(U.SurName,'')) + '.' ELSE 
                   CASE WHEN EDH.OldValue IS NULL THEN 'You had ' + ' added ' + LOWER(EDH.FieldName) + ' as ' + LOWER(EDH.NewValue) + IIF(EDH.RecordTitle IS NULL,'',' of ' + LOWER(EDH.RecordTitle)) + IIF(EDH.RecordTitle = U.FirstName + ' ' + ISNULL(U.SurName,''),'',' for ' +U.FirstName + ' ' + ISNULL(U.SurName,''))  + '.'
                        ELSE 'You had ' + ' changed ' + LOWER(EDH.FieldName) + ' details from ' + LOWER(EDH.OldValue) 
                             + ' to ' + LOWER(EDH.NewValue) + IIF(EDH.RecordTitle IS NULL,'',' of ' + LOWER(EDH.RecordTitle))  +  IIF(EDH.RecordTitle = U.FirstName + ' ' + ISNULL(U.SurName,''),'',' of ' + U.FirstName + ' ' + ISNULL(U.SurName,''))  + '.' END END END AS [Description],
                   EDH.CreatedDateTime,
                   EDH.CreatedByUserId,
                   CU.FirstName + ' ' + ISNULL(CU.SurName,'') AS UserName
                   FROM EmployeeDetailsHistory EDH 
                   JOIN [User] U ON U.Id = EDH.UserId AND EDH.UserId <> @UserId AND EDH.UserId IS NULL AND
                   (@Category IS NULL OR EDH.Category = @Category) AND EDH.UserId IS NOT NULL
                   JOIN [User] CU ON CU.Id = EDH.CreatedByUserId AND (@UserId IS NULL OR CU.Id = @UserId)

				   UNION ALL

				   SELECT EDH.Id AS EmployeeHistoryId,
                   EDH.Category,
				   CASE WHEN EDH.[Description] IS NOT NULL THEN EDH.[Description] + '.' ELSE
                   CASE WHEN EDH.FieldName = 'Archive' THEN  CU.FirstName + ' ' + ISNULL(CU.SurName,'') + ' has ' + LOWER(EDH.NewValue) + ' ' + ISNULL(EDH.RecordTitle,'this') + ' details.' ELSE 
                   CASE WHEN EDH.OldValue IS NULL THEN CU.FirstName + ' ' + ISNULL(CU.SurName,'') + ' added ' + LOWER(EDH.FieldName) + ' as ' + LOWER(EDH.NewValue) + IIF(EDH.RecordTitle IS NULL,'',' of ' + LOWER(EDH.RecordTitle)) + '.'
                        ELSE CU.FirstName + ' ' + ISNULL(CU.SurName,'') + ' changed ' + LOWER(EDH.FieldName) + ' details from ' + LOWER(EDH.OldValue) 
                             + ' to ' + LOWER(EDH.NewValue) + IIF(EDH.RecordTitle IS NULL,'',' of ' + LOWER(EDH.RecordTitle)) + '.' END END END AS [Description],
                   EDH.CreatedDateTime,
                   EDH.CreatedByUserId,
                   CU.FirstName + ' ' + ISNULL(CU.SurName,'') AS UserName
                   FROM EmployeeDetailsHistory EDH 
                   JOIN [User] U ON U.Id = EDH.UserId AND EDH.UserId <> @UserId AND EDH.UserId IS NULL AND
                   (@Category IS NULL OR EDH.Category = @Category) AND EDH.UserId IS NOT NULL
                   JOIN [User] CU ON CU.Id = EDH.CreatedByUserId AND (@UserId IS NULL OR CU.Id = @UserId)
				   ) T
				   ORDER BY T.CreatedDateTime DESC

                   OFFSET ((@PageNumber - 1) * @PageSize) ROWS
		        
                   FETCH NEXT @PageSize ROWS ONLY
        END
        ELSE
            
            RAISERROR(50008,11,1)

    END TRY
    BEGIN CATCH

        THROW

    END CATCH
END