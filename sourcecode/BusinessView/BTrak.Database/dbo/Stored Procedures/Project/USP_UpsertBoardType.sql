-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-06 00:00:00.000'
-- Purpose      To Save or Update the BoardType
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertBoardType] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@BoardTypeName='test'
----------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertBoardType]
(
  @BoardTypeId UNIQUEIDENTIFIER = NULL,
  @BoardTypeName  NVARCHAR(500) = NULL,
  @IsArchived BIT = NULL,
  @IsApi BIT = NULL,
  @IsBugBoard BIT = NULL,
  @IsSuperAgileBoard BIT = NULL,
  @IsDefault BIT = NULL,
  @TimeStamp TIMESTAMP = NULL,
  @TimeZone NVARCHAR(250) = NULL,
  @BoardTypeUIId UNIQUEIDENTIFIER = NULL,
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
		  IF(@IsArchived = 1 AND @BoardTypeId IS NOT NULL)
		  BEGIN
		    DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
            IF(EXISTS(SELECT Id FROM [Goal] WHERE BoardTypeId = @BoardTypeId))
            BEGIN
            SET @IsEligibleToArchive = 'ThisBoardTypeUsedInGoalDeleteTheDependenciesAndTryAgain'
            END
			ELSE IF(EXISTS(SELECT Id FROM [BoardTypeWorkFlow] WHERE BoardTypeId = @BoardTypeId))
            BEGIN
            SET @IsEligibleToArchive = 'ThisBoardTypeUsedInBoardTypeWorkFlowDeleteTheDependenciesAndTryAgain'
            END
			IF(@IsEligibleToArchive <> '1')
            BEGIN
             RAISERROR (@IsEligibleToArchive,11, 1)
             END
		  END
		IF(@BoardTypeName IS NULL)
		BEGIN
			RAISERROR(50011,16, 2, 'BoardTypeName')
		END
		ELSE
		BEGIN
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		
		DECLARE @TimeZoneId UNIQUEIDENTIFIER = NULL,@Offset NVARCHAR(100) = NULL
			
	    SELECT @TimeZoneId = Id,@Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone
		 	

        DECLARE @Currentdate DATETIMEOFFSET =  dbo.Ufn_GetCurrentTime(@Offset)



		DECLARE @BoardTypeIdCount INT = (SELECT COUNT(1) FROM BoardType WHERE Id = @BoardTypeId AND CompanyId = @CompanyId)
		DECLARE @BoardTypeNameCount INT = (SELECT COUNT(1) FROM BoardType WHERE BoardTypeName = @BoardTypeName
		                                                                    AND CompanyId = @CompanyId
																			AND (@BoardTypeId IS NULL OR Id <> @BoardTypeId)
																			)
		IF(@BoardTypeIdCount = 0 AND @BoardTypeId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 1,'BoardType')
		END
		ELSE IF(@BoardTypeNameCount > 0)
		BEGIN
			RAISERROR(50001,16,1,'BoardType')
		END
		ELSE
		BEGIN
		DECLARE @IsLatest BIT = (CASE WHEN @BoardTypeId IS NULL THEN 1 ELSE
		                         CASE WHEN (SELECT [TimeStamp] FROM BoardType WHERE Id = @BoardTypeId) = @TimeStamp THEN 1 ELSE 0 END END )
	    IF (@IsLatest = 1)
		BEGIN
	   -- DECLARE @Currentdate DATETIME = GETDATE()
	
				IF(@BoardTypeId IS NULL)
				BEGIN

					SET @BoardTypeId = NEWID()
						INSERT INTO [dbo].[BoardType](
			  		                              [Id],
			  				                      [BoardTypeName],
			  				                      [BoardTypeUIId],
												  [IsBugBoard],
												  [IsSuperAgileBoard],
												  [IsDefault],
			  				                      [CompanyId],
			  				                      [CreatedDateTime],
												  [CreatedDateTimeZoneId],
			  				                      [CreatedByUserId],
								                  [InActiveDateTime]							 
							                     )
					                      SELECT  @BoardTypeId,
			  			                          @BoardTypeName,
			  			 	                      @BoardTypeUIId,
												  ISNULL(@IsBugBoard,0),
												  ISNULL(@IsSuperAgileBoard,0),
												  ISNULL(@IsDefault,0),
			  			 	                      @CompanyId,
			  			 	                      @Currentdate,
												  @TimeZoneId,
			  			 	                      @OperationsPerformedBy,
						             		      CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END

			END
			ELSE
			BEGIN

				UPDATE [dbo].[BoardType]
					SET  [BoardTypeName]		=  	    @BoardTypeName,
			  			 [BoardTypeUIId]		=  	    @BoardTypeUIId,
						 [IsBugBoard]			=  	    ISNULL(@IsBugBoard,0),
						 [IsSuperAgileBoard]	=  	    ISNULL(@IsSuperAgileBoard,0),
						 [IsDefault]	        =  	    ISNULL(@IsDefault,0),
			  			 [CompanyId]			=  	    @CompanyId,
			  		     [UpdatedDateTime]		=  	    @Currentdate,
						 [UpdatedDateTimeZoneId] =      @TimeZoneId,
			  			 [UpdatedByUserId]		=  	    @OperationsPerformedBy,
						 [InActiveDateTime]		=  	    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
					WHERE Id = @BoardTypeId

			END
			SELECT Id FROM [dbo].[BoardType] where Id = @BoardTypeId
		 END
		 ELSE
			  RAISERROR(50008,11,1)
		 END
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
