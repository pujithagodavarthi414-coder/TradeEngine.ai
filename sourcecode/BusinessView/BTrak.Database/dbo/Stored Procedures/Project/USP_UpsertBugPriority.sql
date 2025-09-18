-------------------------------------------------------------------------------
-- Author       Pujitha Godavarthi
-- Created      '2019-01-21 00:00:00.000'
-- Purpose      To Save or Update the BugPriority
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertBugPriority] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
-- @PriorityName='Test',@Color='Test',@Icon='Test'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertBugPriority]
 (
  @BugPriorityId  UNIQUEIDENTIFIER = NULL,
  @PriorityName  NVARCHAR(250) = NULL,
  @Description  NVARCHAR(250) = NULL,
  @Color NVARCHAR(250) = NULL,
  @Icon NVARCHAR(250) = NULL,
  @TimeZone NVARCHAR(250) = NULL,
  @Order INT  = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER ,
  @IsArchived BIT = 0,
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
			IF(@IsArchived = 1 AND @BugPriorityId IS NOT NULL)
		    BEGIN
		         DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
                 IF(EXISTS(SELECT Id FROM [UserStory] WHERE BugPriorityId = @BugPriorityId))
                 BEGIN
                 SET @IsEligibleToArchive = 'ThisBugPriorityUsedInUserStoryDeleteTheDependenciesAndTryAgain'
                 END
			     IF(@IsEligibleToArchive <> '1')
                 BEGIN
                   RAISERROR (@IsEligibleToArchive,11, 1)
                 END
		    END
            DECLARE @IsLatest BIT = (CASE WHEN @BugPriorityId IS NULL
                                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                                                     FROM BugPriority WHERE Id = @BugPriorityId) = @TimeStamp
                                                                THEN 1 ELSE 0 END END)
            IF(@IsLatest = 1)
            BEGIN
                 DECLARE @BugPriorityIdCount INT = (SELECT COUNT(1) FROM BugPriority WHERE Id = @BugPriorityId)

				 DECLARE @TimeZoneId UNIQUEIDENTIFIER = NULL,@Offset NVARCHAR(100) = NULL
			
			     SELECT @TimeZoneId = Id,@Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone

                 DECLARE @Currentdate DATETIMEOFFSET =  ISNULL(dbo.Ufn_GetCurrentTime(@Offset),SYSDATETIMEOFFSET())

                 DECLARE @PriorityNameCount INT = (SELECT COUNT(1) FROM [BugPriority] WHERE PriorityName = @PriorityName AND CompanyId = @CompanyId  AND (@BugPriorityId IS NULL OR Id  <> @BugPriorityId) )
				 
				 IF(@IsArchived IS NULL)SET @IsArchived = 0
                    IF(@PriorityName IS NULL)
                    BEGIN
                    RAISERROR(50011,16, 2, 'PriorityName')
                    END
                    ELSE IF(@BugPriorityIdCount = 0 AND @BugPriorityId IS NOT NULL)
                    BEGIN
                        RAISERROR(50002,16, 1,'BugPriority')
                    END
                    ELSE IF(@PriorityNameCount > 0)
                    BEGIN
                        RAISERROR(50001,16,1,'BugPriority')
                    END
                    ELSE
                    BEGIN
                    
					IF(@BugPriorityId IS NULL)
					BEGIN

					SET @BugPriorityId = NEWID()
					INSERT INTO [dbo].[BugPriority](
                                   [Id],
                                    [PriorityName],
                                    [Color],
                                    [Order],
                                    [Description],
                                    [Icon],
                                    [CompanyId],
                                    [InActiveDateTime],
                                    [CreatedDateTime],
                                    [CreatedByUserId],
									[CreatedDateTimeZoneId],
                                    [IsCritical],
                                    [IsHigh],
                                    [IsMedium],
                                    [IsLow]
                                    )
                         SELECT   @BugPriorityId,
                                   @PriorityName,
                                   @Color,
                                   @Order,
                                   @Description,
                                   ISNULL(@Icon,(SELECT Icon FROM [dbo].[BugPriority] WHERE Id = @BugPriorityId)),
                                   @CompanyId,
                                   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL  END,
                                   @Currentdate,
                                   @OperationsPerformedBy,
								   @TimeZoneId,
                                   IsCritical,
                                   IsHigh ,
                                   IsMedium,
                                   IsLow
                                   FROM BugPriority WHERE Id = @BugPriorityId
					
					END
					ELSE
					BEGIN

							UPDATE [dbo].[BugPriority]
								SET [PriorityName]		  =  	  @PriorityName,
                                    [Color]				  =  	  @Color,
                                    [Order]				  =  	  @Order,
                                    [Description]		  =  	  @Description,
                                    [Icon]				  =  	  ISNULL(@Icon,(SELECT Icon FROM [dbo].[BugPriority] WHERE Id = @BugPriorityId)),
                                    [CompanyId]			  =  	  @CompanyId,
                                    [InActiveDateTime]	  =  	  CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL  END,
                                    [UpdatedDateTime]	  =  	  @Currentdate,
                                    [UpdatedByUserId]	  =  	  @OperationsPerformedBy,
                                    [IsCritical]		  =  	  IsCritical,
                                    [IsHigh]			  =  	  IsHigh ,
                                    [IsMedium]			  =  	  IsMedium,
									[UpdatedDateTimeZoneId] = @TimeZoneId,
                                    [IsLow]				  =  	  IsLow
								WHERE Id = @BugPriorityId

					END
                    SELECT Id FROM [dbo].[BugPriority] WHERE Id = @BugPriorityId
                    END
            END
            ELSE
                RAISERROR (50008,11, 1)
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