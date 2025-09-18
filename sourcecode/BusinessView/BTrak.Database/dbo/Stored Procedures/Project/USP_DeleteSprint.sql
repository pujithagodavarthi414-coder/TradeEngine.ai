CREATE PROCEDURE [dbo].[USP_DeleteSprint]
	@SprintId UNIQUEIDENTIFIER = NULL,
	@IsArchived BIT = NULL,
	@TimeStamp TIMESTAMP = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER 
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

            DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM [dbo].[Sprints] WHERE Id = @SprintId)

			DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))

		    IF (@HavePermission = '1')
            BEGIN
			   DECLARE @IsLatest BIT = (CASE WHEN (SELECT [TimeStamp]
                                               FROM [Sprints] WHERE Id = @SprintId) = @TimeStamp
                                         THEN 1 ELSE 0 END)
			   IF(@IsLatest = 1)
               BEGIN
			        IF (@IsArchived IS NULL) SET @IsArchived = 0
			   
			        DECLARE @CurrentDate DATETIME = SYSDATETIMEOFFSET()

			        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

					DECLARE @OldIsArchived BIT = NULL

					SELECT @OldIsArchived = IIF(InActiveDateTime IS NOT NULL,1,0) FROM Sprints WHERE Id = @SprintId

					DECLARE @OldValue NVARCHAR(500)

					DECLARE @NewValue NVARCHAR(500)

					DECLARE @FieldName NVARCHAR(200)

					DECLARE @HistoryDescription NVARCHAR(800)

					IF (@OldIsArchived <> @IsArchived)
                    BEGIN
                            SET @OldValue = IIF(@OldIsArchived IS NULL,'',IIF(@OldIsArchived = 0,'No','Yes'))
		                    SET @NewValue = IIF(@IsArchived IS NULL,'',IIF(@IsArchived = 0,'No','Yes'))
                            SET @FieldName = 'SprintDeleted'
                            SET @HistoryDescription = 'SprintDeleted'
                            INSERT INTO SprintHistory
                            (
                                Id,
                                SprintId,
                                FieldName,
                                OldValue,
                                NewValue,
                                [Description],
								CreatedByUserId,
                                CreatedDateTime
                            )
                            SELECT NEWID(),
                                   @SprintId,
                                   @FieldName,
                                   @OldValue,
                                   @NewValue,
                                   @HistoryDescription,
                                   @OperationsPerformedBy,
                                   GETDATE()
                        END

					 UPDATE [Sprints]
			         SET InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END
					 WHERE Id = @SprintId
					 
					   SELECT Id FROM [dbo].[Sprints] WHERE Id = @SprintId
			   END
			 ELSE

               RAISERROR (50015,11, 1)
       END

       ELSE

           RAISERROR (@HavePermission,11, 1)

   END TRY
   BEGIN CATCH

       THROW

   END CATCH
END
GO
