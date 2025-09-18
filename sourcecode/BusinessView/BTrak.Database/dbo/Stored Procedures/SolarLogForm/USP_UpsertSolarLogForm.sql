CREATE PROCEDURE [dbo].[USP_UpsertSolarLogForm]
(
   @SiteId UNIQUEIDENTIFIER = NULL,
   @SolarId UNIQUEIDENTIFIER = NULL,
   @Confirm BIT = NULL,
   @SolarLogValue Decimal(20,4) = NULL,
   @Date DATETIME = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	    IF(@SolarLogValue IS NULL) SET @SolarLogValue = NULL

	    IF(@SolarLogValue IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'SolorLogvalue')

		END
		ELSE
		BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

        DECLARE @SolorCount INT = (SELECT COUNT(1) FROM [SolarLogForm]  WHERE Id = @SolarId )
        
        IF(@SolorCount = 0 AND @SolarId IS NOT NULL)
        BEGIN

            RAISERROR(50002,16, 2,'Solor')

        END
        ELSE
        BEGIN
       
             DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
             IF (@HavePermission = '1')
             BEGIN
                        
                  DECLARE @IsLatest BIT = (CASE WHEN @SolarId  IS NULL 
                                                      THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                                                                FROM [SolarLogForm] WHERE Id = @SolarId) = @TimeStamp
                                                                        THEN 1 ELSE 0 END END)
                     
                  IF(@IsLatest = 1)
                  BEGIN
                     
                       DECLARE @Currentdate DATETIME = GETDATE()
                       
                     IF(@SolarId IS NULL)
					 BEGIN

					 SET @SolarId = NEWID()

                       INSERT INTO [dbo].[SolarLogForm](
                                   [Id],
                                   [SiteId],
                                   [IsConfirm],
                                   [SolarLogValue],
                                   [SelectedDate],
                                   [InActiveDateTime],
                                   [CreatedDateTime],
                                   [CreatedByUserId],
                                   [CompanyId]
                                   )
                            SELECT @SolarId,
                                   @SiteId,
                                   @Confirm,
                                   @SolarLogValue,
                                   @Date,
                                   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
                                   @Currentdate,
                                   @OperationsPerformedBy,
                                   @CompanyId
                                   
						END
						ELSE
						BEGIN

						UPDATE [SolarLogForm]
						   SET [SiteId] = @SiteId,
                               [IsConfirm] = @Confirm,
                               [SolarLogValue] = @SolarLogValue,
                               [SelectedDate] = @Date,
                               [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
							   UpdatedDateTime = @Currentdate,
							   UpdatedByUserId = @OperationsPerformedBy,
                               [CompanyId] = @CompanyId
							   WHERE Id = @SolarId

						END

                            
                         SELECT Id FROM [dbo].[SolarLogForm] WHERE Id = @SolarId
                                   
                  END
                  ELSE
                     
                        RAISERROR (50008,11, 1)
                     
                  END
                  ELSE
                  BEGIN
                  
                         RAISERROR (@HavePermission,11, 1)
                         
                  END
           END
        END
    END TRY
    BEGIN CATCH
        
        THROW
    END CATCH
END
GO