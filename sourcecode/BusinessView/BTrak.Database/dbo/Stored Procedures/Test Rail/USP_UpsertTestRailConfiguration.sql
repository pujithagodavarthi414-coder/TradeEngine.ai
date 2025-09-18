-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-09-27 00:00:00.000'
-- Purpose      To Save or archive the testrailconfiguration to configure the work done by testrail team
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertTestRailConfiguration] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@ConfigurationName='tkkbvbesft',@ConfigurationTime=215
-------------------------------------------------------------------------------​
CREATE PROCEDURE [dbo].[USP_UpsertTestRailConfiguration]
(
    @TestRailConfigurationId UNIQUEIDENTIFIER = NULL,
    @ConfigurationName NVARCHAR(250) = NULL,
    @ConfigurationTime FLOAT = NULL,
    @IsArchived BIT = NULL,
    @TimeStamp TIMESTAMP = NULL,
	@TimeZone NVARCHAR(250) = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN

   SET NOCOUNT ON
   BEGIN TRY
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	IF(@ConfigurationName = '') SET @ConfigurationName = NULL

	
	IF(@ConfigurationName IS NULL)
	BEGIN
		
	    RAISERROR(50011,16, 2, 'TestRailConfigurationName')

	END
	ELSE
	BEGIN

		    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @TimeZoneId UNIQUEIDENTIFIER = NULL,@Offset NVARCHAR(100) = NULL
			
	        SELECT @TimeZoneId = Id,@Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone
			

            DECLARE @Currentdate DATETIMEOFFSET =  dbo.Ufn_GetCurrentTime(@Offset)


			--DECLARE @Currentdate DATETIME = GETDATE()

			DECLARE @NewTestRailConfigurationId UNIQUEIDENTIFIER = NEWID()

		    DECLARE @TestRailConfigurationIdCount INT = (SELECT COUNT(1) FROM TestRailConfiguration WHERE Id = @TestRailConfigurationId   AND CompanyId = @CompanyId)
		      
		    DECLARE @ConfigurationNameCount INT = (SELECT COUNT(1) FROM [dbo].TestRailConfiguration WHERE ConfigurationName = @ConfigurationName 
			                                       AND CompanyId = @CompanyId AND (Id <> @TestRailConfigurationId OR @TestRailConfigurationId IS NULL))
		    		       			   
		    IF(@TestRailConfigurationIdCount = 0 AND @TestRailConfigurationId IS NOT NULL)
	        BEGIN
		    
	        	RAISERROR(50002,16, 1,'TestRailConfiguration')
		    
	        END
	        ELSE IF(@ConfigurationNameCount > 0)
		    BEGIN
		    
		    	RAISERROR(50001,16,1,'TestRailConfiguration')
		    
		    END
	        ELSE
	        BEGIN
			
			DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF (@HavePermission = '1')
               BEGIN
			
				DECLARE @IsLatest BIT = (CASE WHEN @TestRailConfigurationId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
																	 FROM [TestRailConfiguration] WHERE Id = @TestRailConfigurationId) = @TimeStamp
															   THEN 1 ELSE 0 END END)
       
				IF(@IsLatest = 1)
				BEGIN
			    
					IF(@TestRailConfigurationId IS NULL)	
					BEGIN

					 SET @TestRailConfigurationId = NEWID()

							INSERT INTO [dbo].[TestRailConfiguration](
						                [Id],
						                [ConfigurationName],
										[ConfigurationShortName],
										[ConfigurationTime],
							            [InActiveDateTime],
							            [CompanyId],
						                [CreatedDateTime],
									    [CreatedDateTimeZoneId],
						                [CreatedByUserId]
										)
						         SELECT @TestRailConfigurationId,
						                @ConfigurationName,
										@ConfigurationName,
										@ConfigurationTime,
						                CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
						                @CompanyId,
						                @Currentdate,
										@TimeZoneId,
						                @OperationsPerformedBy

					END
					ELSE
					BEGIN
					
                           UPDATE [TestRailConfiguration]
						   SET ConfigurationName = @ConfigurationName,
						       ConfigurationTime = @ConfigurationTime,
							 --  [ConfigurationShortName] = @ConfigurationName,
							   CompanyId = @CompanyId,
							   UpdatedDateTime = @Currentdate,
							   UpdatedDateTimeZoneId = @TimeZoneId,
							   UpdatedByUserId = @OperationsPerformedBy,
							   InActiveDateTime =  CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
							   WHERE Id = @TestRailConfigurationId
						
					END

					SELECT Id FROM [dbo].[TestRailConfiguration] WHERE Id = @TestRailConfigurationId
				
		END	     
		ELSE
		  RAISERROR (50008,11, 1)
			    
    END
    ELSE
    BEGIN
     
     	RAISERROR (@HavePermission,11, 1)
     	
     END
	END
 END
END TRY
BEGIN CATCH

   THROW

END CATCH
END
GO