-------------------------------------------------------------------------------------------
-- Author       Padmini B
-- Created      '2019-04-17 00:00:00.000'
-- Purpose      To Delete Project
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-----------------------------------------------------------------------------------------
--DECLARE @Temp TIMESTAMP = (SELECT TimeStamp FROM Project WHERE Id = '53C96173-0651-48BD-88A9-7FC79E836CCE')
--EXEC [dbo].[USP_DeleteProject] @ProjectId='53C96173-0651-48BD-88A9-7FC79E836CCE'
--,@TimeStamp = @Temp
--,@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-----------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_DeleteProject]
(
    @ProjectId UNIQUEIDENTIFIER = NULL,
    @TimeStamp TIMESTAMP = NULL,
    @IsArchived BIT = NULL,
	@TimeZone NVARCHAR(250) = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

        DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

        IF (@HavePermission = '1')
        BEGIN
            
			DECLARE @IsLatest BIT = (CASE WHEN (SELECT [TimeStamp] FROM [Project] WHERE Id = @ProjectId) = @TimeStamp THEN 1 ELSE 0 END)

			 DECLARE @TimeZoneId UNIQUEIDENTIFIER = NULL,@Offset NVARCHAR(100) = NULL
			
	         SELECT @TimeZoneId = Id,@Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone
			 

             DECLARE @Currentdate DATETIMEOFFSET =  dbo.Ufn_GetCurrentTime(@Offset)

            IF (@IsLatest = 1)
            BEGIN

                --DECLARE @CurrentDate DATETIME = SYSDATETIMEOFFSET()

                DECLARE @NewProjectId UNIQUEIDENTIFIER = NEWID()

				EXEC [USP_InsertProjectAuditHistory] @ProjectId = @ProjectId,
				                                     @IsArchived = @IsArchived,
													 @TimeZoneId = @TimeZoneId,
                                                     @OperationsPerformedBy = @OperationsPerformedBy

                UPDATE [Project]
                SET UpdatedDateTimeZone = @TimeZoneId,
				    InActiveDateTimeZoneId=CASE WHEN @IsArchived = 1 THEN @TimeZoneId ELSE NULL END,
				    InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
                WHERE Id = @ProjectId

                SELECT Id
                FROM [dbo].[Project]
                WHERE Id = @NewProjectId

            END
            ELSE
                RAISERROR(50015, 11, 1)
        END
        ELSE
            RAISERROR(@HavePermission, 11, 1)
    END TRY
    BEGIN CATCH
        THROW
    END CATCH
END
GO