CREATE PROCEDURE [dbo].[USP_UpsertHourlyTdsConfiguration]
(
   @Id UNIQUEIDENTIFIER = NULL,
   @BranchId UNIQUEIDENTIFIER = NULL,
   @MaxLimit DECIMAL(18,4) = NULL,
   @TaxPercentage DECIMAL(18,4) = NULL,
   @ActiveFrom DATETIMEOFFSET,
   @ActiveTo DATETIMEOFFSET = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    
	BEGIN TRY
		
		IF(@BranchId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Branch')

		END
		ELSE IF(@MaxLimit IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'MaxLimit')

		END
		ELSE IF(@TaxPercentage IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'TaxPercentage')

		END
		ELSE IF(@ActiveFrom IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'ActiveFrom')

		END

		DECLARE @HourlyTdsCount INT = 0
		
		IF(@ActiveTo IS NULL)
		BEGIN
			SET @HourlyTdsCount = (SELECT COUNT(1) FROM HourlyTdsConfiguration WHERE BranchId = @BranchId AND (Id <> @Id OR @Id IS NULL) AND
																						((@ActiveFrom <= ActiveFrom AND (ActiveTo IS NULL OR @ActiveFrom <= ActiveTo ) AND @ActiveTo IS NULL)
																						OR (@ActiveFrom >= ActiveFrom AND (ActiveTo IS NULL OR @ActiveFrom <= ActiveTo ) AND @ActiveTo IS NULL)))
		END
		IF(@ActiveTo IS NOT NULL)
		BEGIN
			SET @HourlyTdsCount = (SELECT COUNT(1) FROM HourlyTdsConfiguration WHERE BranchId = @BranchId AND (Id <> @Id OR @Id IS NULL) AND
																						((@ActiveFrom <= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo <= ActiveTo AND @ActiveTo >= ActiveFrom )))
																						OR (@ActiveFrom <= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo >= ActiveTo AND @ActiveTo >= ActiveFrom )))
																						OR (@ActiveFrom >= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo <= ActiveTo AND @ActiveTo >= ActiveFrom )))
																						OR (@ActiveFrom >= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo >= ActiveTo AND @ActiveTo >= ActiveFrom AND @ActiveFrom <= ActiveTo)))))
		END

		IF(@HourlyTdsCount > 0)
		BEGIN
			RAISERROR(50001,16, 2, 'HourlyTds')
		END

		DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
		BEGIN
			
			DECLARE @IsLatest BIT = (CASE WHEN @Id  IS NULL
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                           FROM [HourlyTdsConfiguration] WHERE Id = @Id) = @TimeStamp
			         									THEN 1 ELSE 0 END END)
			
			IF(@IsLatest = 1)
			BEGIN
				
				IF(@Id IS NULL)
				BEGIN
					
					INSERT INTO [dbo].[HourlyTdsConfiguration](
															[Id],
															[BranchId],
															[MaxLimit],
															[TaxPercentage],
															[ActiveFrom],
															[ActiveTo],
															[CreatedDateTime],
															[CreatedByUserId]
															)
												SELECT NEWID(),
													   @BranchId,
													   @MaxLimit,
													   @TaxPercentage,
													   @ActiveFrom,
													   @ActiveTo,
													   GETDATE(),
													   @OperationsPerformedBy
					SELECT 'Inserted Successfully'
				END
				ELSE
				BEGIN

					UPDATE [dbo].[HourlyTdsConfiguration]
							SET BranchId = @BranchId,
							MaxLimit = @MaxLimit,
							TaxPercentage = @TaxPercentage,
							ActiveFrom = @ActiveFrom,
							ActiveTo = @ActiveTo,
							UpdatedByUserId = @OperationsPerformedBy,
							UpdatedDateTime = GETDATE(),
							InActiveDateTime = NULL
 							WHERE Id = @Id

					IF(@IsArchived = 1)
					BEGIN
						
						UPDATE [dbo].[HourlyTdsConfiguration] 
								SET InActiveDateTime = GETDATE() 
								WHERE Id = @Id

					END

					SELECT 'Updated Successfully'

				END
			END
			ELSE
			BEGIN
				RAISERROR (50008,11, 1)
			END

		END

		ELSE
		BEGIN

			RAISERROR (@HavePermission,11, 1)

		END

	END TRY

	BEGIN CATCH
		THROW
	END CATCH

END
