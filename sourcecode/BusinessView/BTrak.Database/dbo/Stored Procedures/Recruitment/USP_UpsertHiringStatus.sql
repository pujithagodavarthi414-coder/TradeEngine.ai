CREATE PROCEDURE [dbo].[USP_UpsertHiringStatus]
(
   @HiringStatusId UNIQUEIDENTIFIER = NULL,
   @Status NVARCHAR(50) = NULL,
   @Color NVARCHAR(50) = NULL,
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

			DECLARE @HiringStatusIdCount INT = (SELECT COUNT(1) FROM HiringStatus  WHERE Id = @HiringStatusId)

			DECLARE @HiringStatusOrderCount INT = (SELECT COUNT(1) FROM HiringStatus WHERE [Order] = @Order AND CompanyId = @CompanyId AND (@HiringStatusId IS NULL OR @HiringStatusId <> Id))

			DECLARE @HiringStatusCount INT = (SELECT COUNT(1) FROM HiringStatus WHERE [Status] = @Status AND CompanyId = @CompanyId AND (@HiringStatusId IS NULL OR @HiringStatusId <> Id))
			
			DECLARE @IsInUse INT = (select COUNT(1) from candidatejobopening CJO
										INNER JOIN JobOpening JO ON JO.Id = CJO.JobOpeningId
										INNER JOIN [User] U ON U.Id = JO.HiringManagerId
											WHERE U.CompanyId=@CompanyId AND CJO.HiringStatusId = @HiringStatusId
											)
       
			IF(@IsInUse > 0 AND @IsArchived = 1)
			BEGIN

			    RAISERROR(50002,16, 2,'HiringStatusUse')

			END
			IF(@HiringStatusIdCount = 0 AND @HiringStatusId IS NOT NULL)
			BEGIN

			    RAISERROR(50002,16, 2,'HiringStatus')

			END
			IF (@HiringStatusCount > 0)
			BEGIN

				RAISERROR(50001,11,1,'HiringStatus')

			END
			IF (@HiringStatusOrderCount > 0)
			BEGIN

				RAISERROR(50001,11,1,'HiringStatusOrder')

			END
			ELSE        
			BEGIN
       
			    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
				
				IF (@HavePermission = '1')
				BEGIN
				     	
				   DECLARE @IsLatest BIT = (CASE WHEN @HiringStatusId IS NULL THEN 1 
						                         ELSE CASE WHEN (SELECT [TimeStamp] FROM [HiringStatus] WHERE Id = @HiringStatusId  AND CompanyId = @CompanyId) = @TimeStamp THEN 1 ELSE 0 END END)
				     
				   IF(@IsLatest = 1)
				   BEGIN
				     
				      DECLARE @Currentdate DATETIME = GETDATE()
				             
			          IF(@HiringStatusId IS NULL)
					  BEGIN

						 SET @HiringStatusId = NEWID()

						 INSERT INTO [dbo].[HiringStatus]([Id],
														  [CompanyId],
								                          [Status],
														  [Color],
								                          [Order],
								                          [InActiveDateTime],
								                          [CreatedDateTime],
								                          [CreatedByUserId])
								                   SELECT @HiringStatusId,
								                          @CompanyId,
								                          @Status,
														  @Color,
														  @Order,
								                          CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,						 
								                          @Currentdate,
								                          @OperationsPerformedBy		
							         
					END
					ELSE
					BEGIN

						UPDATE [HiringStatus] SET CompanyId = @CompanyId,
								                  [Status] = @Status,
												  [color] = @Color,
									              [Order] = @Order,
									              InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									              UpdatedDateTime = @Currentdate,
									              UpdatedByUserId = @OperationsPerformedBy
						WHERE Id = @HiringStatusId

					END
				            
				    SELECT Id FROM [dbo].[HiringStatus] WHERE Id = @HiringStatusId
				                   
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