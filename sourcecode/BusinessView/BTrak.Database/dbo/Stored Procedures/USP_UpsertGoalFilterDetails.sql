CREATE PROCEDURE [dbo].[USP_UpsertGoalFilterDetails]
	@GoalFilterId UNIQUEIDENTIFIER = NULL,
	@GoalFilterName NVARCHAR(50) = NULL,
	@IsPublic BIT = NULL,
	@GoalFilterDetailsId UNIQUEIDENTIFIER = NULL,
	@GoalFilterJson NVARCHAR(MAX) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
AS
 BEGIN
	   SET NOCOUNT ON
	   BEGIN TRY
	   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	       DECLARE @NewGoalFilterId UNIQUEIDENTIFIER = NEWID()

		   DECLARE @CurrentDate DATETIME = GETDATE()

		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		   
		   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		   
		   DECLARE @GoalFilterNameCount INT = (SELECT COUNT(1) FROM [GoalFilter] GF INNER JOIN [dbo].[User] U ON GF.CreatedByUserId = U.Id WHERE GF.GoalFilterName = @GoalFilterName AND (GF.Id <> @GoalFilterId OR @GoalFilterId IS NULL) AND GF.InActiveDateTime IS NULL AND U.CompanyId = @CompanyId)
		   
		   IF(@GoalFilterNameCount > 0)
            BEGIN
                
                RAISERROR(50001,16,1,'GoalFilter')
            END

		      IF (@HavePermission = '1')
                BEGIN
				      IF (@GoalFilterId IS NULL)
					   BEGIN
					      INSERT INTO [dbo].[GoalFilter] (
						         [Id],
								 [GoalFilterName],
								 [IsPublic],
								 [CreatedDateTime],
								 [CreatedByUserId]
						     )
                         SELECT @NewGoalFilterId,
						        @GoalFilterName,
								@IsPublic,
								@CurrentDate,
								@OperationsPerformedBy

						 INSERT INTO [dbo].[UserGoalFilter](
						        [Id],
								[GoalFilterId],
								[GoalFilterJson],
								[CreatedDateTime],
								[CreatedByUserId]
						      )
						SELECT NEWID(),
						       @NewGoalFilterId,
							   @GoalFilterJson,
							   @CurrentDate,
							   @OperationsPerformedBy
					   END
					  ELSE
					    BEGIN
						  UPDATE [dbo].[GoalFilter]
						       SET GoalFilterName = @GoalFilterName,
								   IsPublic = @IsPublic,
								   UpdatedByUserId = @OperationsPerformedBy,
								   UpdatedDateTime = @CurrentDate
							  WHERE Id = @GoalFilterId

					         UPDATE [dbo].[UserGoalFilter]
						       SET GoalFilterId = @GoalFilterId,
								   GoalFilterJson = @GoalFilterJson,
								   UpdatedByUserId = @OperationsPerformedBy,
								   UpdatedDateTime = @CurrentDate
							  WHERE Id = @GoalFilterDetailsId
					   END
					SELECT @NewGoalFilterId
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
GO