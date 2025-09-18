CREATE PROCEDURE [dbo].[USP_InsertEmployeeRateTagDetails]
(
 @RateTagStartDate DATETIME = NULL,
 @RateTagEndDate DATETIME = NULL,
 @RateTagEmployeeId UNIQUEIDENTIFIER,
 @RateTagCurrencyId UNIQUEIDENTIFIER,
 @EmployeeRateTagDetails NVARCHAR(MAX),
 @TimeStamp TIMESTAMP = NULL,
 @IsArchived BIT = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @IsClearCustomize BIT = NULL,
 @GroupPriority INT = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT (OBJECT_NAME(@@PROCID)))))

		IF (@HavePermission = '1')
		BEGIN
			
			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
			
			IF (@RateTagEmployeeId IS NULL)
			BEGIN
				
				RAISERROR(50011,16,1,'Employee')

			END
			ELSE IF (@RateTagStartDate IS NULL)
			BEGIN
				
				RAISERROR(50011,16,1,'StartDate')

			END
			ELSE IF (@RateTagStartDate IS NULL)
			BEGIN
				
				RAISERROR(50011,16,1,'EndDate')

			END
			ELSE IF (@EmployeeRateTagDetails IS NULL AND @IsClearCustomize != 1)
			BEGIN
				
				RAISERROR(50011,16,1,'EmployeeRateTagDetails')

			END
			ELSE
			BEGIN
				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				IF(@IsClearCustomize = 1)
				BEGIN
				  
				  UPDATE EmployeeRateTag 
				  SET InActiveDateTime = GetDate() 
				  WHERE CONVERT(DATE, RateTagStartDate) = CONVERT(DATE, @RateTagStartDate) 
				  AND CONVERT(DATE, RateTagEndDate) = CONVERT(DATE, @RateTagEndDate) 
				  AND (RateTagEmployeeId = @RateTagEmployeeId)
				  AND InActiveDateTime IS NULL
				  AND IsOverrided = 1
				  AND CompanyId = @CompanyId

				  UPDATE EmployeeRateTag 
				  SET GroupPriority = NULL
				  WHERE CONVERT(DATE, RateTagStartDate) = CONVERT(DATE, @RateTagStartDate) 
				  AND CONVERT(DATE, RateTagEndDate) = CONVERT(DATE, @RateTagEndDate) 
				  AND (RateTagEmployeeId = @RateTagEmployeeId)
				  AND InActiveDateTime IS NULL
				  AND IsOverrided <> 1
				  AND CompanyId = @CompanyId

				END
				ELSE
				BEGIN
				
				CREATE TABLE #EmployeeRateTagDetails 
				(
					EmployeeRateTagId UNIQUEIDENTIFIER,
					RateTagId UNIQUEIDENTIFIER,
					RateTagName NVARCHAR(250),
					RateTagCurrencyId UNIQUEIDENTIFIER,
					RateTagForId UNIQUEIDENTIFIER,
					RateTagForName NVARCHAR(250),
					RateTagStartDate NVARCHAR(250),
					RateTagEndDate NVARCHAR(250),
					RatePerHour DECIMAL(10,2),
					RatePerHourMon DECIMAL(10,2),
					RatePerHourTue DECIMAL(10,2),
					RatePerHourWed DECIMAL(10,2),
					RatePerHourThu DECIMAL(10,2),
					RatePerHourFri DECIMAL(10,2),
					RatePerHourSat DECIMAL(10,2),
					RatePerHourSun DECIMAL(10,2),
					RateTagEmployeeId UNIQUEIDENTIFIER,
					IsArchived BIT,
					[Priority] INT,
					IsOverRided BIT,
					GroupPriority INT,
					RoleId UNIQUEIDENTIFIER,
					BranchId UNIQUEIDENTIFIER,
				    RowNumber INT IDENTITY(1,1)
				)

				INSERT INTO #EmployeeRateTagDetails
				SELECT *
				FROM OPENJSON(@EmployeeRateTagDetails)
				WITH (EmployeeRateTagId UNIQUEIDENTIFIER,
					RateTagId UNIQUEIDENTIFIER,
					RateTagName NVARCHAR(250),
					RateTagCurrencyId UNIQUEIDENTIFIER,
					RateTagForId UNIQUEIDENTIFIER,
					RateTagForName NVARCHAR(250),
					RateTagStartDate NVARCHAR(250),
					RateTagEndDate NVARCHAR(250),
					RatePerHour DECIMAL(10,2),
					RatePerHourMon DECIMAL(10,2),
					RatePerHourTue DECIMAL(10,2),
					RatePerHourWed DECIMAL(10,2),
					RatePerHourThu DECIMAL(10,2),
					RatePerHourFri DECIMAL(10,2),
					RatePerHourSat DECIMAL(10,2),
					RatePerHourSun DECIMAL(10,2),
					RateTagEmployeeId UNIQUEIDENTIFIER,
					IsArchived BIT,
					[Priority] INT,
					IsOverRided BIT,
					GroupPriority INT,	
					RoleId UNIQUEIDENTIFIER,
					BranchId UNIQUEIDENTIFIER)

				DECLARE @RateTagtIdCount INT = (SELECT COUNT(1) FROM EmployeeRateTag E
				                                   JOIN #EmployeeRateTagDetails R ON E.RateTagEmployeeId = @RateTagEmployeeId AND E.RateTagId = R.RateTagId 
													AND ( CONVERT(DATE, E.RateTagStartDate) BETWEEN CONVERT(DATE, @RateTagStartDate) AND CONVERT(DATE, @RateTagEndDate)
														OR CONVERT(DATE, E.RateTagEndDate) BETWEEN CONVERT(DATE, @RateTagStartDate) AND CONVERT(DATE, @RateTagEndDate)
														OR CONVERT(DATE, @RateTagStartDate) BETWEEN CONVERT(DATE, E.RateTagStartDate) AND CONVERT(DATE, E.RateTagEndDate)
														OR CONVERT(DATE, @RateTagEndDate) BETWEEN CONVERT(DATE, E.RateTagStartDate) AND CONVERT(DATE, E.RateTagEndDate)
													)
													AND R.EmployeeRateTagId IS NULL
													AND E.InActiveDateTime IS NULL
													AND ((@GroupPriority IS NULL AND E.GroupPriority IS NULL) OR E.GroupPriority = @GroupPriority)
													AND E.CompanyId = @CompanyId)
				IF (@RateTagtIdCount > 0)
				BEGIN
				    
					RAISERROR(50027,16,1,'RateTagDateStartOrEndDateMatchesWithOtherStartDateOrEndDate')

				END
				ELSE
				BEGIN

				IF((SELECT COUNT(1) FROM EmployeeRateTag WHERE RateTagEmployeeId = @RateTagEmployeeId AND InActiveDateTime IS NULL
				AND CONVERT(DATE, RateTagStartDate) = @RateTagStartDate AND CONVERT(DATE, RateTagEndDate) = @RateTagEndDate) > 0)
				DELETE ERT FROM EmployeeRateTag ERT
				WHERE ERT.RateTagEmployeeId = @RateTagEmployeeId AND InActiveDateTime IS NULL
				AND ((@GroupPriority IS NULL AND ERT.GroupPriority IS NULL) OR ERT.GroupPriority = @GroupPriority)
				AND CONVERT(DATE, ERT.RateTagStartDate) = @RateTagStartDate AND CONVERT(DATE, ERT.RateTagEndDate) = @RateTagEndDate

					DECLARE @CurrentDate DATETIME = GETDATE();

					INSERT INTO EmployeeRateTag(Id, 
												RateTagEmployeeId,
												RateTagId,
												RateTagCurrencyId,
												RateTagForId,
												RateTagStartDate,
												RateTagEndDate,
												RatePerHour,
												RatePerHourMon,
												RatePerHourTue,
												RatePerHourWed,
												RatePerHourThu,
												RatePerHourFri,
												RatePerHourSat,
												RatePerHourSun,
												CompanyId,
												CreatedDateTime,
												CreatedByUserId,
												InActiveDateTime,
												[Priority],
												IsOverrided,
												GroupPriority,
												RoleId,
							                    BranchId)
					 SELECT NEWID(),
							@RateTagEmployeeId,
							R.RateTagId,
							@RateTagCurrencyId,
							R.RateTagForId,
							@RateTagStartDate,
							@RateTagEndDate,
							R.RatePerHour,
							R.RatePerHourMon,
							R.RatePerHourTue,
							R.RatePerHourWed,
							R.RatePerHourThu,
							R.RatePerHourFri,
							R.RatePerHourSat,
							R.RatePerHourSun,
							@CompanyId,
							@CurrentDate,
							@OperationsPerformedBy,
							CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
							[Priority],
							R.IsOverRided,
							GroupPriority,
							RoleId,
							BranchId
					FROM #EmployeeRateTagDetails R

					SELECT TOP 1 Id FROM EmployeeRateTag WHERE CreatedDateTime = @CurrentDate
				END

			    END
			END
		END
		ELSE
		RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END
