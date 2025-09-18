-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-05-06 00:00:00.000'
-- Purpose      To Get Employment Status
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetEmploymentStatus] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@EmploymentStatusName=NULL,@SearchText=NULL

CREATE PROCEDURE [dbo].[USP_GetEmploymentStatus]
(
   @EmploymentStatusId UNIQUEIDENTIFIER = NULL,
   @EmploymentStatusName NVARCHAR(800),
   @SearchText NVARCHAR(250),
   @IsArchived BIT = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
		BEGIN
		
		   IF(@EmploymentStatusId = '00000000-0000-0000-0000-000000000000') SET @EmploymentStatusId = NULL		  

		   IF(@EmploymentStatusName = '') SET @EmploymentStatusName = NULL

		   IF(@SearchText = '') SET @SearchText = NULL

		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT ES.Id AS EmploymentStatusId,
				  ES.CompanyId,
				  ES.EmploymentStatusName,
				  ES.IsPermanent,
				  ES.CreatedDateTime,
				  ES.CreatedByUserId,
				  ES.[TimeStamp],
				  CASE WHEN ES.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   	      TotalCount = COUNT(1) OVER()
           FROM [dbo].[EmploymentStatus] AS ES		        
           WHERE ES.CompanyId = @CompanyId
		   	   AND (@EmploymentStatusId IS NULL OR ES.Id = @EmploymentStatusId)
		   	   AND (@EmploymentStatusName IS NULL OR ES.EmploymentStatusName = @EmploymentStatusName)
		   	   AND (@SearchText IS NULL OR ES.EmploymentStatusName LIKE '%' + @SearchText +'%')
			   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND ES.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND ES.InActiveDateTime IS NULL))
           ORDER BY ES.[EmploymentStatusName] ASC

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