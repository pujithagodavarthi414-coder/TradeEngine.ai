-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-13 00:00:00.000'
-- Purpose      To Save or Update the GoalStatus
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_UpsertGoalStatus] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@GoalStatusName='Test',@IsCompleted=1

CREATE PROCEDURE [dbo].[USP_UpsertGoalStatus]
(
  @GoalStatusId  UNIQUEIDENTIFIER = NULL,
  @GoalStatusName  NVARCHAR(250) = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @TimeStamp TIMESTAMP = NULL,
  @IsParked BIT = NULL,
  @IsNotNeeded BIT = NULL,
  @IsGaveUp BIT = NULL,
  @IsCompleted BIT = NULL,
  @IsBacklog  BIT = NULL,
  @IsActive BIT = NULL,
  @IsReplan BIT = NULL,
  @IsArchived BIT = NULL
)
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
        IF (@HavePermission = '1')
        BEGIN
			DECLARE @GoalStatusIdCount INT = (SELECT COUNT(1) FROM GoalStatus WHERE Id = @GoalStatusId)

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @GoalStatusNameCount INT = (SELECT COUNT(1) FROM [GoalStatus] WHERE GoalStatusName = @GoalStatusName AND (@GoalStatusId IS NULL OR Id <> @GoalStatusId) AND InActiveDateTime IS NULL)

			IF(@GoalStatusName IS NULL)
			BEGIN

			RAISERROR(50011,16, 2, 'GoalStatusName')

			END
			ELSE IF(@GoalStatusIdCount = 0 AND @GoalStatusId IS NOT NULL)
			BEGIN

				RAISERROR(50002,16, 1,'GoalStatus')

			END
			
			ELSE IF(@GoalStatusNameCount > 0)
			BEGIN

				RAISERROR(50001,16,1,'GoalStatus')

		END
		ELSE
		BEGIN

		DECLARE @IsLatest BIT = (CASE WHEN @GoalStatusId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM GoalStatus WHERE Id = @GoalstatusId) = @TimeStamp THEN 1 ELSE 0 END END )

		IF(@IsLatest = 1)
		BEGIN
		
		DECLARE @Currentdate DATETIME = GETDATE()

		IF(@GoalStatusId IS NULL)
		BEGIN

			SET @GoalStatusId = NEWID()
				       INSERT INTO [dbo].[GoalStatus](
					             [Id],
								-- [CompanyId],
								 [GoalStatusName],
			                     [CreatedDateTime],
								 [CreatedByUserId],
								 [InActiveDateTime]
								 )
					      SELECT @GoalStatusId,
							--	 @CompanyId,
								 @GoalStatusName,
								 @Currentdate,
								 @OperationsPerformedBy,
				                 CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
		
		END
		ELSE
		BEGIN

			UPDATE [dbo].[GoalStatus]
						   	SET  --[CompanyId]			  =   	 @CompanyId,
								 [GoalStatusName]		  =   	 @GoalStatusName,
			                     [UpdatedDateTime]		  =   	 @Currentdate,
								 [UpdatedByUserId]		  =   	 @OperationsPerformedBy,
								 [IsParked]     		  =   	 @IsParked,
								 [IsNotNeeded]   		  =   	 @IsNotNeeded,
								 [IsGaveUp]      		  =   	 @IsGaveUp,
								 [IsCompleted]  		  =   	 @IsCompleted,
								 [IsBackLog]     		  =   	 @IsBacklog,
								 [IsActive]    			  =   	 @IsActive,
								 [IsReplan]    			  =   	 @IsReplan,
								 [InActiveDateTime]		  =   	 CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
							WHERE Id = @GoalStatusId

		END
					  SELECT Id FROM [dbo].[GoalStatus] WHERE Id = @GoalStatusId

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