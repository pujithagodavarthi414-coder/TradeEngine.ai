CREATE PROCEDURE [dbo].[USP_UpsertJobOpeningStatus]
(
   @JobOpeningStatusId UNIQUEIDENTIFIER = NULL,
   @Status NVARCHAR(50) = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @Order INT,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	 --   IF(@IsArchived = 1 AND @JobOpeningStatusId IS NOT NULL)
		--BEGIN
		--      DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
	 --         IF(EXISTS(SELECT Id FROM JobOpening WHERE JobOpeningStatusId = @JobOpeningStatusId AND InactiveDateTime IS NULL))
	 --         BEGIN
	 --         SET @IsEligibleToArchive = 'ThisStatusUsedInJobOpeningPleaseDeleteTheDependenciesAndTryAgain'
	 --         END
		--      IF(@IsEligibleToArchive <> '1')
		--      BEGIN
		--         RAISERROR (@isEligibleToArchive,11, 1)
		--     END
	 --   END

	    IF(@Status IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'Status')

		END
		ELSE IF(@Order IS NULL)
	    BEGIN

		   RAISERROR(50011,16, 2, 'Order')

		END
		ELSE
		BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @JobOpeningStatusIdCount INT = (SELECT COUNT(1) FROM JobOpeningStatus  WHERE Id = @JobOpeningStatusId)
		DECLARE @JobOpeninStatusOrderCount INT = (SELECT COUNT(1) FROM JobOpeningStatus WHERE [Order] = @Order AND CompanyId = @CompanyId AND (@JobOpeningStatusId IS NULL OR @JobOpeningStatusId <> Id) AND InActiveDateTime IS NULL)
		DECLARE @JobOpeningStatusCount INT = (SELECT COUNT(1) FROM JobOpeningStatus WHERE [Status] = @Status AND CompanyId = @CompanyId 
																		AND (@JobOpeningStatusId IS NULL OR @JobOpeningStatusId <> Id))
       
	    DECLARE @IsInUse INT = (select COUNT(1) from JobOpening JO
									INNER JOIN JobOpeningStatus JOS ON JOS.Id = JO.JobOpeningStatusId
											WHERE JOS.CompanyId=@CompanyId AND JO.JobOpeningStatusId = @JobOpeningStatusId
											)
       
			IF(@IsInUse > 0 AND @IsArchived = 1)
			BEGIN

			    RAISERROR(50002,16, 2,'JobOpeningStatusUse')

			END
			IF (@JobOpeninStatusOrderCount > 0 AND @IsArchived = 0)
			BEGIN

				RAISERROR(50001,11,1,'JobOpeninStatusOrder')

			END
		IF(@JobOpeningStatusIdCount = 0 AND @JobOpeningStatusId IS NOT NULL)
        BEGIN

            RAISERROR(50002,16, 2,'JobOpeningStatus')

        END
		IF (@JobOpeningStatusCount > 0)
		BEGIN

			RAISERROR(50001,11,1,'JobOpeningStatus')

		END
        ELSE        
		  BEGIN
       
		             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			         IF (@HavePermission = '1')
			         BEGIN
			         	
			         	DECLARE @IsLatest BIT = (CASE WHEN @JobOpeningStatusId  IS NULL 
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                                    FROM [JobOpeningStatus] WHERE Id = @JobOpeningStatusId  AND CompanyId = @CompanyId) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			         
			             IF(@IsLatest = 1)
			         	BEGIN
			         
			                 DECLARE @Currentdate DATETIME = GETDATE()
			                 
                            IF(@JobOpeningStatusId IS NULL)
							BEGIN

							SET @JobOpeningStatusId = NEWID()

							INSERT INTO [dbo].[JobOpeningStatus](
                                                              [Id],
															  [CompanyId],
						                                      [Status],
						                                      [Order],
						                                      [InActiveDateTime],
						                                      [CreatedDateTime],
						                                      [CreatedByUserId]				
															  )
                                                       SELECT @JobOpeningStatusId,
						                                      @CompanyId,
						                                      @Status,
															  @Order,
						                                      CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,						 
						                                      @Currentdate,
						                                      @OperationsPerformedBy		
		                     
							END
							ELSE
							BEGIN

							  UPDATE [JobOpeningStatus]
							      SET CompanyId = @CompanyId,
								      [Status] = @Status,
									  [Order] = @Order,
									  InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									  UpdatedDateTime = @Currentdate,
									  UpdatedByUserId = @OperationsPerformedBy
									  WHERE Id = @JobOpeningStatusId

							END
			                
			              SELECT Id FROM [dbo].[JobOpeningStatus] WHERE Id = @JobOpeningStatusId
			                       
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