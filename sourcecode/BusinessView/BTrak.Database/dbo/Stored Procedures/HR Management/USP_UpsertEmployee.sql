---------------------------------------------------------------------------------
-- Author       Aswani Katam
-- Created      '2019-01-22 00:00:00.000'
-- Purpose      To Save or Update the Employee
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
-- EXEC [USP_UpsertEmployee]@Surname='Test', @RegisteredDateTime = '2019-05-08', @IsActiveOnMobile = 1, 
-- @MobileNo = '12345',@IsActive = 1, @RoleId = '4D5ADF0F-88DF-462C-A987-38AC05AEAB0C',@OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@FirstName = 'Test User',@Email = 'Test1User@gmail.com',
-- @Password = 'Test123!'
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertEmployee]
(
     @EmployeeId UNIQUEIDENTIFIER = NULL,
     @UserId UNIQUEIDENTIFIER = NULL,
     @EmployeeNumber NVARCHAR(50) = NULL,
     @GenderId UNIQUEIDENTIFIER = NULL,
     @MaritalStatusId UNIQUEIDENTIFIER = NULL,
     @NationalityId UNIQUEIDENTIFIER = NULL,
     @DateofBirth DATETIME = NULL,
     @Smoker BIT = NULL,
     @MilitaryService  BIT = NULL,
     @NickName NVARCHAR(100) = NUL,
	 @TimeStamp TIMESTAMP = NULL,
	 @IsArchived BIT = NULL,
     @OperationsPerformedBy UNIQUEIDENTIFIER,
	 @BranchId UNIQUEIDENTIFIER = NULL,
	 @ShiftTimingId UNIQUEIDENTIFIER = NULL,
     @MarriageDate DATETIME = NULL
 )
 AS
 BEGIN
     SET NOCOUNT ON
     BEGIN TRY
     SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		IF(@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL

		IF(@UserId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'User')

		END

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        DECLARE @EmployeeIdCount INT = (SELECT COUNT(1) FROM [dbo].Employee WHERE Id = @EmployeeId )

        IF(@EmployeeIdCount = 0 AND @EmployeeId IS NOT NULL)
        BEGIN

            RAISERROR(50002,16, 1,'Employee')

        END
        ELSE 
        BEGIN
            
            IF (@HavePermission = '1')
            BEGIN
                DECLARE @IsLatest BIT = (CASE WHEN @EmployeeId IS NULL 
                                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                                                     FROM Employee WHERE Id = @EmployeeId ) = @TimeStamp
                                                                THEN 1 ELSE 0 END END)
            
                IF(@IsLatest = 1)
                BEGIN
                    DECLARE @Currentdate DATETIME = GETDATE()
                    
                    IF(@EmployeeId IS NULL)
					BEGIN

					SET @EmployeeId = NEWID()

                    INSERT INTO [dbo].[Employee](
                          [Id],
                          [UserId],
                          [EmployeeNumber],
                          [GenderId],
                          [MaritalStatusId],
                          [MarriageDate],
                          [NationalityId],
                          [DateofBirth],
                          [Smoker],
                          [MilitaryService],
                          [NickName],
                          [CreatedDateTime],
                          [CreatedByUserId],
                          [InActiveDateTime]
						  )
                   SELECT @EmployeeId,
                          @UserId,
                          @EmployeeNumber,
                          @GenderId,
                          @MaritalStatusId,
                          @MarriageDate,
                          @NationalityId,
                          @DateofBirth,
                          @Smoker,
                          @MilitaryService,
                          @NickName,
                          @Currentdate,
                          @OperationsPerformedBy,
                          CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END

					END
					ELSE
					BEGIN

					UPDATE [dbo].[Employee]
                     SET   [UserId] = @UserId,
                           [EmployeeNumber] = @EmployeeNumber,
                           [GenderId] = @GenderId,
                           [MaritalStatusId] = @MaritalStatusId,
                           [MarriageDate] = @MarriageDate,
                           [NationalityId] = @NationalityId,
                           [DateofBirth] = @DateofBirth,
                           [Smoker] = @Smoker,
                           [MilitaryService] = @MilitaryService,
                           [NickName] = @NickName,
                           [UpdatedDateTime] = @Currentdate,
                           [UpdatedByUserId] = @OperationsPerformedBy,
                           [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
                        WHERE Id = @EmployeeId

					END

						  DECLARE @EmployeeBranchId UNIQUEIDENTIFIER 

						  DECLARE @OldEmployeeBranchId UNIQUEIDENTIFIER 

						  SELECT @EmployeeBranchId = Id, @OldEmployeeBranchId = BranchId FROM EmployeeBranch WHERE EmployeeId = @EmployeeId 
						  
                          IF((@BranchId IS NOT NULL AND @OldEmployeeBranchId <> @BranchId) OR @EmployeeBranchId IS NULL)
						  BEGIN
						
						  DECLARE @EmployeeBranchTimeStamp TIMESTAMP  = (SELECT [TimeStamp] FROM EmployeeBranch WHERE EmployeeId = @EmployeeId)

						  EXEC USP_UpsertEmployeeBranch @EmployeeBranchId = @EmployeeBranchId, @EmployeeId = @EmployeeId,
						  @OperationsPerformedBy= @OperationsPerformedBy,@BranchId = @BranchId,@IsArchived = @IsArchived,
						  @ActiveFrom = @Currentdate ,@TimeStamp = @EmployeeBranchTimeStamp
						  
						  END
						  
						  DECLARE @EmployeeShiftTimingId UNIQUEIDENTIFIER 

						  DECLARE @OldEmployeeShiftTimingId UNIQUEIDENTIFIER 

						  SELECT @EmployeeShiftTimingId = Id, @OldEmployeeShiftTimingId = ShiftTimingId FROM EmployeeShift WHERE EmployeeId = @EmployeeId 

						  IF((@ShiftTimingId IS NOT NULL AND @OldEmployeeShiftTimingId <> @ShiftTimingId) OR @EmployeeShiftTimingId IS NULL)
						  BEGIN

						  DECLARE @EmployeeShiftTimingTimeStamp TIMESTAMP = (SELECT [TimeStamp] FROM EmployeeShift WHERE EmployeeId = @EmployeeId )

						  EXEC USP_UpsertEmployeeShift @EmployeeShiftId = @EmployeeShiftTimingId, @EmployeeId = @EmployeeId,
						  @OperationsPerformedBy = @OperationsPerformedBy,@ShiftTimingId = @ShiftTimingId, @IsArchived = @IsArchived,
						  @ActiveFrom = @Currentdate,@TimeStamp = @EmployeeShiftTimingTimeStamp
						  
						  END        

                 SELECT Id FROM [dbo].Employee WHERE Id = @EmployeeId

                END 
                    ELSE
                        RAISERROR (50008,11, 1)
            END
            ELSE
            BEGIN
                    RAISERROR (@HavePermission,11, 1)
                    
            END
        END
     END TRY  
     BEGIN CATCH 
         
         THROW
    END CATCH
    
END
