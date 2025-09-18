-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-05-07 00:00:00.000'
-- Purpose      To Save or update the Employee Contract
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertEmploymentContract] 
--@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
--,@EmployeeId = 'B1286B23-1362-4C47-BC94-0549099E9393'
--,@StartDate = '2018-01-01'
--,@EndDate = '2018-01-01'
--,@ContractDetails = 'Part - Time'
--,@ContractTypeId = 'f128db06-44c2-468e-adda-17c177bece84'
--,@HourlyRate = 200
--,@HolidayOrThisYear = 'ThisYear'
--,@HolidayOrFullEntitlement = 'Full'
--,@IsArchived = 0
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertEmploymentContract]
(
   @EmploymentContractId UNIQUEIDENTIFIER = NULL,
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @StartDate DATETIME = NULL,
   @EndDate DATETIME = NULL,
   @ContractDetails NVARCHAR(800) = NULL,
   @ContractTypeId UNIQUEIDENTIFIER = NULL,
   @ContractedHours INT = NULL,
   @HourlyRate INT = NULL,
   @HolidayOrThisYear NVARCHAR(500) = NULL,
   @HolidayOrFullEntitlement NVARCHAR(500) = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @CurrencyId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

        IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
        IF(@StartDate = '') SET @StartDate = NULL
        IF(@EndDate = '') SET @EndDate = NULL
        IF(@ContractTypeId = '00000000-0000-0000-0000-000000000000') SET @ContractTypeId = NULL
        IF(@StartDate IS NULL)
        BEGIN
           
            RAISERROR(50011,16, 2, 'StartDate')
        END
        ELSE IF(@ContractTypeId IS NULL)
        BEGIN
           
            RAISERROR(50011,16, 2, 'ContractType')
        END
        ELSE IF(EXISTS(SELECT Id 
                       FROM [Contract] 
                       WHERE EmployeeId = @EmployeeId AND (Id <> @EmploymentContractId OR @EmploymentContractId IS NULL) AND InactiveDateTime IS NULL
                       AND ((CONVERT(DATE,StartDate) <= CONVERT(DATE,@StartDate) AND CONVERT(DATE,EndDate) >= CONVERT(DATE,@StartDate)) 
                       OR (CONVERT(DATE,StartDate) <= CONVERT(DATE,@EndDate) AND CONVERT(DATE,EndDate) >= CONVERT(DATE,@EndDate)))
                       ))
        BEGIN
               RAISERROR(50020,16, 1)
        END
        ELSE 
        BEGIN
        DECLARE @EmploymentContractIdsCount INT = (SELECT COUNT(1) FROM [dbo].[Contract] WHERE Id = @EmploymentContractId )
        DECLARE @UserId UNIQUEIDENTIFIER = (Select UserId from Employee where Id=@EmployeeId  AND InActiveDateTime IS NULL)
        DECLARE @FeatureId UNIQUEIDENTIFIER = 'A701FB6F-F1E3-42B0-9B4D-9B9F7C248F1E'
		DECLARE @HavePermissionToEdit INT = (SELECT COUNT(1) FROM [RoleFeature] WHERE RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy))
																								 AND FeatureId = @FeatureId AND InActiveDateTime IS NULL)
        
        IF(@UserId <> @OperationsPerformedBy AND @HavePermissionToEdit = 0)
        BEGIN
            RAISERROR('YouDoNotHaveAccessToEditAnotherEmployeeContractDetails',11,1)
        END
        ELSE IF(@EmploymentContractIdsCount = 0 AND @EmploymentContractId IS NOT NULL)
        BEGIN
            RAISERROR(50002,16, 1,'EmployeeContract')
        END
		ELSE IF EXISTS(SELECT *FROM Job WHERE EmployeeId = @EmployeeId and JoinedDate > convert(datetime, @StartDate))
		BEGIN
            RAISERROR('EmployeeContractShouldBeStartedAfterEmployeeJoiningDate',11,1)
		END
        ELSE 
        BEGIN
            DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
            IF (@HavePermission = '1')
            BEGIN
                DECLARE @IsLatest BIT = (CASE WHEN @EmploymentContractId IS NULL 
                                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                                                     FROM [dbo].[Contract] WHERE Id = @EmploymentContractId ) = @TimeStamp
                                                                THEN 1 ELSE 0 END END)
            
                IF(@IsLatest = 1)
                BEGIN
                    DECLARE @Currentdate DATETIME = GETDATE()
         
		          IF(@EmploymentContractId IS NULL)
				  BEGIN

				  SET @EmploymentContractId = NEWID()

					INSERT INTO [dbo].[Contract](
                                [Id],
                                [EmployeeId],
                                [StartDate],
                                [EndDate],
                                [ContractDetails],
                                [ContractTypeId],
                                [ContractedHours],
                                [HourlyRate],
								[CurrencyId],
                                [HolidayOrThisYear],
                                [HolidayOrFullEntitlement],
                                [CreatedDateTime],
                                [CreatedByUserId],
                                [InActiveDateTime])
                         SELECT @EmploymentContractId,
                                @EmployeeId,
                                @StartDate,
                                @EndDate,
                                @ContractDetails,
                                @ContractTypeId,
                                @ContractedHours,
                                @HourlyRate,
								@CurrencyId,
                                @HolidayOrThisYear,
                                @HolidayOrFullEntitlement,
                                @Currentdate,
                                @OperationsPerformedBy,
                                CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END

						END
						ELSE
						BEGIN

						UPDATE [dbo].[Contract]
                            SET [EmployeeId] = @EmployeeId,
                                [StartDate] = @StartDate,
                                [EndDate]  = @EndDate,
                                [ContractDetails] = @ContractDetails,
                                [ContractTypeId] = @ContractTypeId,
                                [ContractedHours] = @ContractedHours,
                                [HourlyRate] = @HourlyRate,
								[CurrencyId] = @CurrencyId,
                                [HolidayOrThisYear] = @HolidayOrThisYear,
                                [HolidayOrFullEntitlement] = @HolidayOrFullEntitlement,
                                [UpdatedDateTime] = @Currentdate,
                                [UpdatedByUserId] = @OperationsPerformedBy,
                                [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
								WHERE Id = @EmploymentContractId

						END

						UPDATE Reminder SET [InActiveDateTime] = CASE WHEN @IsArchived =  1 THEN @Currentdate ELSE NULL END
                         WHERE ReferenceId = @EmploymentContractId
					
                    SELECT Id FROM [dbo].[Contract] WHERE Id = @EmploymentContractId

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