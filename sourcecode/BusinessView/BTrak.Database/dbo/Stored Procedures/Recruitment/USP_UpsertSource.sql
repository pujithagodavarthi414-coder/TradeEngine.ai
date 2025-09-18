CREATE PROCEDURE [dbo].[USP_UpsertSource]
(
   @SourceId UNIQUEIDENTIFIER = NULL,
   @Name NVARCHAR(50) = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsReferenceNumberNeeded INT,
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

	    IF(@Name IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'Name')

		END
		ELSE
		BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @SourceIdCount INT = (SELECT COUNT(1) FROM Source  WHERE Id = @SourceId)

		DECLARE @SourceCount INT = (SELECT COUNT(1) FROM Source WHERE [Name] = @Name AND CompanyId = @CompanyId 
																		AND (@SourceId IS NULL OR @SourceId <> Id))
       
	    DECLARE @IsInUse INT = (select COUNT(1) from Candidate C
									INNER JOIN Source S ON S.Id = C.SourceId
											WHERE S.CompanyId=@CompanyId AND C.SourceId = @SourceId
											)
       
			IF(@IsInUse > 0 AND @IsArchived IS NOT NULL)
			BEGIN

			    RAISERROR(50002,16, 2,'SourceInUse')

			END
			IF(@SourceIdCount = 0 AND @SourceId IS NOT NULL)
        BEGIN

            RAISERROR(50002,16, 2,'Source')

        END
		IF (@SourceCount > 0)
		BEGIN

			RAISERROR(50001,11,1,'Source')

		END
        ELSE        
		  BEGIN
       
		             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			         IF (@HavePermission = '1')
			         BEGIN
			         	
			         	DECLARE @IsLatest BIT = (CASE WHEN @SourceId  IS NULL 
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                                    FROM [Source] WHERE Id = @SourceId  AND CompanyId = @CompanyId) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			         
			             IF(@IsLatest = 1)
			         	BEGIN
			         
			                 DECLARE @Currentdate DATETIME = GETDATE()
			                 
                            IF(@SourceId IS NULL)
							BEGIN

							SET @SourceId = NEWID()

							INSERT INTO [dbo].[Source](
                                                              [Id],
															  [CompanyId],
						                                      [Name],
						                                      [IsReferenceNumberNeeded],
						                                      [InActiveDateTime],
						                                      [CreatedDateTime],
						                                      [CreatedByUserId]				
															  )
                                                       SELECT @SourceId,
						                                      @CompanyId,
						                                      @Name,
															  @IsReferenceNumberNeeded,
						                                      CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,						 
						                                      @Currentdate,
						                                      @OperationsPerformedBy		
		                     
							END
							ELSE
							BEGIN

							  UPDATE [Source]
							      SET CompanyId = @CompanyId,
								      [Name] = @Name,
									  [IsReferenceNumberNeeded] = @IsReferenceNumberNeeded,
									  InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									  UpdatedDateTime = @Currentdate,
									  UpdatedByUserId = @OperationsPerformedBy
									  WHERE Id = @SourceId

							END
			                
			              SELECT Id FROM [dbo].[Source] WHERE Id = @SourceId
			                       
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