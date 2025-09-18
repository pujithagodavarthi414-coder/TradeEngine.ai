CREATE PROCEDURE [dbo].[USP_UpsertJobType]
(
   @JobTypeId UNIQUEIDENTIFIER = NULL,
   @JobTypeName NVARCHAR(50) = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	 --   IF(@IsArchived = 1 AND @SourceId IS NOT NULL)
		--BEGIN
		--      DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
	 --         IF(EXISTS(SELECT Id FROM Candidate WHERE SourceId = @SourceId AND InactiveDateTime IS NULL))
	 --         BEGIN
	 --         SET @IsEligibleToArchive = 'ThisSourceIsLinkedToCandidatePleaseDeleteTheDependenciesAndTryAgain'
	 --         END
		--      IF(@IsEligibleToArchive <> '1')
		--      BEGIN
		--         RAISERROR (@isEligibleToArchive,11, 1)
		--     END
	 --   END

	    IF(@JobTypeName IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'Name')

		END
		ELSE
		BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @JobTypeIdCount INT = (SELECT COUNT(1) FROM Source  WHERE Id = @JobTypeId)

		DECLARE @SourceCount INT = (SELECT COUNT(1) FROM Source WHERE [Name] = @JobTypeName AND CompanyId = @CompanyId 
																		AND (@JobTypeId IS NULL OR @JobTypeId <> Id))
       
	    IF(@JobTypeIdCount = 0 AND @JobTypeId IS NOT NULL)
        BEGIN

            RAISERROR(50002,16, 2,'@JobType')

        END
		IF (@SourceCount > 0)
		BEGIN

			RAISERROR(50001,11,1,'@JobType')

		END
        ELSE        
		  BEGIN
       
		             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			         IF (@HavePermission = '1')
			         BEGIN
			         	
			         	DECLARE @IsLatest BIT = (CASE WHEN @JobTypeId  IS NULL 
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                                    FROM [Source] WHERE Id = @JobTypeId  AND CompanyId = @CompanyId) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			         
			             IF(@IsLatest = 1)
			         	BEGIN
			         
			                 DECLARE @Currentdate DATETIME = GETDATE()
			                 
                            IF(@JobTypeId IS NULL)
							BEGIN

							SET @JobTypeId = NEWID()

							INSERT INTO [dbo].[JobType](
                                                              [Id],
															  [CompanyId],
						                                      [JobTypeName],
						                                      [CreatedDateTime],
						                                      [CreatedByUserId]				
															  )
                                                       SELECT @JobTypeId,
						                                      @CompanyId,
						                                      @JobTypeName,					 
						                                      @Currentdate,
						                                      @OperationsPerformedBy		
		                     
							END
							ELSE
							BEGIN

							  UPDATE [JobType]
							      SET CompanyId = @CompanyId,
								      [JobTypeName] = @JobTypeName
									  WHERE Id = @JobTypeId

							END
			                
			              SELECT Id FROM [dbo].[Source] WHERE Id = @JobTypeId
			                       
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