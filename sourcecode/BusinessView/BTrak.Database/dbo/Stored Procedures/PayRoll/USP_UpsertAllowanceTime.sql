CREATE PROCEDURE [dbo].[USP_UpsertAllowanceTime]
(
   @Id UNIQUEIDENTIFIER = NULL,
   @BranchId UNIQUEIDENTIFIER = NULL,
   @AllowanceRateSheetForId UNIQUEIDENTIFIER = NULL,
   @MaxTime INT = NULL,
   @MinTime INT = NULL,
   @ActiveFrom DATETIME,
   @ActiveTo DATETIME = NULL,
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
		ELSE IF(@AllowanceRateSheetForId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'AllowanceRateSheetForId')

		END
		ELSE IF(@MaxTime IS NULL AND @MinTime IS NULL)
		BEGIN
			
			RAISERROR(50011,16, 2, 'MaxTimeAndMinTime')

		END
		ELSE IF(@ActiveFrom IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'ActiveFrom')

		END

		DECLARE @AllowanceCount INT = 0
		IF(@ActiveTo IS NULL)
		BEGIN
			SET @AllowanceCount = (SELECT COUNT(1) FROM AllowanceTime WHERE BranchId = @BranchId AND AllowanceRateSheetForId = @AllowanceRateSheetForId AND (Id <> @Id OR @Id IS NULL) AND
																						((@ActiveFrom <= ActiveFrom AND (ActiveTo IS NULL OR @ActiveFrom <= ActiveTo ) AND @ActiveTo IS NULL)
																						OR (@ActiveFrom >= ActiveFrom AND (ActiveTo IS NULL OR @ActiveFrom <= ActiveTo ) AND @ActiveTo IS NULL)))
		END
		IF(@ActiveTo IS NOT NULL)
		BEGIN

			SET @AllowanceCount = (SELECT COUNT(1) FROM AllowanceTime WHERE BranchId = @BranchId AND AllowanceRateSheetForId = @AllowanceRateSheetForId AND (Id <> @Id OR @Id IS NULL) AND
																						((@ActiveFrom <= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo <= ActiveTo AND @ActiveTo >= ActiveFrom )))
																						OR (@ActiveFrom <= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo >= ActiveTo AND @ActiveTo >= ActiveFrom )))
																						OR (@ActiveFrom >= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo <= ActiveTo AND @ActiveTo >= ActiveFrom )))
																						OR (@ActiveFrom >= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo >= ActiveTo AND @ActiveTo >= ActiveFrom AND @ActiveFrom <= ActiveTo)))))

		END

		IF(@AllowanceCount > 0)
		BEGIN
			
			RAISERROR(50001,16, 2, 'AllowanceTime')

		END

		
		DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
		BEGIN
			
			DECLARE @IsLatest BIT = (CASE WHEN @Id  IS NULL
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                           FROM [AllowanceTime] WHERE Id = @Id) = @TimeStamp
			         									THEN 1 ELSE 0 END END)

			IF(@IsLatest = 1)
			BEGIN
				
				IF(@Id IS NULL)
				BEGIN
					
					INSERT INTO [dbo].[AllowanceTime](
													[Id],
													[AllowanceRateSheetForId],
													[BranchId],
													[MaxTime],
													[MinTime],
													[ActiveFrom],
													[ActiveTo],
													[CreatedByUserId],
													[CreatedDateTime]
													)
											SELECT NEWID(),
												   @AllowanceRateSheetForId,
												   @BranchId,
												   @MaxTime,
												   @MinTime,
												   @ActiveFrom,
												   @ActiveTo,
												   @OperationsPerformedBy,
												   GETDATE()

					SELECT 'Inserted Successfully'

				END
				ELSE
				BEGIN
					
					UPDATE [dbo].[AllowanceTime]
								SET [AllowanceRateSheetForId] = @AllowanceRateSheetForId,
									[BranchId] = @BranchId,
									[MaxTime] = @MaxTime,
									[MinTime] = @MinTime,
									[ActiveFrom] = @ActiveFrom,
									[ActiveTo] = @ActiveTo,
									[UpdatedByUserId] = @OperationsPerformedBy,
									[UpdatedDateTime] = GETDATE(),
									[InActiveDateTime] = NULL
								WHERE Id = @Id
				
					IF(@IsArchived = 1)
					BEGIN
						
						UPDATE [dbo].[AllowanceTime] 
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