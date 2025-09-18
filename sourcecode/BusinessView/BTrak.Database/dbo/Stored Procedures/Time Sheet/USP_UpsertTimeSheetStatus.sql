---------------------------------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertTimeSheetStatus]  @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@StatusName = 'test',
--@StatusColor = 'IND' ,@IsArchived = 0
---------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertTimeSheetStatus]
(
   @StatusId UNIQUEIDENTIFIER = NULL,
   @StatusName NVARCHAR(800) = NULL,  
   @StatusColor NVARCHAR(100) = NULL,  
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	    IF(@StatusName = '') SET @StatusName = NULL

	    IF(@StatusName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'StatusName')

		END
		ELSE
		BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

        DECLARE @StatusCount INT = (SELECT COUNT(1) FROM [Status]  WHERE Id = @StatusId)
        
        IF(@StatusCount = 0 AND @StatusId IS NOT NULL)
        BEGIN

            RAISERROR(50002,16, 2,'Status')

        END
        ELSE
        BEGIN
       
             DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
             IF (@HavePermission = '1')
             BEGIN
                        
                  DECLARE @IsLatest BIT = (CASE WHEN @StatusId  IS NULL 
                                                      THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                                                                FROM [Status] WHERE Id = @StatusId) = @TimeStamp
                                                                        THEN 1 ELSE 0 END END)
                     
                  IF(@IsLatest = 1)
                  BEGIN
                     
                       DECLARE @Currentdate DATETIME = GETDATE()
                       
                     IF(@StatusId IS NULL)
					 BEGIN

					 SET @StatusId = NEWID()

                       INSERT INTO [dbo].[Status](
                                   [Id],
                                   [CompanyId],
                                   [StatusName],
                                   [StatusColour],
                                   [InActiveDateTime],
                                   [CreatedDateTime],
                                   [CreatedByUserId]                 
                                   )
                            SELECT @StatusId,
                                   @CompanyId,
                                   @StatusName,
                                   @StatusColor,
                                   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
                                   @Currentdate,
                                   @OperationsPerformedBy        
                                   
						END
						ELSE
						BEGIN

						UPDATE [Status]
						   SET [CompanyId] = @CompanyId,
                               [StatusName] = @StatusName,
                               [StatusColour] = @StatusColor,
                               [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
							   UpdatedDateTime = @Currentdate,
							   UpdatedByUserId = @OperationsPerformedBy
							   WHERE Id = @StatusId

						END

                            
                         SELECT Id FROM [dbo].[Status] WHERE Id = @StatusId
                                   
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