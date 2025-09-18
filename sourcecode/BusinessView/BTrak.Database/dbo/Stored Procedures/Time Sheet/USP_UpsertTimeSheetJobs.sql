Create PROCEDURE  [dbo].[USP_UpsertTimeSheetJobs]
(  
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @JobId NVARCHAR(200),
   @IsArchive BIT = NULL,
   @IsForProbation BIT = NULL
)  
AS  
BEGIN  
 SET NOCOUNT ON  
 BEGIN TRY  
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
     IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL  

     IF(@IsArchive = NULL) SET @IsArchive = 0  
	 IF(@IsForProbation = NULL) SET @IsForProbation = 0  
  
	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	DECLARE @ID UNIQUEIDENTIFIER = NEWID()

	DECLARE @Currentdate DATETIME = GETDATE()  
	IF(@IsArchive = 0)
	BEGIN
		INSERT INTO [TimeSheetJobDetails] 
				(Id,JobId,CreatedDateTime,CreatedByUserId,CompanyId,IsForProbation)
			VALUES 
				( @ID,@JobId,@Currentdate,@OperationsPerformedBy,@CompanyId,@IsForProbation)
	END
	ELSE
		BEGIN
			UPDATE [TimeSheetJobDetails] SET InActiveDateTime = @Currentdate WHERE JobId = @JobId
		END

	select @ID

END TRY  
 BEGIN CATCH  
  
  THROW  
  
 END CATCH  
  
END 
