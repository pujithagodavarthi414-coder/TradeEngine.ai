-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-05-06 00:00:00.000'
-- Purpose      To Get the Break Types
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetRateTypes] @OperationsPerformedBy ='127133F1-4427-4149-9DD6-B02E0E036971',@TypeName=NULL,@SearchText=NULL,@Rate=NULL

CREATE PROCEDURE [dbo].[USP_GetRateTypes]
(
   @RatetypeId UNIQUEIDENTIFIER = NULL,
   @TypeName NVARCHAR(800),
   @SearchText NVARCHAR(250),
   @Rate NUMERIC(10,2),
   @IsArchived BIT = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
		BEGIN
		
		   IF(@RatetypeId = '00000000-0000-0000-0000-000000000000') SET @RatetypeId = NULL		  

		   IF(@TypeName = '') SET @TypeName = NULL

		   IF(@SearchText = '') SET @SearchText = NULL

		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT RT.Id AS RateTypeId,
		   	      RT.CompanyId,
		   	      RT.[Type] AS TypeName,
				  RT.Rate,
		   	      RT.CreatedDateTime,
		   	      RT.CreatedByUserId,
		   	      RT.[TimeStamp],	
				  CASE WHEN RT.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   	      TotalCount = COUNT(1) OVER()
           FROM [dbo].[RateType] AS RT		        
           WHERE RT.CompanyId = @CompanyId
		   	   AND (@RatetypeId IS NULL OR RT.Id = @RatetypeId)
			   AND (@TypeName IS NULL OR RT.[Type] = @TypeName)
			   AND (@SearchText IS NULL OR RT.[Type] LIKE '%' + @SearchText +'%')
			   AND (@Rate IS NULL OR RT.Rate = @Rate)
			   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND RT.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND RT.InActiveDateTime IS NULL))
           ORDER BY RT.[Type] ASC

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