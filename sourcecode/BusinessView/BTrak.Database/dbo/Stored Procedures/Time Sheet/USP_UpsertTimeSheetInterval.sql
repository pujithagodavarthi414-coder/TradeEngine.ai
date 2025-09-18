-----------------------------------------------------------------------------------------------------------------------
--EXEC USP_UpsertTimeSheetSubmission @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@TimeSheetFrequencyId = '5BA47E73-8FC7-43F3-8A6D-39628E93F847', @ActiveFrom='2020-02-24'
-----------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [USP_UpsertTimeSheetInterval]
(
    @TimeSheetIntervalId UNIQUEIDENTIFIER = NULL,
    @TimeSheetFrequencyId UNIQUEIDENTIFIER,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
            
             IF(@OperationsPerformedBy ='00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy=NULL

             DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))  

             DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

             DECLARE @TimeSheetButtonCount INT = (SELECT COUNT(1) FROM TimeSheetSubmission WHERE Id = @TimeSheetIntervalId AND InActiveDateTime IS NULL)

             IF(@TimeSheetFrequencyId IS NULL)
             BEGIN
                RAISERROR(50011,16,1,'TimeSheetFrequency')
             END
             ELSE
             BEGIN
                    
                    IF(@HavePermission = '1')
                    BEGIN
                            DECLARE @IsLatest BIT = (CASE WHEN @TimeSheetIntervalId IS NULL 
                                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                                                       FROM TimeSheetInterval WHERE Id = @TimeSheetIntervalId ) = @TimeStamp
                                                                THEN 1 ELSE 0 END END)
                    IF(@IsLatest = 1)
                    BEGIN
                        IF(@TimeSheetIntervalId IS NULL)
                        BEGIN

							SET @TimeSheetIntervalId = NEWID()

                            INSERT INTO TimeSheetInterval(
                                                            Id,
                                                            CreatedDateTime,
                                                            CreatedByUserId,
                                                            CompanyId,
                                                            TimeSheetIntervalFrequency
                                                            )
                                                    SELECT  @TimeSheetIntervalId,
                                                            GETDATE(),
                                                            @OperationsPerformedBy,
                                                            @CompanyId,
                                                            @TimeSheetFrequencyId
                        END
                        ELSE
                        BEGIN
                            UPDATE TimeSheetInterval SET 
                                                           UpdatedByUserId = @OperationsPerformedBy,
                                                           UpdatedDateTime = GETDATE(),
                                                           CompanyId = @CompanyId,
                                                           TimeSheetIntervalFrequency = @TimeSheetFrequencyId
                                                           WHERE Id = @TimeSheetIntervalId
                        END
						SELECT @TimeSheetIntervalId
                    END
                    ELSE
                        
                        RAISERROR(50008,11,1)
                    END
             END
    END TRY
    BEGIN CATCH 
        THROW
    END CATCH

END
GO