----------------------------------------------------------------------------------------------
-- Author       Aswani k
-- Created      '2019-06-07 00:00:00.000'
-- Purpose      To Get Nationality
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetNationalities_New] @OperationsPerformedBy ='127133F1-4427-4149-9DD6-B02E0E036971',@SearchText = 'Indian'
----------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetNationalities_New]
(
  @NationalityId UNIQUEIDENTIFIER = NULL,
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

		 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
         
		 IF(@HavePermission = '1')
         BEGIN 

		 IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		 IF(@NationalityId = '00000000-0000-0000-0000-000000000000') SET @NationalityId = NULL

		 IF(@SearchText = '') SET @SearchText = NULL

		 SELECT  N.Id As NationalityId,
	             N.NationalityName Nationality,
				 N.CreatedDateTime,
                 N.CreatedByUserId,
                 N.[TimeStamp],
			     CASE WHEN N.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
                 TotalCount = COUNT(1) OVER()
				 FROM Nationality As N 
	             WHERE N.CompanyId = @CompanyId
				   AND (@NationalityId IS NULL OR N.Id = @NationalityId)
				   AND (@SearchText IS NULL OR NationalityName LIKE '%'+ @SearchText +'%')
				   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND N.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND N.InActiveDateTime IS NULL))
		ORDER BY NationalityName ASC

		END
		ELSE

		  RAISERROR(@HavePermission,11,1)

	    END TRY
		BEGIN CATCH
		    
			THROW

	    END CATCH
END
GO
