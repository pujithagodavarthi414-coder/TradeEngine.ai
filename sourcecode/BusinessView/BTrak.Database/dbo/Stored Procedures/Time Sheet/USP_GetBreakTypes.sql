-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-05-06 00:00:00.000'
-- Purpose      To Get the Break Types
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetBreakTypes] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetBreakTypes]
(
   @BreakTypeId UNIQUEIDENTIFIER = NULL,
   @BreakTypeName NVARCHAR(800) = NULL,
   @SearchText NVARCHAR(250) = NULL,
   @IsPaid BIT = NULL,
   @IsArchived BIT = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID)))) --(Not in the sheet)

		IF (@HavePermission = '1')
		BEGIN
		
		   IF(@BreakTypeId = '00000000-0000-0000-0000-000000000000') SET @BreakTypeId = NULL		  

		   IF(@BreakTypeName = '') SET @BreakTypeName = NULL

		   IF(@SearchText = '') SET @SearchText = NULL

		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT BT.Id AS BreakTypeId,
		   	      BT.CompanyId,
		   	      BT.BreakName,
				  BT.IsPaid,
				  BT.InActiveDateTime,
		   	      BT.CreatedDateTime,
		   	      BT.CreatedByUserId,
		   	      BT.[TimeStamp],	
				  (CASE WHEN BT.InActiveDateTime IS NULL THEN 0 ELSE 1 END) IsArchived,
		   	      TotalCount = COUNT(1) OVER()
           FROM [dbo].[BreakType] AS BT		        
           WHERE BT.CompanyId = @CompanyId
		   	   AND (@BreakTypeId IS NULL OR BT.Id = @BreakTypeId)
			   AND (@BreakTypeName IS NULL OR BT.BreakName = @BreakTypeName)
			   AND (@SearchText IS NULL OR BT.BreakName LIKE '%' + @SearchText +'%')
			   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND BT.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND BT.InActiveDateTime IS NULL))
           ORDER BY BT.BreakName ASC

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