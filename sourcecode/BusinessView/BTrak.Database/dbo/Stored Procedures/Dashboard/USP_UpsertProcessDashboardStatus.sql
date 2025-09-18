-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-02-01 00:00:00.000'
-- Purpose      To Save or Update the ProcessDashboardStatus
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertProcessDashboardStatus] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@StatusName='Test'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertProcessDashboardStatus]
(
  @ProcessDashboardStatusId UNIQUEIDENTIFIER = NULL,
  @StatusName NVARCHAR(250) = NULL,
  @StatusShortName NVARCHAR(250) = NULL,
  @HexaValue  NVARCHAR(250) = NULL,
  @TimeStamp TIMESTAMP = NULL,
  @TimeZone NVARCHAR(250) = NULL,
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

			   DECLARE @TimeZoneId UNIQUEIDENTIFIER = NULL,@Offset NVARCHAR(100) = NULL
			
	           SELECT @TimeZoneId = Id,@Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone
			 
			  IF(@StatusShortName = '')SET @StatusShortName = NULL

              DECLARE @Currentdate DATETIMEOFFSET =  dbo.Ufn_GetCurrentTime(@Offset)

			  DECLARE @StatusNameCount INT = (SELECT COUNT(1) FROM ProcessDashboardStatus WHERE StatusName = @StatusName AND CompanyId = @CompanyId)

   			  DECLARE @UpdateStatusNameCount INT = (SELECT COUNT(1) FROM ProcessDashboardStatus WHERE ShortName = @StatusShortName AND CompanyId = @CompanyId
			   AND (@ProcessDashboardStatusId IS NULL OR Id <> @ProcessDashboardStatusId))

			  DECLARE @ProcessDashboardStatusIdCount INT = (SELECT COUNT(1) FROM ProcessDashboardStatus WHERE Id = @ProcessDashboardStatusId AND CompanyId = @CompanyId)
			  
			  IF(@StatusShortName IS NULL)
			  BEGIN

			  RAISERROR('NotEmptyProcessDashboardStatusName',16, 1)

			  END
			  ELSE IF(@ProcessDashboardStatusIdCount = 0 AND @ProcessDashboardStatusId IS NOT NULL)
			  BEGIN
			  		RAISERROR(50002,16, 1,'ProcessDashboardStatus')
			  END

			  ELSE IF(@StatusNameCount > 0 AND @ProcessDashboardStatusId IS NULL)
			  BEGIN
			  
			  		RAISERROR(50001,16,1,'ProcessDashboardStatus')
			  
			  END
			  
			  ELSE IF(@UpdateStatusNameCount > 0 AND @ProcessDashboardStatusId IS NOT NULL)
			  BEGIN
			  
			  		RAISERROR(50001,16,1,'ProcessDashboardStatus')
			  
			  END
					
			 ELSE
			 BEGIN

			 DECLARE @IsLatest BIT = (CASE WHEN @ProcessdashBoardStatusId IS NULL THEN 1 ELSE
			                          CASE WHEN (SELECT [TimeStamp] FROM ProcessDashboardStatus WHERE id = @ProcessDashboardStatusId) = @TimeStamp THEN 1 ELSE 0 END END)

			 IF (@IsLatest = 1)
			 BEGIN

			  --DECLARE @Currentdate DATETIME = GETDATE()
			
			IF(@ProcessDashboardStatusId IS NULL)
			BEGIN

						SET @ProcessDashboardStatusId = NEWID()
			 		      INSERT INTO [dbo].[ProcessDashboardStatus](
			 				                                         [Id],
			 		                                                 [StatusName],
																	 [ShortName],
			 							                             [HexaValue],
			 							                             [CreatedDateTime],
																	 [CreatedDateTimeZoneId],
			 							                             [CreatedByUserId],
			 							                             [CompanyId],
																	 [InActiveDateTime]
																	)
			 		                                          SELECT @ProcessDashboardStatusId,
			 					                                     @StatusName,
																	 @StatusShortName,
			 							                             @HexaValue,
			 							                             @Currentdate,
																	 @TimeZoneId,
			 							                             @OperationsPerformedBy,
			 							                             @CompanyId,
																	 CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END

			END
			ELSE
			BEGIN

			UPDATE [dbo].[ProcessDashboardStatus]
				SET [StatusName]			=  	   @StatusName,
				    [ShortName]             =      @StatusShortName,
			 		[HexaValue]				=  	   @HexaValue,
			 		[UpdatedDateTime]		=  	   @Currentdate,
					[UpdatedDateTimeZoneId] =   @TimeZoneId,
			 		[UpdatedByUserId]		=  	   @OperationsPerformedBy,
			 		[CompanyId]				=  	   @CompanyId,
					[InActiveDateTime]		=  	   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
				WHERE Id = @ProcessDashboardStatusId

			END
			 	SELECT Id FROM [dbo].[ProcessDashboardStatus] where Id = @ProcessDashboardStatusId
			 
			  END
			  ELSE

			   RAISERROR(50008,11,1)
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
