CREATE PROCEDURE [dbo].[USP_GetAllTestRailAudits]
(
	@Activity NVARCHAR(100) = NULL,
	@PageNumber INT = NULL,
	@PageSize INT = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
   SET NOCOUNT ON
     BEGIN TRY
     SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	 
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			   
			   IF(@Activity = '') SET @Activity = NULL

			   IF(@PageNumber IS NULL) SET @PageNumber = 1

			   IF(@PageSize IS NULL) SET @PageSize = (SELECT COUNT(1) FROM TestRailAudit)

			   SELECT JSON_VALUE(AuditJson,'$.Title') AS Title,
                      CAST((SELECT JSON_VALUE(AuditJson,'$.TitleId')) AS UNIQUEIDENTIFIER) AS TitleId,
                      JSON_VALUE(AuditJson,'$.Action') AS [Action],
                      JSON_VALUE(AuditJson,'$.TabName') AS TabName,
                      JSON_VALUE(AuditJson,'$.Status') AS [Status],
					  CAST((SELECT JSON_VALUE(AuditJson,'$.AssignToId')) AS UNIQUEIDENTIFIER) AS AssignToId,
                      JSON_VALUE(AuditJson,'$.ColorCode') AS ColorCode,
                      IIF(JSON_VALUE(AuditJson,'$.AssignToId') IS NOT NULL , AU.FirstName + ''+ ISNULL(AU.SurName,'') , CU.FirstName + '' + ISNULL(CU.SurName,'')) AS PerformedBy,
                      CONVERT(VARCHAR, TA.CreatedDateTime, 107) AS PerformedOn,
					  TA.CreatedDateTime
                 FROM TestRailAudit TA 
				      LEFT JOIN [User] CU ON TA.CreatedByUserId = CU.Id  AND CU.InActiveDateTime IS NULL
                      LEFT JOIN [User] AU ON (SELECT JSON_VALUE(AuditJson,'$.AssignToId')) = AU.Id  AND AU.InActiveDateTime IS NULL
                WHERE (@Activity = 'History' AND (SELECT JSON_VALUE(AuditJson,'$.Status')) IS NULL AND (SELECT JSON_VALUE(AuditJson,'$.AssignToId')) IS NULL)
                       OR (@Activity = 'Test Changes' AND (((SELECT JSON_VALUE(AuditJson,'$.Status')) IS NOT NULL OR (SELECT JSON_VALUE(AuditJson,'$.AssignToId')) IS NOT NULL)))
                       AND TA.CompanyId = @CompanyId 
                ORDER BY TA.CreatedDateTime DESC , TA.[TimeStamp]
				OFFSET (@PageSize * (@PageNumber - 1)) ROWS
				FETCH NEXT @PageSize ROWS ONLY

     END TRY  
     BEGIN CATCH 

        EXEC USP_GetErrorInformation

    END CATCH
END
GO