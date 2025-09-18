CREATE PROCEDURE [dbo].[USP_UpsertRateTagAllowanceTime]
(
   @Id UNIQUEIDENTIFIER = NULL,
   @BranchId UNIQUEIDENTIFIER = NULL,
   @AllowanceRateTagForId UNIQUEIDENTIFIER = NULL,
   @MaxTime INT = NULL,
   @MinTime INT = NULL,
   @ActiveFrom DATETIME,
   @ActiveTo DATETIME = NULL,
   @IsBankHoliday BIT = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @AllowanceRateTagForIds XML = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @RateTagForName NVARCHAR(250) = NULL,
   @RateTagForType NVARCHAR(50) = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    
	BEGIN TRY
		IF(@BranchId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Branch')

		END
		ELSE IF(@MaxTime IS NULL AND @MinTime IS NULL)
		BEGIN
			
			RAISERROR(50011,16, 2, 'MaxTimeAndMinTime')

		END
		ELSE IF(@ActiveFrom IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'ActiveFrom')

		END

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy)

		IF(@AllowanceRateTagForId IS NOT NULL)
		BEGIN

		SET @RateTagForName = NULL
        SET @RateTagForType = NULL

		SET @RateTagForName = (SELECT RateTagForName FROM RateTagFor WHERE CompanyId = @CompanyId AND @AllowanceRateTagForId = Id)
		SET @RateTagForType = 'RateTag'

		IF(@RateTagForName IS NULL)
		BEGIN
		SET @RateTagForName = (SELECT PartsOfDayName FROM PartsOfDay WHERE @AllowanceRateTagForId = Id)
		SET @RateTagForType = 'PartsOfDay'
		END
		ELSE IF(@RateTagForName IS NULL)
		BEGIN
		SET @RateTagForName = (SELECT WeekDayName FROM WeekDays WHERE CompanyId = @CompanyId AND @AllowanceRateTagForId = Id)
		SET @RateTagForType = 'WeekDays'
		END
		ELSE IF(@RateTagForName IS NULL)
		BEGIN
		SET @RateTagForName = (SELECT Reason FROM Holiday WHERE CompanyId = @CompanyId AND @AllowanceRateTagForId = Id)
		SET @RateTagForType = 'Holiday'
		END
		ELSE IF(@RateTagForName IS NULL)
		BEGIN
		SET @RateTagForName = (SELECT Reason FROM SpecificDay WHERE CompanyId = @CompanyId AND @AllowanceRateTagForId = Id)
		SET @RateTagForType = 'SpecificDay'
		END
		END


		DECLARE @AllowanceCount INT = 0

		DECLARE @RateTagFor TABLE
        (
           RateTagForId UNIQUEIDENTIFIER,
		   RateTagForType NVARCHAR(50),
		   RateTagForName NVARCHAR(250),
		   RowNumber INT IDENTITY(1,1) 
        )

	    INSERT INTO @RateTagFor(RateTagForId,RateTagForType,RateTagForName)
        SELECT x.value('RateTagForId[1]','UNIQUEIDENTIFIER'), 
			   x.value('RateTagType[1]','NVARCHAR(50)'), 
			   x.value('RateTagForName[1]','NVARCHAR(250)')
        FROM @AllowanceRateTagForIds.nodes('/GenericListOfRateTagForTypeModel/ListItems/RateTagForTypeModel') XmlData(x)

		IF(@AllowanceRateTagForId IS NULL)
		BEGIN

		DECLARE @RateTagCount INT = (SELECT COUNT(1) FROM @RateTagFor) 
        DECLARE @TagId UNIQUEIDENTIFIER
         
        While(@RateTagCount > 0)
        BEGIN

                SET @TagId = (SELECT [RateTagForId] FROM @RateTagFor WHERE RowNumber = @RateTagCount)

				IF(@ActiveTo IS NULL)
		        BEGIN

				SET @AllowanceCount = (SELECT COUNT(1) FROM RateTagAllowanceTime WHERE BranchId = @BranchId AND AllowanceRateTagForId = @TagId AND (Id <> @Id OR @Id IS NULL) AND
																					((@ActiveFrom <= ActiveFrom AND (ActiveTo IS NULL OR @ActiveFrom <= ActiveTo ) AND @ActiveTo IS NULL)
																					OR (@ActiveFrom >= ActiveFrom AND (ActiveTo IS NULL OR @ActiveFrom <= ActiveTo ) AND @ActiveTo IS NULL)))
		        END
		        IF(@ActiveTo IS NOT NULL)
		        BEGIN

				SET @AllowanceCount = (SELECT COUNT(1) FROM RateTagAllowanceTime WHERE BranchId = @BranchId AND AllowanceRateTagForId = @TagId AND (Id <> @Id OR @Id IS NULL) AND
																					((@ActiveFrom <= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo <= ActiveTo AND @ActiveTo >= ActiveFrom )))
																					OR (@ActiveFrom <= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo >= ActiveTo AND @ActiveTo >= ActiveFrom )))
																					OR (@ActiveFrom >= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo <= ActiveTo AND @ActiveTo >= ActiveFrom )))
																					OR (@ActiveFrom >= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo >= ActiveTo AND @ActiveTo >= ActiveFrom AND @ActiveFrom <= ActiveTo)))))
		
		        END

				SET @RateTagCount = @RateTagCount - 1
                
                IF(@AllowanceCount > 0)
                BEGIN

                RAISERROR(50001,16, 2, 'RateTagAllowanceTime')

                END
        END

		END


		IF(@AllowanceRateTagForId IS NOT NULL)
		BEGIN
		IF(@ActiveTo IS NULL)
		BEGIN

			SET @AllowanceCount = (SELECT COUNT(1) FROM RateTagAllowanceTime WHERE BranchId = @BranchId AND AllowanceRateTagForId = @AllowanceRateTagForId AND (Id <> @Id OR @Id IS NULL) AND
																						((@ActiveFrom <= ActiveFrom AND (ActiveTo IS NULL OR @ActiveFrom <= ActiveTo ) AND @ActiveTo IS NULL)
																						OR (@ActiveFrom >= ActiveFrom AND (ActiveTo IS NULL OR @ActiveFrom <= ActiveTo ) AND @ActiveTo IS NULL)))
        END
		IF(@ActiveTo IS NOT NULL)
		BEGIN

		SET @AllowanceCount = (SELECT COUNT(1) FROM RateTagAllowanceTime WHERE BranchId = @BranchId AND AllowanceRateTagForId = @AllowanceRateTagForId AND (Id <> @Id OR @Id IS NULL) AND
																						((@ActiveFrom <= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo <= ActiveTo AND @ActiveTo >= ActiveFrom )))
																						OR (@ActiveFrom <= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo >= ActiveTo AND @ActiveTo >= ActiveFrom )))
																						OR (@ActiveFrom >= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo <= ActiveTo AND @ActiveTo >= ActiveFrom )))
																						OR (@ActiveFrom >= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo >= ActiveTo AND @ActiveTo >= ActiveFrom AND @ActiveFrom <= ActiveTo)))))

		END

		END

		IF(@AllowanceCount > 0)
		BEGIN
			
			RAISERROR(50001,16, 2, 'RateTagAllowanceTime')

		END

		
		DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
		BEGIN
			
			DECLARE @IsLatest BIT = (CASE WHEN @Id  IS NULL
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                           FROM [RateTagAllowanceTime] WHERE Id = @Id) = @TimeStamp
			         									THEN 1 ELSE 0 END END)

			IF(@IsLatest = 1)
			BEGIN
				
				IF(@Id IS NULL)
				BEGIN
					
					INSERT INTO [dbo].[RateTagAllowanceTime](
													[Id],
													[AllowanceRateTagForId],
													[BranchId],
													[MaxTime],
													[MinTime],
													[ActiveFrom],
													[ActiveTo],
													[RateTagForType],
	                                                [RateTagForName],
													[CreatedByUserId],
													[CreatedDateTime],
													[IsBankHoliday]
													)
											SELECT NEWID(),
												   RateTagForId,
												   @BranchId,
												   @MaxTime,
												   @MinTime,
												   @ActiveFrom,
												   @ActiveTo,
												   RateTagForType,
	                                               RateTagForName,
												   @OperationsPerformedBy,
												   GETDATE(),
												   @IsBankHoliday
												   FROM @RateTagFor

					SELECT 'Inserted Successfully'

				END
				ELSE
				BEGIN
					
					UPDATE [dbo].[RateTagAllowanceTime]
								SET [AllowanceRateTagForId] = @AllowanceRateTagForId,
									[BranchId] = @BranchId,
									[MaxTime] = @MaxTime,
									[MinTime] = @MinTime,
									[ActiveFrom] = @ActiveFrom,
									[ActiveTo] = @ActiveTo,
									[RateTagForType] = @RateTagForType,
	                                [RateTagForName] = @RateTagForName,
									[UpdatedByUserId] = @OperationsPerformedBy,
									[UpdatedDateTime] = GETDATE(),
									[InActiveDateTime] = NULL,
									[IsBankHoliday] = @IsBankHoliday
								WHERE Id = @Id
				
					IF(@IsArchived = 1)
					BEGIN
						
						UPDATE [dbo].[RateTagAllowanceTime] 
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