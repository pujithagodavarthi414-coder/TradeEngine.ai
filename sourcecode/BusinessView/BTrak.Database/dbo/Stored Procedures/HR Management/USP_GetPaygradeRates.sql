-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-05-07 00:00:00.000'
-- Purpose      To Get the Break Types
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetPaygradeRates] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetPaygradeRates]
(
   @PayGradeRateId UNIQUEIDENTIFIER = NULL,
   @PayGradeId UNIQUEIDENTIFIER = NULL,
   @RateId UNIQUEIDENTIFIER = NULL,
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
			
		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		   IF(@PayGradeRateId = '00000000-0000-0000-0000-000000000000') SET @PayGradeRateId = NULL
		   		  
		   IF(@PayGradeId = '00000000-0000-0000-0000-000000000000') SET @PayGradeId = NULL
		   		  
		   IF(@RateId = '00000000-0000-0000-0000-000000000000') SET @RateId = NULL		  

		   SELECT PGR.Id AS PayGradeRateId
				  ,PGR.PayGradeId
				  ,PG.PayGradeName
				  ,PGR.RateId
				  ,RT.[Type]
				  ,PGR.CreatedByUserId
				  ,PGR.CreatedDateTime
				  ,PGR.[TimeStamp]
				  ,(CASE WHEN PGR.InActiveDateTime IS NULL THEN 0 ELSE 1 END) IsArchived
				  ,TotalCount = COUNT(1) OVER()
		   FROM [dbo].[PayGradeRate] PGR 
				INNER JOIN [dbo].[PayGrade] PG ON PGR.PayGradeId = PG.Id 
				INNER JOIN [dbo].[RateType] RT ON RT.Id = PGR.RateId 
		  WHERE PG.CompanyId = @CompanyId
				AND (@PayGradeRateId IS NULL OR PGR.Id = @PayGradeRateId)
				AND (@PayGradeId IS NULL OR PGR.PayGradeId = @PayGradeId)
				AND (@RateId IS NULL OR PGR.RateId = @RateId)
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND PGR.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND PGR.InActiveDateTime IS NULL))

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