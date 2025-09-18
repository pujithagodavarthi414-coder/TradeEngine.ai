-------------------------------------------------------------------------------
-- Author       Anupam sai kumar vuyyuru
-- Created      '2020-04-20 00:00:00.000'
-- Purpose      To Get ESI Monthly Statement
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetPerformanceReports] @OperationsPerformedBy = 'CB900830-54EA-4C70-80E1-7F8A453F2BF5'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetPerformanceReports]
(
	 @OperationsPerformedBy UNIQUEIDENTIFIER
	,@EntityId UNIQUEIDENTIFIER = NULL
	,@UserId UNIQUEIDENTIFIER = NULL
    ,@SearchText NVARCHAR(250) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
		BEGIN
			
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			
			IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL
			
			IF(@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL
            IF(@SearchText = '') SET @SearchText = NULL

            SET @SearchText = '%' + @SearchText + '%'

			  SELECT  PS.Id AS PerformanceId,
					  PC.[Name] AS ConfigurationName,
					  PC.FormJson,
					  IIF(PS.IsOpen = 0,'Closed',IIF(PS.IsShare = 1,'Shared','Open')) AS [Status],
					  PS.OfUserId,
					  OU.FirstName + ' ' + ISNULL(OU.SurName,'') AS OfUserName,
					  OU.FirstName + ' ' + ISNULL(OU.SurName,'') AS PerformanceName,
					  OU.ProfileImage AS OfUserImage,
					  PSD.SubmittedBy,
					  PSDU.FirstName + ' ' + ISNULL(PSDU.SurName,'') AS SubmittedByName,
					  PSDU.ProfileImage AS SubmittedByImage,
					  PSD.FormData,
					  PS.CreatedByUserId,
					  CU.FirstName + ' ' + ISNULL(CU.SurName,'') AS CreatedByUserName,
					  CU.ProfileImage AS CreatedByUserImage,
					  PS.CreatedDateTime,
					  PS.ClosedByUserId,
					  CLU.FirstName + ' ' + ISNULL(CLU.SurName,'') AS ClosedByUserName,
					  CLU.ProfileImage AS ClosedByUserImage,
					  ISNULL(PSD.UpdatedDateTime,PSD.CreatedDateTime) AS LatestModificationOn,
                      TotalCount = COUNT(1) OVER()
            FROM PerformanceSubmission PS
				JOIN PerformanceConfiguration PC ON PS.ConfigurationId = PC.Id AND PC.InActiveDateTime IS NULL
				JOIN [User] CU ON CU.Id = PS.CreatedByUserId
				JOIN [User] OU ON OU.Id = PS.OfUserId
				INNER JOIN [Employee] E ON E.UserId = PS.OfUserId
                INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                        AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
	                	    AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
				LEFT JOIN [User] CLU ON CLU.Id = PS.ClosedByUserId
				LEFT JOIN PerformanceSubmissionDetails PSD ON PSD.PerformanceSubmissionId = PS.Id
				JOIN [User] PSDU ON PSDU.Id = PSD.SubmittedBy
		  WHERE OU.CompanyId = @CompanyId AND PS.InActiveDateTime IS NULL
		  AND (@EntityId IS NULL OR (EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL)))
		  AND (@UserId IS NULL OR @UserId = OU.Id)
		  AND (@SearchText IS NULL OR (OU.FirstName + ' ' + ISNULL(OU.SurName,'') LIKE @SearchText)
		  OR (PSDU.FirstName + ' ' + ISNULL(PSDU.SurName,'') LIKE @SearchText)
		  OR (PC.[Name] LIKE @SearchText))
		  ORDER BY PS.UpdatedDateTime,PS.CreatedDateTime

		END
		ELSE
		BEGIN
			RAISERROR (@HavePermission,11, 1)
		END

	END TRY
	BEGIN CATCH
		THROW
	END CATCH

END
GO