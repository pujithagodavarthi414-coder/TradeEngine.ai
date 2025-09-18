
CREATE PROCEDURE [dbo].[USP_DeleteTemplate]
(
	@TemplateId UNIQUEIDENTIFIER = NULL,
    @TimeStamp TIMESTAMP = NULL,
    @IsArchived BIT = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
       SET NOCOUNT ON
       BEGIN TRY
	   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	     
		
		 DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		 DECLARE @ProjectId UNIQUEIDENTIFIER, @TemplateName NVARCHAR(500) 
		 
		 SELECT @ProjectId = ProjectId, @TemplateName = TemplateName FROM Templates WHERE Id = @TemplateId

	     DECLARE @IsLatest BIT = (CASE WHEN (SELECT [TimeStamp] FROM [Templates] WHERE Id = @TemplateId) = @TimeStamp THEN 1 ELSE 0 END)

		    IF (@IsLatest = 1)
            BEGIN

                DECLARE @CurrentDate DATETIME = SYSDATETIMEOFFSET()

                UPDATE [Templates]
                SET InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
                WHERE Id = @TemplateId

				EXEC USP_InsertProjectHistory @ProjectId = @ProjectId, @OldValue = '', @NewValue = @TemplateName, @FieldName = 'TemplateDeleted',
		                                      @Description = 'TemplateDeleted', @OperationsPerformedBy = @OperationsPerformedBy

                SELECT @TemplateId

            END
            ELSE
                RAISERROR(50015, 11, 1)
			
       END TRY
    BEGIN CATCH
        THROW
    END CATCH
END
GO