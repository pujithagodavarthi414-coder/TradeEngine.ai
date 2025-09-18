-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-28 00:00:00.000'
-- Purpose      To Get TimeZone By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetTimeZoneById]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@TimeZoneId='598B12B3-DE19-4835-82DB-5B49DCC267EC'

CREATE PROCEDURE [dbo].[USP_GetTimeZoneById]
(
  @TimeZoneId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN

     SET NOCOUNT ON

     BEGIN TRY

		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	      SELECT TZ.Id AS TimeZoneId,
		         TZ.TimeZoneName,
				 TZ.TimeZoneOffset,
				 TZ.TimeZone,
				 TZ.TimeZoneAbbreviation,
				 TZ.CountryCode,
				 TZ.CountryName,
				 TZ.CreatedDateTime
		  FROM  [dbo].[TimeZone] TZ WITH (NOLOCK)
		  WHERE (TZ.Id = @TimeZoneId)
		      
	 END TRY  
	 BEGIN CATCH 
		
		SELECT ERROR_NUMBER() AS ErrorNumber,
			   ERROR_SEVERITY() AS ErrorSeverity, 
			   ERROR_STATE() AS ErrorState,  
			   ERROR_PROCEDURE() AS ErrorProcedure,  
			   ERROR_LINE() AS ErrorLine,  
			   ERROR_MESSAGE() AS ErrorMessage

	END CATCH

END
GO

