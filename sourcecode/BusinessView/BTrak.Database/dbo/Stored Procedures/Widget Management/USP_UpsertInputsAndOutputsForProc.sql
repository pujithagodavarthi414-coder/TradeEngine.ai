CREATE PROCEDURE [dbo].[USP_UpsertInputsAndOutputsForProc]
(
   @CustomWidgetId UNIQUEIDENTIFIER = NULL,
   @ProcName NVARCHAR(800) = NULL,  
   @Inputs NVARCHAR(MAX) = NULL,  
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @Outputs NVARCHAR(MAX) = NULL,
   @Legends NVARCHAR(MAX) = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @CustomStoredProcId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	    IF(@CustomWidgetId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'CustomWidgetId')

		END
		ELSE
		BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
        
       
             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
             IF (@HavePermission = '1')
             BEGIN
                        
                  DECLARE @IsLatest BIT = (CASE WHEN @CustomStoredProcId  IS NULL 
                                                      THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                                                                FROM [customstoredprocwidget] WHERE Id = @CustomStoredProcId) = @TimeStamp
                                                                        THEN 1 ELSE 0 END END)
                     
                  IF(@IsLatest = 1)
                  BEGIN
                     
                       DECLARE @Currentdate DATETIME = GETDATE()
                       
                     IF(@CustomStoredProcId IS NULL)
					 BEGIN

					 SET @CustomStoredProcId = NEWID()

                       INSERT INTO [dbo].[CustomStoredProcWidget](
                                   [Id],
								   [CustomWidgetId],
                                   [CompanyId],
                                   [ProcName],
                                   [Inputs],
                                   [Outputs],
								   [Legends],
								   [CreatedDateTime],
                                   [CreatedByUserId]                 
                                   )
                            SELECT @CustomStoredProcId,
                                   @CustomWidgetId,
								   @CompanyId,
								   @ProcName,
                                   @Inputs,
                                   @Outputs,
								   @Legends,
                                   @Currentdate,
                                   @OperationsPerformedBy        
                                   
						END
						ELSE
						BEGIN

						UPDATE [CustomStoredProcWidget]
						   SET [CompanyId] = @CompanyId,
                               [Inputs] = @Inputs,
                               [Outputs] = @Outputs,
							   [Legends] = @Legends,
							   UpdatedDateTime = @Currentdate,
							   UpdatedByUserId = @OperationsPerformedBy
							   WHERE Id = @CustomStoredProcId

						END

                            
                         SELECT Id FROM [dbo].[customstoredprocwidget] WHERE Id = @CustomStoredProcId
                                   
                  END
                  ELSE
                     
                        RAISERROR (50008,11, 1)
                     
                  END
                  ELSE
                  BEGIN
                  
                         RAISERROR (@HavePermission,11, 1)
                         
                  END
        END
    END TRY
    BEGIN CATCH
        
        THROW
    END CATCH
END
GO