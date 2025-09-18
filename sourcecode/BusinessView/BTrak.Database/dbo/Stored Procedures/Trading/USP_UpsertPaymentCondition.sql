-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertPaymentCondition] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
-- @PaymentConditionName = 'Test',@IsArchived = 0
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertPaymentCondition]
(
   @PaymentConditionId UNIQUEIDENTIFIER = NULL,
   @PaymentConditionName NVARCHAR(800)  = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	    IF(@PaymentConditionName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'PaymentConditionName')

		END
		ELSE
		BEGIN
		DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
		--IF(EXISTS(SELECT Id FROM Client WHERE PaymentConditionId = @PaymentConditionId AND @IsArchived=1))
	 --   BEGIN
	 --   SET @IsEligibleToArchive = 'ThisPaymentConditionUsedInClientDeleteTheDependenciesAndTryAgain'
	 --   RAISERROR (@isEligibleToArchive,11, 1)
	 --   END
		
		DECLARE @Currentdate DATETIME = GETDATE()

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @PaymentConditionIdCount INT = (SELECT COUNT(1) FROM [PaymentCondition] WHERE Id = @PaymentConditionId AND CompanyId = @CompanyId )

		DECLARE @PaymentConditionNameCount INT = (SELECT COUNT(1) FROM [PaymentCondition] WHERE PaymentConditionName = @PaymentConditionName AND CompanyId = @CompanyId AND (Id <> @PaymentConditionId OR @PaymentConditionId IS NULL) )
		
		IF(@PaymentConditionIdCount = 0 AND @PaymentConditionId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 2,'PaymentCondition')
		END
		ELSE IF(@PaymentConditionNameCount > 0)
		BEGIN

			RAISERROR(50001,16,1,'PaymentCondition')

		END		
		ELSE 
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @PaymentConditionId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM [PaymentCondition] WHERE Id = @PaymentConditionId ) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN
			      IF(@PaymentConditionId IS NULL)
				  BEGIN

				  SET @PaymentConditionId = NEWID()

			        INSERT INTO [dbo].[PaymentCondition](
			                    [Id],
			                    [PaymentConditionName],
			                    [InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId],
								CompanyId)
			             SELECT @PaymentConditionId,
			                    @PaymentConditionName,
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy,
								@CompanyId
			       
				   END
				   ELSE
				   BEGIN

				    UPDATE [PaymentCondition]
					  SET  [PaymentConditionName] = @PaymentConditionName,
					       CompanyId  = @CompanyId,
					       InActiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
						   UpdatedDateTime  = @Currentdate,
						   UpdatedByUserId = @OperationsPerformedBy
						  WHERE Id = @PaymentConditionId

				   END

			        SELECT Id FROM [dbo].[PaymentCondition] WHERE Id = @PaymentConditionId

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
