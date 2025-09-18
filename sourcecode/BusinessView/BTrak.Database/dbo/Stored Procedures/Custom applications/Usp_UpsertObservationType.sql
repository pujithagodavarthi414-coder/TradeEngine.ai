-------------------------------------------------------------------------------
-- Author       Anupam sai kumar vuyyuru
-- Created      '2020-02-03 00:00:00.000'
-- Purpose      To Save or Update ObservationType
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertObservationType] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971', @ObservationName='demo'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UpsertObservationType]
(
  @ObservationTypeId UNIQUEIDENTIFIER = NULL,
  @ObservationTypeName NVARCHAR(100) = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @IsArchived BIT = NULL,
  @TimeStamp TIMESTAMP = NULL
) 
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		
		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
		DECLARE @Currentdate DATETIME = GETDATE()

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @ObservationTypeIdCount INT = (SELECT COUNT(1) FROM ObservationType WHERE Id = @ObservationTypeId AND CompanyId = @CompanyId)

		DECLARE @ObservationTypeCount INT = (SELECT COUNT(1) FROM ObservationType WHERE ObservationName = @ObservationTypeName AND CompanyId = @CompanyId AND InActiveDateTime IS NULL AND (@ObservationTypeId IS NULL OR @ObservationTypeId <> Id))

		DECLARE @UpdateObservationTypeCount INT = (SELECT COUNT(1) FROM ObservationType WHERE ObservationName = @ObservationTypeName AND InActiveDateTime IS NULL AND CompanyId = @CompanyId AND Id <> @ObservationTypeId)

		IF(@ObservationTypeIdCount = 0 AND @ObservationTypeId IS NOT NULL)
		BEGIN

			RAISERROR(50002,16, 1,'ObservationType')

		END

		ELSE IF(@ObservationTypeCount > 0)
		BEGIN

			RAISERROR(50001,16,1,'ObservationType')

		END

		ELSE
		BEGIN

		IF (@HavePermission = '1')
		BEGIN

					DECLARE @IsLatest BIT = (CASE WHEN @ObservationTypeId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM ObservationType WHERE Id = @ObservationTypeId) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
		IF(@IsLatest = 1)
		BEGIN

					IF(@ObservationTypeId IS NULL)
					BEGIN

						SET @ObservationTypeId = NEWID()
					    INSERT INTO [dbo].[ObservationType](
						            Id,
						            ObservationName,
						            CompanyId,
						            CreatedDateTime,
						            CreatedByUserId,
									InActiveDateTime
									)
						     SELECT @ObservationTypeId,
						            @ObservationTypeName,
						            @CompanyId,
						            @Currentdate,
						            @OperationsPerformedBy,
									CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END
					  
					END
					ELSE
					BEGIN

						UPDATE [dbo].[ObservationType]
							SET ObservationName		 =  	 @ObservationTypeName,
						            CompanyId			 =  	 @CompanyId,
						            UpdatedDateTime		 =  	 @Currentdate,
						            UpdatedByUserId		 =  	 @OperationsPerformedBy,
									InActiveDateTime	 =  	 CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END
								WHERE Id = @ObservationTypeId

					END
					    SELECT Id FROM [dbo].[ObservationType] WHERE Id = @ObservationTypeId

		END	
		ELSE

			  	RAISERROR (50008,11, 1)

		END
		ELSE
		BEGIN
			        
			  RAISERROR (@HavePermission,11, 1)
			           
		END  
		END

	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO
