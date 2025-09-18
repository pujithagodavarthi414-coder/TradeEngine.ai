----------------------------------------------------------------------------------------------
-- Author       Aswani k
-- Created      '2019-06-07 00:00:00.000'
-- Purpose      To Get Gender
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetGenders] @OperationsPerformedBy ='127133F1-4427-4149-9DD6-B02E0E036971',@SearchText = 'Female'
----------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetGenders]
(
 @GenderId UNIQUEIDENTIFIER = NULL,
 @SearchText NVARCHAR(250) = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @IsArchived BIT = NULL 
)
 AS
 BEGIN
	 SET NOCOUNT ON
	 BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
         
		 DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
         
		 IF(@HavePermission = '1')
         BEGIN 

		 IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		 IF(@GenderId = '00000000-0000-0000-0000-000000000000') SET @GenderId = NULL

		 IF(@SearchText = '') SET @SearchText = NULL

		 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		 
		 SELECT  NT.Id As GenderId,
	             NT.Gender,
				 NT.CreatedDateTime,
				 NT.CreatedByUserId,
				 CASE WHEN NT.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
				 TotalCount = COUNT (1)OVER()
				 FROM Gender As NT 
	             WHERE NT.CompanyId = @CompanyId
				   AND (@GenderId IS NULL OR NT.Id = @GenderId)
				   AND (@SearchText IS NULL OR Gender LIKE '%'+ @SearchText +'%')
				   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND NT.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND NT.InActiveDateTime IS NULL))


		ORDER BY Gender ASC

		END
		ELSE

		  RAISERROR(@HavePermission,11,1)

	    END TRY
		BEGIN CATCH
		    
			THROW

	    END CATCH
END
GO
