-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-04-05 00:00:00.000'
-- Purpose      To Get the TestCaseStatuses By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetTestCaseStatuses] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetTestCaseStatuses]
(
	@TestCaseStatusId UNIQUEIDENTIFIER = NULL,
	@Status NVARCHAR(250) = NULL,
	@IsArchived BIT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
   
			DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
                
			IF (@HavePermission = '1')
            BEGIN
				
		    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
				
			IF (@TestCaseStatusId = '00000000-0000-0000-0000-000000000000') SET @TestCaseStatusId = NULL
			 
			IF (@Status = '') SET @Status = NULL

			SELECT Id AS StatusId,
			       [Status],
				   [Status] AS testCaseStatus,
				   [StatusShortName] AS StatusShortName,
				   StatusHexValue,
				   (CASE WHEN TCS.InActiveDateTime IS NULL THEN 0 ELSE 1 END) AS IsArchived,
				   CompanyId,
				   CreatedDatetime,
				   CreatedByUserId,
				   [TimeStamp],
				   TotalCount = COUNT(1) OVER()
			FROM  [dbo].[TestCaseStatus] TCS WITH (NOLOCK)
			WHERE CompanyId = @CompanyId 
			      AND (@TestCaseStatusId IS NULL OR TCS.Id = @TestCaseStatusId) 
				  AND (@Status IS NULL OR TCS.[Status] = @Status) 
				  AND (@IsArchived IS NULL OR (@IsArchived = 1 AND TCS.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND TCS.InActiveDateTime IS NULL)) 
			ORDER BY TCS.[Status] ASC 	

		END
		ELSE
        RAISERROR (@HavePermission,11, 1)    

	 END TRY  
	 BEGIN CATCH 
		
		EXEC USP_GetErrorInformation

	END CATCH
END
GO