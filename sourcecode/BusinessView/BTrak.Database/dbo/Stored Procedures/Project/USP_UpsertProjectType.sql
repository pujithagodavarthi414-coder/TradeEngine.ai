-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-14 00:00:00.000'
-- Purpose      To Save or Update ProjectType
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertProjectType] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
-- @ProjectTypeName='Hospital',@IsArchived = 0
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertProjectType]
(
  @ProjectTypeId UNIQUEIDENTIFIER = NULL,
  @ProjectTypeName NVARCHAR(250) = NULL,
  @IsArchived BIT = NULL,
  @TimeStamp TIMESTAMP = NULL,
  @TimeZone NVARCHAR(250) = NULL,
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
			

        DECLARE @Currentdate DATETIMEOFFSET =  dbo.Ufn_GetCurrentTime(@Offset)

		IF(@IsArchived = 1 AND @ProjectTypeId IS NOT NULL)
		BEGIN

		    DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
    
            IF(EXISTS(SELECT Id FROM [Project] WHERE ProjectTypeId = @ProjectTypeId))
            BEGIN
	        
            SET @IsEligibleToArchive = 'ThisProjectTypeUsedInProjectDeleteTheDependenciesAndTryAgain'
            
            END

			IF(@IsEligibleToArchive <> '1')
            BEGIN
         
             RAISERROR (@isEligibleToArchive,11, 1)
         
             END
		END

		DECLARE @ProjectTypeIdCount INT = (SELECT COUNT(1) FROM ProjectType WHERE Id = @ProjectTypeId AND CompanyId = @CompanyId)

		DECLARE @ProjectTypeNameCount INT = (SELECT COUNT(1) FROM [ProjectType] WHERE ProjectTypeName = @ProjectTypeName AND CompanyId = @CompanyId)

		DECLARE @UpdateProjectTypeNameCount INT = (SELECT COUNT(1) FROM [ProjectType] WHERE ProjectTypeName = @ProjectTypeName AND CompanyId = @CompanyId AND (@ProjectTypeId IS NULL OR Id <> @ProjectTypeId))

		DECLARE @ProjectsCount INT = (SELECT COUNT(1) FROM Project WHERE ProjectTypeId  = @ProjectTypeId AND InActiveDateTime IS NULL)

		     IF(@ProjectTypeId IS NOT NULL AND @IsArchived=1 AND @ProjectsCount>0)
		     BEGIN
		     RAISERROR ('ActiveProjectsAreThereYouCanNotDeleteTheProjectType',11, 1)
		     END
		     ELSE IF(@ProjectTypeIdCount = 0 AND @ProjectTypeId IS NOT NULL)
		     BEGIN
		     	RAISERROR(50002,16, 1,'ProjectType')
		     END
		     
		     ELSE IF(@ProjectTypeNameCount > 0 AND @ProjectTypeId IS NULL)
		     BEGIN
		     
		     	RAISERROR(50001,16,1,'ProjectType')
		     
		     END
		     
		     ELSE IF(@UpdateProjectTypeNameCount > 0 AND @ProjectTypeId IS NOT NULL)
		     BEGIN
		     
		     	RAISERROR(50001,16,1,'ProjectType')
		     
		     END
		     
		     ELSE
		     BEGIN

			 DECLARE @IsLatest BIT = (CASE WHEN @ProjectTypeId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM ProjectType WHERE Id = @ProjectTypeId) = @TimeStamp THEN 1 ELSE 0 END END)

			 IF(@IsLatest = 1)
			 BEGIN
			 
			 --DECLARE @Currentdate DATETIME = GETDATE()

			 IF(@ProjectTypeId IS NULL)
			 BEGIN

				SET @ProjectTypeId = NEWID()
		     		INSERT INTO [dbo].[ProjectType](
		     		                                Id,
		     		                                ProjectTypeName,
		     					                    InActiveDateTime,
		     		                                CompanyId,
		     		                                CreatedDateTime,
		     		                                CreatedByUserId,
												    CreatedDateTimeZoneId
												   )
		     		                         SELECT @ProjectTypeId,
		     		                                @ProjectTypeName,
		     					                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
		     		                                @CompanyId,
		     		                                @Currentdate,
		     		                                @OperationsPerformedBy,
													@TimeZoneId
			
			END
			ELSE
		    BEGIN

				UPDATE [dbo].[ProjectType]
					SET ProjectTypeName		=  	  @ProjectTypeName,
		     			InActiveDateTime	=  	  CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
		     			InActiveDateTimeZoneId	= CASE WHEN @IsArchived = 1 THEN @TimeZoneId ELSE NULL END,
		     		    CompanyId			=  	  @CompanyId,
		     		    UpdatedDateTime		=  	  @Currentdate,
		     		    UpdatedByUserId		=  	  @OperationsPerformedBy,
						UpdatedDateTimeZoneId =   @TimeZoneId
					WHERE Id = @ProjectTypeId

			END
		     	SELECT Id FROM [dbo].[ProjectType] WHERE Id = @ProjectTypeId
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