-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-03-26 00:00:00.000'
-- Purpose      To Save or Update the ReviewTemplate
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_UpsertReviewTemplate]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@TemplateJson='Test',@UserStorySubTypeId='569C8DCA-F91A-4DEA-AAA9-1C463EF4EA9A'

CREATE PROCEDURE [dbo].[USP_UpsertReviewTemplate]
(
    @ReviewTemplateId UNIQUEIDENTIFIER = NULL,
    @TemplateJson NVARCHAR(250) = NULL,
	@UserStorySubTypeId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

    DECLARE @CurrentDate DATETIME = GETDATE()

	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
     
	IF(@ReviewTemplateId IS NULL)
	BEGIN

	SET @ReviewTemplateId = NEWID()

      INSERT INTO [dbo].[ReviewTemplate](
                        [Id],
                        [TemplateJson],
						[UserStorySubTypeId],
						[CompanyId],
                        [CreatedDateTime],
                        [CreatedByUserId]
                        )
                 SELECT @ReviewTemplateId,
                        @TemplateJson,
						@UserStorySubTypeId,
						@CompanyId,
                        @Currentdate,
                        @OperationsPerformedBy

		END
		ELSE
		BEGIN

		         UPDATE [dbo].[ReviewTemplate]
                   SET  [TemplateJson] = @TemplateJson,
						[UserStorySubTypeId] = @UserStorySubTypeId,
						[CompanyId] = @CompanyId,
                        [UpdatedDateTime] = @CurrentDate,
                        [UpdatedByUserId] = @OperationsPerformedBy
						WHERE Id = @ReviewTemplateId

		END
                 
	SELECT Id FROM [dbo].[ReviewTemplate] WHERE Id = @ReviewTemplateId
    
	END TRY
    BEGIN CATCH

        EXEC USP_GetErrorInformation

    END CATCH
END