-------------------------------------------------------------------------------
-- Author       Aswani
-- Created      '2019-06-04 00:00:00.000'
-- Purpose      To Get the SpecificDays By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetSpecificDays] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertSpecificDay]
(
  @SpecificDayId UNIQUEIDENTIFIER = NULL,
  @Reason NVARCHAR(250) = NULL,
  @Date DATETIME = NULL,
  @IsArchived BIT = NULL,
  @TimeStamp TIMESTAMP = NULL,
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

		DECLARE @Currentdate DATETIME = GETDATE()
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		DECLARE @SpecificDayIdCount INT = (SELECT COUNT(1) FROM SpecificDay WHERE Id = @SpecificDayId AND CompanyId = @CompanyId)
		DECLARE @ReasonCount INT = (SELECT COUNT(1) FROM [SpecificDay] WHERE [Date] = @Date AND (@SpecificDayId IS NULL OR Id <> @SpecificDayId) AND CompanyId = @CompanyId)
		
			 IF(@Reason IS NULL)
			 BEGIN
			 RAISERROR(50011,16, 2, 'Reason')
			 END
			 ELSE IF(@Date IS NULL)
			 BEGIN
			 RAISERROR(50011,16, 2, 'Date')
			 END
		     ELSE IF(@SpecificDayId IS NOT NULL AND @SpecificDayIdCount = 0)
		     BEGIN
			 RAISERROR(50002,16, 1,'SpecificDay')
			 END
			 ELSE IF(@ReasonCount > 0)
			 BEGIN
			 RAISERROR(50001,16,1,'SpecificDay')
			 END
		     ELSE
		     BEGIN

		     	DECLARE @IsLatest BIT = (CASE WHEN @SpecificDayId IS NULL
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM SpecificDay WHERE Id = @SpecificDayId) = @TimeStamp
																THEN 1 ELSE 0 END END)
			IF(@IsLatest = 1)
			BEGIN
		    
			IF(@SpecificDayId IS NULL)
			BEGIN

				    SET @SpecificDayId = NEWID()

					INSERT INTO [dbo].[SpecificDay](
				     		            [Id],
				     		            [CompanyId],
										[Reason],
										[Date],
				     					[InActiveDateTime],
				     		            [CreatedDateTime],
				     		            [CreatedByUserId])
				     		     SELECT @SpecificDayId,
				     		            @CompanyId,
									    @Reason,
									    @Date,
				     					CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
				     		            @Currentdate,
				     		            @OperationsPerformedBy

				END
				ELSE
				BEGIN

						UPDATE [dbo].[SpecificDay]
							        SET [CompanyId]				  =   @CompanyId,
										[Reason]				  =   @Reason,
										[Date]					  =   @Date,
				     					[InActiveDateTime]		  =   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
				     		            [UpdatedDateTime]		  =   @Currentdate,
				     		            [UpdatedByUserId]		  =   @OperationsPerformedBy
							WHERE Id = @SpecificDayId

				END
					SELECT Id FROM [dbo].[SpecificDay] WHERE Id = @SpecificDayId
		     	END
				ELSE
					 RAISERROR(50008,11, 1)
		     END	
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