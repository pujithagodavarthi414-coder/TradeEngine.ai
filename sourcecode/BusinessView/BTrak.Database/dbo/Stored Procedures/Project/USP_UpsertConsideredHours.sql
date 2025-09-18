-------------------------------------------------------------------------------
-- Author       Sudha Goli
-- Created      '2019-01-21 00:00:00.000'
-- Purpose      To save or Update the ConsideredHours 
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertConsideredHours] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@IsArchived=0,@ConsiderHourName='abcd'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertConsideredHours]
(
  @ConsideredHoursId UNIQUEIDENTIFIER = NULL,
  @ConsiderHourName  NVARCHAR(500) = NULL,
  @IsArchived BIT = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER ,
  @TimeStamp TIMESTAMP = NULL
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

		DECLARE @ConsideredHoursIdCount INT = (SELECT COUNT(1) FROM ConsiderHours WHERE Id = @ConsideredHoursId AND CompanyId = @CompanyId)

		DECLARE @ConsiderHourNameCount INT = (SELECT COUNT(1) FROM ConsiderHours WHERE ConsiderHourName = @ConsiderHourName AND CompanyId = @CompanyId  AND (@ConsideredHoursId IS NULL OR Id <> @ConsideredHoursId ))

		IF(@ConsideredHoursIdCount = 0 AND @ConsideredHoursId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 1,'ConsiderHours')
		END

		ELSE IF(@ConsiderHourNameCount > 0)
		BEGIN

			RAISERROR(50001,16,1,'ConsiderHours')

		END

		ELSE
		BEGIN
		    
		DECLARE @IsLatest BIT = (CASE WHEN @ConsideredHoursId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM ConsiderHours WHERE Id = @ConsideredHoursId) = @TimeStamp THEN 1 ELSE 0 END END)
		IF (@IsLatest = 1)
		BEGIN

			DECLARE @Currentdate DATETIME = GETDATE()

	        IF (@ConsideredHoursId IS NOT NULL)
	        BEGIN

	            UPDATE [dbo].[ConsiderHours]
	            SET [ConsiderHourName] = @ConsiderHourName,
				[InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE [InActiveDateTime] END,
			    [CompanyId] = @CompanyId,
				[UpdatedDateTime] = @Currentdate,
				[UpdatedByUserId] = @OperationsPerformedBy
	            WHERE Id = @ConsideredHoursId

	        END
	        ELSE
	        BEGIN

				   SELECT @ConsideredHoursId = NEWID()

	               INSERT INTO [dbo].[ConsiderHours](
			                   [Id],
			                   [ConsiderHourName],
					           [InActiveDateTime],
			                   [CompanyId],
			                   [CreatedDateTime],
			                   [CreatedByUserId])
		                SELECT @ConsideredHoursId,
			                   @ConsiderHourName,
				               CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
				               @CompanyId,
			                   @Currentdate,
			                   @OperationsPerformedBy
	        END
	
	        SELECT Id FROM [dbo].[ConsiderHours] where Id = @ConsideredHoursId

		END
		ELSE
		   
		    RAISERROR(50008,11,1)
		END
		END
		ELSE
		    
			RAISERROR(@HavePermission,11,1)

		END TRY  
	    BEGIN CATCH 
		
		   THROW

	   END CATCH

END
GO