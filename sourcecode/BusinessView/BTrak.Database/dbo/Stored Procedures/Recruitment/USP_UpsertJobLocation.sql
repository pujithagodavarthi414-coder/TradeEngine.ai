CREATE PROCEDURE [dbo].[USP_UpsertJobLocation]
(
   @JobLocationId UNIQUEIDENTIFIER = NULL,
   @JobOpeningId UNIQUEIDENTIFIER = NULL,
   @BranchId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN

		SET NOCOUNT ON
		BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@JobOpeningId IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'JobOpeningId')

		END
		IF(@BranchId IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'BranchId')

		END
		ELSE
		BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @JobLocationIdCount INT = (SELECT COUNT(1) FROM JobLocation  WHERE Id = @JobLocationId)

			DECLARE @JobLocationCount INT = (SELECT COUNT(1) FROM JobLocation WHERE JobOpeningId = @JobOpeningId AND BranchId = @BranchId AND (@JobLocationId IS NULL OR @JobLocationId <> Id))
       
			IF(@JobLocationIdCount = 0 AND @JobLocationId IS NOT NULL)
			BEGIN

			    RAISERROR(50002,16, 2,'JobLocation')

			END
			IF (@JobLocationCount > 0)
			BEGIN

				RAISERROR(50001,11,1,'JobLocation')

			END
			ELSE        
			BEGIN
       
			    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
				
				IF (@HavePermission = '1')
				BEGIN
				     	
				   DECLARE @IsLatest BIT = (CASE WHEN @JobLocationId IS NULL THEN 1 
						                         ELSE CASE WHEN (SELECT [TimeStamp] FROM [JobLocation] WHERE Id = @JobLocationId) = @TimeStamp THEN 1 ELSE 0 END END)
				     
				   IF(@IsLatest = 1)
				   BEGIN
				     
				      DECLARE @Currentdate DATETIME = GETDATE()
				             
			          IF(@JobLocationId IS NULL)
					  BEGIN

						 SET @JobLocationId = NEWID()

						 INSERT INTO [dbo].[JobLocation]([Id],
														  JobOpeningId,
								                          BranchId,
								                          [InActiveDateTime],
								                          [CreatedDateTime],
								                          [CreatedByUserId])
								                   SELECT @JobLocationId,
								                          @JobOpeningId,
								                          @BranchId,
								                          CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,						 
								                          @Currentdate,
								                          @OperationsPerformedBy		
							         
					END
					ELSE
					BEGIN

						UPDATE [JobLocation] SET JobOpeningId = @JobOpeningId,
								                  BranchId = @BranchId,
									              InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									              UpdatedDateTime = @Currentdate,
									              UpdatedByUserId = @OperationsPerformedBy
						WHERE Id = @JobLocationId

					END
				            
				    SELECT Id FROM [dbo].[JobLocation] WHERE Id = @JobLocationId
				                   
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
