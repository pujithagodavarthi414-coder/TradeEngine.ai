CREATE PROCEDURE [dbo].[USP_ArchiveUserGoalFilter]
	@GoalFilterId UNIQUEIDENTIFIER = NULL,
	@IsArchived BIT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
AS
	BEGIN
	  SET NOCOUNT ON
	  BEGIN TRY
	  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	  DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
	  DECLARE @CurrentDate DATETIME = GETDATE()
	     IF (@HavePermission = '1')
                BEGIN
				   Update [dbo].[GoalFilter]
				     SET InActiveDateTime = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END
					 WHERE Id = @GoalFilterId

				   Update [dbo].[UserGoalFilter]
				     SET InActiveDateTime = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END
					 WHERE GoalFilterId = @GoalFilterId
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
