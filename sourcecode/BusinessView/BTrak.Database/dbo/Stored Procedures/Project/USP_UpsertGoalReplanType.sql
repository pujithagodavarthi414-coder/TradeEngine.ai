-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-10 00:00:00.000'
-- Purpose      To Save or Update GoalReplanType
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertGoalReplanType] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
-- @GoalReplanTypeName=' Type',@IsArchived=1
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertGoalReplanType]
(
  @GoalReplanTypeId UNIQUEIDENTIFIER = NULL,
  @GoalReplanTypeName NVARCHAR(100) = NULL,
  @TimeZone NVARCHAR(100) = NULL,
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
			   IF(@IsArchived = 1 AND @GoalReplanTypeId IS NOT NULL)
		       BEGIN
		       DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
               IF(EXISTS(SELECT Id FROM [GoalReplan] WHERE GoalReplanTypeId = @GoalReplanTypeId))
               BEGIN
               SET @IsEligibleToArchive = 'ThisGoalReplanTypeUsedInGoalReplanDeleteTheDependenciesAndTryAgain'
               END
			   IF(@IsEligibleToArchive <> '1')
               BEGIN
                RAISERROR (@isEligibleToArchive,11, 1)
               END
		    END

	            DECLARE @TimeZoneId UNIQUEIDENTIFIER = NULL,@Offset NVARCHAR(100) = NULL
			
			    SELECT @TimeZoneId = Id,@Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone
			

                DECLARE @Currentdate DATETIMEOFFSET =  dbo.Ufn_GetCurrentTime(@Offset)
				
				--DECLARE @Currentdate DATETIME = SYSDATETIMEOFFSET()
				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
				DECLARE @GoalReplanTypeIdCount INT = (SELECT COUNT(1) FROM GoalReplanType WHERE Id = @GoalReplanTypeId AND CompanyId = @CompanyId)
				DECLARE @GoalReplanTypeNameCount INT = (SELECT COUNT(1) FROM GoalReplanType WHERE GoalReplanTypeName = @GoalReplanTypeName AND CompanyId = @CompanyId  AND (Id <> @GoalReplanTypeId OR @GoalReplanTypeId IS NULL))
				IF(@GoalReplanTypeIdCount = 0 AND @GoalReplanTypeId IS NOT NULL)
				 
				BEGIN
					RAISERROR(50002,16, 1,'GoalReplanType')
				END
				ELSE IF(@GoalReplanTypeNameCount > 0)
				BEGIN
					RAISERROR(50001,16,1,'GoalReplanType')
				END
				ELSE
				BEGIN
					DECLARE @IsLatest BIT = (CASE WHEN @GoalReplanTypeId IS NULL
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM [GoalReplanType] WHERE Id = @GoalReplanTypeId) = @TimeStamp
																THEN 1 ELSE 0 END END)
					IF(@IsLatest = 1)
					BEGIN
					
					IF (@GoalReplanTypeId IS NULL)
					BEGIN

						SET @GoalReplanTypeId = NEWID()
						INSERT INTO [dbo].[GoalReplanType](
					        	            Id,
					        	            GoalReplanTypeName,
					        	            CompanyId,
					        	            CreatedDateTime,
					        	            CreatedByUserId,
											CreatedDateTimeZoneId,
											InActiveDateTime,
											[IsCustomer],
											[IsDeveloper],
											[IsOfficeAdministration],
											[IsUnplannedLeaves]
											)
					        	     SELECT @GoalReplanTypeId,
					        	            @GoalReplanTypeName,
					        	            @CompanyId,
					        	            @Currentdate,
					        	            @OperationsPerformedBy,
											@TimeZoneId,
											CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
					                        IsCustomer,
											IsDeveloper,
											IsOfficeAdministration,
											IsUnplannedLeaves
                        FROM GoalReplanType WHERE Id = @GoalReplanTypeId

					END
					ELSE
					BEGIN

							UPDATE [dbo].[GoalReplanType]
								SET  GoalReplanTypeName					=  		   @GoalReplanTypeName,
					        	            CompanyId					=  		   @CompanyId,
					        	            UpdatedDateTime				=  		   @Currentdate,
					        	            UpdatedByUserId				=  		   @OperationsPerformedBy,
											[UpdatedDateTimeZoneId]     =          @TimeZoneId,
											InActiveDateTime			=  		 CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
											[IsCustomer]				=  		   IsCustomer,
											[IsDeveloper]				=  		 IsDeveloper,
											[IsOfficeAdministration]	=  		 IsOfficeAdministration,
											[IsUnplannedLeaves]		   	=  		 IsUnplannedLeaves
								WHERE Id = @GoalReplanTypeId

					END
						SELECT Id FROM [dbo].[GoalReplanType] WHERE Id = @GoalReplanTypeId
					END	
					ELSE
			  		RAISERROR (50008,11, 1)
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
