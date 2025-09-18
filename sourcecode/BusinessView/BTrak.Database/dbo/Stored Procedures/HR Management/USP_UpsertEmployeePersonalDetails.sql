-------------------------------------------------------------------------------
-- Author        Padmini Badam
-- Created      '2019-05-07 00:00:00.000'
-- Purpose      To Save or update the Employee Personal Details
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
-- EXEC [USP_UpsertEmployeePersonalDetails]@Surname='T',
-- @EmployeeNumber = '235467' ,
-- @RegisteredDateTime = '2019-05-08', 
-- @IsActiveOnMobile = 1, @MobileNo = '123456',@IsActive = 1,
-- @RoleId = '4D5ADF0F-88DF-462C-A987-38AC05AEAB0C',
-- @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',
-- @FirstName = 'User',@EmploymentStatusId = 'AE5DFBF0-6582-4DAB-9981-B317974C0563',
-- @Email = 'teame.com',@Password = 'gLecZwWSUvmzSo/oExEc+O1DCxC5YLZvANKvv6GUALYTjpwi',@DateOfJoining = '2019-05-09',
-- @JobCategoryId = '200F9900-BE1D-4738-854C-585F80A91C3C',
-- @DesignationId = '66554F41-1131-493F-8E59-CDD080026D11',@EmployeeId = 'B1286B23-1362-4C47-BC94-0549099E9393',@TimeStamp = 0x0000000000011028,
-- @MarriageDate = '2020-01-10'
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertEmployeePersonalDetails]
(
   @UserId UNIQUEIDENTIFIER = NULL,
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @FirstName NVARCHAR(800) = NULL,
   @Surname NVARCHAR(800) = NULL,
   @Email NVARCHAR(800) = NULL,
   @DateOfJoining DATETIME = NULL,
   @JobCategoryId UNIQUEIDENTIFIER = NULL,
   @DesignationId UNIQUEIDENTIFIER = NULL,
   @DateOfLeaving DATETIME = NULL,
   @NationalityId UNIQUEIDENTIFIER = NULL,
   @UserAuthenticationId UNIQUEIDENTIFIER = NULL,
   @Taxcode NVARCHAR(800) = NULL,
   @DateOfBirth DATETIME = NULL,
   @EmploymentStatusId UNIQUEIDENTIFIER = NULL,
   @GenderId UNIQUEIDENTIFIER = NULL,
   @MaritalStatusId UNIQUEIDENTIFIER = NULL,
   @RoleIds NVARCHAR(MAX) = NULL, 
   @IsActive BIT = 1,
   @RegisteredDateTime DateTime = NULL,
   @IsActiveOnMobile BIT = 1,
   @MobileNo NVARCHAR(250) = NULL,
   @EmployeeNumber NVARCHAR(250),
   @Password NVARCHAR(800) = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @IsUpsertEmployee BIT = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @BranchId UNIQUEIDENTIFIER = NULL,
   @ShiftTimingId UNIQUEIDENTIFIER = NULL,
   @CurrencyId UNIQUEIDENTIFIER = NULL,
   @TimeZoneId UNIQUEIDENTIFIER = NULL,
   @ActiveFrom DATETIME,
   @PermittedBranches XML = NULL,
   @BusinessUnitXML XML = NULL,
   @MarriageDate DATETIME = NULL,
   @ActiveTo DATETIME = NULL,
   @MacAddress VARCHAR(75) = '',
   @EmployeeShiftId UNIQUEIDENTIFIER = NULL,
   @Salary FLOAT = NULL,
   @PayrollTemplateId UNIQUEIDENTIFIER = NULL,
   @IPNumber VARCHAR(75) = NULL,
   @IPName VARCHAR(75) = NULL,
   @DepartmentId UNIQUEIDENTIFIER = NULL,
   @FormJson NVARCHAR(MAX) = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
        IF(@RoleIds = '') SET @RoleIds = NULL

        IF(@EmployeeId = '00000000-0000-0000-0000-000000000000') SET @EmployeeId = NULL

		IF(@BranchId = '00000000-0000-0000-0000-000000000000') SET @BranchId = NULL

		IF(@ShiftTimingId = '00000000-0000-0000-0000-000000000000') SET @ShiftTimingId = NULL

		IF(@CurrencyId = '00000000-0000-0000-0000-000000000000') SET @CurrencyId = NULL

		IF(@TimeZoneId = '00000000-0000-0000-0000-000000000000') SET @TimeZoneId = NULL

        IF (@UserId IS NULL) SET @UserId = (SELECT UserId FROM Employee WHERE Id = @EmployeeId AND InActiveDateTime IS NULL)

        IF (@EmployeeId IS NULL) SET @EmployeeId = (SELECT Id FROM Employee WHERE UserId = @UserId AND InActiveDateTime IS NULL)

        IF(@FirstName = '') SET @FirstName = NULL

        IF(@MobileNo = '') SET @MobileNo = NULL

		IF(@EmployeeNumber = '') SET @EmployeeNumber = NULL
		
        IF(@Email = '') SET @Email = NULL

        IF(@Password = '') SET @Password = NULL

		IF(@IPNumber = '') SET @IPNumber = NULL

        IF(@IsActive IS NULL) SET  @IsActive = 1

        IF(@IsActiveOnMobile IS NULL) SET  @IsActiveOnMobile = 1
		
        DECLARE @OldEmployeeBranchId UNIQUEIDENTIFIER,@MainBranchId UNIQUEIDENTIFIER,@EmployeeBranchId UNIQUEIDENTIFIER ,@OldActiveFromDate DATETIME

        SELECT @EmployeeBranchId = Id, @OldEmployeeBranchId = BranchId,@OldActiveFromDate = ActiveFrom FROM EmployeeBranch WHERE ActiveFrom IS NOT NULL AND (ActiveTo IS NULL OR ActiveTo >= GETDATE()) AND EmployeeId = @EmployeeId 
        
        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		IF(@ShiftTimingId IS NULL AND @EmployeeId IS NULL AND @UserId IS NULL)
		BEGIN

		SET @ShiftTimingId = (SELECT TOP 1 Id FROM ShiftTiming WHERE InActiveDateTime IS NULL AND CompanyId = @CompanyId)

		END

        DECLARE @PayGradeId UNIQUEIDENTIFIER = NULL

        DECLARE @PayFrequencyId UNIQUEIDENTIFIER = NULL

		--DECLARE @IsRemoteAccess BIT = (SELECT  IsRemoteAccess FROM Company C WHERE C.Id = @CompanyId)

		DECLARE @NoOfEmployees INT = (Select COUNT(Id) FROM [User] WHERE CompanyId = @CompanyId and InActiveDateTime IS NULL AND IsActive = 1)

		--DECLARE @PurchasedLicence BIT = CASE When (Select NoOfPurchasedLicences from Company) > @NoOfLicensPurchased
		                        
        SELECT @MainBranchId = Id FROM Branch WHERE CompanyId = @CompanyId AND BranchName = (SELECT CompanyName FROM Company WHERE Id = @CompanyId)
		
        DECLARE @EmployeeIpNumberCount INT = (SELECT COUNT(1) FROM Employee WHERE [IPNumber] = @IPNumber
																		AND (@EmployeeId IS NULL OR @EmployeeId <> Id))

		DECLARE @PurchasedCount INT = NULL
		SET @PurchasedCount =ISNULL((SELECT TOP 1 CP.Noofpurchasedlicences FROM CompanyPayment CP WHERE CP.CompanyId = @CompanyID ORDER BY CreatedDateTime DESC) ,ISNULL((SELECT C.NoOfPurchasedLicences FROM Company C WHERE C.Id=@CompanyId), 0))
		
		DECLARE @IsTrailValid NVARCHAR(10)
		SET @IsTrailValid = CASE WHEN (SELECT ISNULL(C.TrailDays, 90) -( DATEDIFF(day,C.CreatedDateTime,GETDATE()) ) from Company C where C.Id=@CompanyId) >0 THEN 'YES' ELSE 'NO' END
        
		IF(@FirstName IS NULL)
        BEGIN
           
            RAISERROR(50011,16, 2, 'FirstName')
        END
        ELSE IF(@Email IS NULL)
        BEGIN
           
            RAISERROR(50011,16, 2, 'Email')
        END
        --ELSE IF(@MobileNo IS NULL)
        --BEGIN
           
        --    RAISERROR(50011,16, 2, 'MobileNumber')
        --END
        ELSE IF(@Password IS NULL AND @UserId IS NULL)
        BEGIN
           
            RAISERROR(50011,16, 2, 'Password')
        END
  --      ELSE IF (@DateOfJoining IS NULL AND @UserId IS NULL)
  --      BEGIN
  --          RAISERROR(50011,16,2,'JoiningDate')
  --      END
  --      ELSE IF (@JobCategoryId IS NULL AND @UserId IS NULL)
  --      BEGIN
  --          RAISERROR(50011,16,2,'JoiningCategory')
  --      END
  --      ELSE IF (@DesignationId IS NULL AND @UserId IS NULL)
  --      BEGIN
  --          RAISERROR(50011,16,2,'Designation')
  --      END
  --      ELSE IF (@EmploymentStatusId IS NULL AND @UserId IS NULL)
  --      BEGIN
  --          RAISERROR(50011,16,2,'EmploymentStatus')
  --      END
		----ELSE IF ((@BranchId IS NULL OR (@BranchId IS NOT NULL AND @MainBranchId = @BranchId)) AND @IsUpsertEmployee = 1)
		--ELSE IF (@BranchId IS NULL AND @IsUpsertEmployee = 1)
  --      BEGIN
  --          RAISERROR(50011,16,2,'Branch')
  --      END
		--ELSE IF (@CurrencyId IS NULL AND @IsUpsertEmployee = 1)
  --      BEGIN
  --          RAISERROR(50011,16,2,'Currency')
  --      END
		--ELSE IF(@EmployeeNumber IS NULL)
  --      BEGIN
           
  --          RAISERROR(50011,16, 2, 'EmployeeNumber')
  --      END
  --      ELSE IF (@EmployeeIpNumberCount > 0 AND @IPNumber IS NOT NULL)
  --      BEGIN
            
  --          RAISERROR('EmployeeWithThisIPNumberAlreadyExists',11,1)

  --      END
		--ELSE IF (@TimeZoneId IS NULL AND @IsUpsertEmployee = 1)
  --      BEGIN
  --          RAISERROR(50011,16,2,'TimeZone')
  --      END
        ELSE 

        BEGIN

        IF (@DateOfJoining IS NULL) SET @DateOfJoining = (SELECT RegisteredDateTime FROM [User] WHERE Id = @UserId)

        DECLARE @JobId UNIQUEIDENTIFIER = (SELECT Id FROM Job WHERE EmployeeId = @EmployeeId AND InactiveDateTime IS NULL)

        DECLARE @OldDesignationId UNIQUEIDENTIFIER,@OldEmploymentStatusId UNIQUEIDENTIFIER,@OldJobCategoryId UNIQUEIDENTIFIER,@OldJoinedDate DATETIME,@OldDepartmentId UNIQUEIDENTIFIER

        SELECT @OldDesignationId = DesignationId,@OldEmploymentStatusId = EmploymentStatusId,@OldJobCategoryId = JobCategoryId,@OldJoinedDate = JoinedDate,@OldDepartmentId = DepartmentId FROM Job WHERE EmployeeId = @EmployeeId AND InActiveDateTime IS NULL

		DECLARE @ToUpdateJob BIT = 0

		IF(@IsUpsertEmployee = 1)
		BEGIN

		     SET @ToUpdateJob = (CASE WHEN @IsArchived = 1  THEN 1 
                                      WHEN (@OldDesignationId <> @DesignationId OR @OldDesignationId IS NULL) THEN 1
                                      WHEN (@OldEmployeeBranchId <> @BranchId OR @OldEmployeeBranchId IS NULL) THEN 1
									  WHEN (@OldDepartmentId <> @DepartmentId OR @OldDepartmentId IS NULL) THEN 1
                                      WHEN (@OldEmploymentStatusId <> @EmploymentStatusId OR @OldEmploymentStatusId IS NULL) THEN 1
                                      WHEN (@JobCategoryId <> @OldJobCategoryId OR @OldJobCategoryId IS NULL) THEN 1
                                      WHEN (@OldJoinedDate <> @DateOfJoining OR @OldJoinedDate IS NULL) THEN 1
                                      ELSE 0 END)
		END

        DECLARE @UserIdIdCount INT = (SELECT COUNT(1) FROM [User] WHERE Id = @UserId )

        DECLARE @EmployeeIdCount INT = (SELECT COUNT(1) FROM Employee WHERE Id = @EmployeeId)

        DECLARE @UserNameCount INT = (SELECT COUNT(1) FROM [User] WHERE UserName = @Email AND CompanyId = @CompanyId AND (@UserId IS NULL OR Id <> @UserId) )

        DECLARE @EmployeeNumberCount INT = (SELECT COUNT(1) FROM Employee E JOIN [User] U ON U.Id = E.UserId AND U.IsActive = 1 AND U.CompanyId = @CompanyId WHERE E.EmployeeNumber = @EmployeeNumber AND (@EmployeeId IS NULL OR E.Id <> @EmployeeId) AND E.InActiveDateTime IS NULL)

        DECLARE @EmpUserId UNIQUEIDENTIFIER = (Select UserId from Employee where Id = @EmployeeId AND InActiveDateTime IS NULL)
		
        DECLARE @MacAddressExist INT = 0

		DECLARE @PreviousMac NVARCHAR(20) = NULL 

		SET @PreviousMac = (SELECT MACAddress from Employee WHERE  Id = @EmployeeId AND UserId = (Select ID from [User] where Id =@UserId ))

		DECLARE  @PreviousMacCount INT  = (SELECT count(Macaddress) FROM Employee WHERE  Id = @EmployeeId AND UserId = (Select ID from [User] where Id =@UserId ))


		IF (@MacAddress <> '')
			BEGIN

				SET @MacAddressExist = (SELECT COUNT(*) FROM Employee WHERE MacAddress = @MacAddress AND InActiveDateTime IS NULL AND (@UserId IS NULL OR @UserId <> UserId))
			END 

        DECLARE @FeatureId UNIQUEIDENTIFIER = 'A701FB6F-F1E3-42B0-9B4D-9B9F7C248F1E'

        --DECLARE @EmpRoleId UNIQUEIDENTIFIER = (SELECT R.Id FROM [Role] R INNER JOIN [User] U ON U.RoleId = R.Id WHERE U.Id = @OperationsPerformedBy  AND R.InactiveDateTime IS  NULL AND U.InactiveDateTime IS  NULL) 

        DECLARE @HavePermissionToEdit INT = (SELECT COUNT(1) FROM [RoleFeature] WHERE RoleId IN (SELECT R.Id FROM [Role] R INNER JOIN [UserRole] UR ON UR.RoleId = R.Id 
		                                                                                         WHERE UR.UserId = @OperationsPerformedBy 
																								        AND R.InactiveDateTime IS  NULL 
																										AND UR.InactiveDateTime IS  NULL)  
																				      AND FeatureId = @FeatureId AND InActiveDateTime IS NULL)

        IF(@EmpUserId <> @OperationsPerformedBy AND @HavePermissionToEdit = 0)
        BEGIN
            
			RAISERROR('YouDoNotHaveAccessToEditAnotherEmployeePersonalDetails',11,1)

        END
        ELSE IF(@UserIdIdCount = 0 AND @UserId IS NOT NULL)
        BEGIN

            RAISERROR(50002,16, 1,'User')

        END
        ELSE IF(@EmployeeIdCount = 0 AND @EmployeeId IS NOT NULL)
        BEGIN

            RAISERROR(50002,16, 1,'Employee')

        END
		ELSE IF(@EmployeeNumberCount > 0)
        BEGIN
            
			RAISERROR('EmployeeWithThisNumberAlreadyExists',16, 1)

        END
        ELSE IF(@UserNameCount > 0)
        BEGIN
            
            RAISERROR(50010,16,1,'Employee')

        END
		
		ELSE IF (@PreviousMac != @MacAddress AND @UserId IS NOT NULL AND @PreviousMac IS NOT NULL and @MacAddressExist > 0)
		BEGIN 
		 
		      RAISERROR(50001,16, 2, 'EmpMACAddress')

		END
		ELSE IF (@UserId IS  NULL AND  @MacAddressExist > 0 AND @MacAddress IS NOT NULL )
		BEGIN 
		 
		      RAISERROR(50001,16, 2, 'EmpMACAddress')

		END
        ELSE
        BEGIN

            DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
            IF (@HavePermission = '1')
            BEGIN
                
                DECLARE @IsLatest BIT = CASE WHEN @UserId IS NULL THEN 1
                                             WHEN @EmployeeId IS NULL THEN 1
                                             WHEN (SELECT [TimeStamp] FROM [User] WHERE InActiveDateTime IS NULL AND Id = @UserId) = @TimeStamp THEN 1
                                             WHEN (SELECT [TimeStamp] FROM Employee WHERE InActiveDateTime IS NULL AND Id = @EmployeeId) = @TimeStamp THEN 1
                                             ELSE 0 END
                
                IF(@IsLatest = 1)
                BEGIN
                   

                    DECLARE @OldFirstName NVARCHAR(800) = NULL
                    DECLARE @OldSurname NVARCHAR(800) = NULL
                    DECLARE @OldEmail NVARCHAR(800) = NULL
                    DECLARE @OldDateOfJoining DATETIME = NULL
                    DECLARE @OldDateOfLeaving DATETIME = NULL
                    DECLARE @OldNationalityId UNIQUEIDENTIFIER = NULL
                    DECLARE @OldTaxcode NVARCHAR(800) = NULL
                    DECLARE @OldDateOfBirth DATETIME = NULL
                    DECLARE @OldGenderId UNIQUEIDENTIFIER = NULL
                    DECLARE @OldMaritalStatusId UNIQUEIDENTIFIER = NULL
                    DECLARE @OldRoleIds NVARCHAR(MAX) = NULL
                    DECLARE @OldIsActive BIT = 1
                    DECLARE @OldRegisteredDateTime DateTime = NULL
                    DECLARE @OldIsActiveOnMobile BIT = 1
                    DECLARE @OldMobileNo NVARCHAR(250) = NULL
                    DECLARE @OldEmployeeNumber NVARCHAR(250)
                    DECLARE @OldPassword NVARCHAR(800) = NULL
                    DECLARE @OldIsArchived BIT = NULL
                    DECLARE @OldTimeStamp TIMESTAMP = NULL
                    DECLARE @OldIsUpsertEmployee BIT = NULL
                    DECLARE @OldOperationsPerformedBy UNIQUEIDENTIFIER
                    DECLARE @OldBranchId UNIQUEIDENTIFIER = NULL
                    --DECLARE @OldDepartmentId UNIQUEIDENTIFIER = NULL
                    DECLARE @OldCurrencyId UNIQUEIDENTIFIER = NULL
                    DECLARE @OldTimeZoneId UNIQUEIDENTIFIER = NULL
                    DECLARE @OldActiveFrom DATETIME
                    DECLARE @OldPermittedBranches XML = NULL
                    DECLARE @OldActiveTo DATETIME = NULL
                    DECLARE @OldMacAddress VARCHAR(75) = NULL
					DECLARE @Inactive DATETIME = NULL
                    DECLARE @OldValue NVARCHAR(MAX) = NULL
					DECLARE @NewValue NVARCHAR(MAX) = NULL


                    SELECT @OldFirstName       = [FirstName],
                           @OldSurname         = [SurName],
                           @OldEmail           = [UserName],
                           @OldIsActive        = [IsActive],
                           @OldMobileNo        = [MobileNo],
                           @OldDateOfJoining   = [RegisteredDateTime], 
                           @OldDateOfLeaving   = [LastConnection],
                           @OldIsActiveOnMobile= [IsActiveOnMobile],
                           @Inactive           = [InActiveDateTime],
                           @OldCurrencyId      = [CurrencyId],
                           @OldTimeZoneId      = [TimeZoneId]
                           FROM [User] WHERE Id = @UserId
                   
                   SET @OldValue = (SELECT ',' + R.RoleName FROM [UserRole] UR JOIN [Role] R ON R.Id = UR.RoleId AND UR.InactiveDateTime IS NULL AND UR.UserId = @UserId FOR XML PATH(''))
                   SET @OldValue = (SELECT SUBSTRING(@OldValue,2,LEN(@OldValue)))


				   IF(@UserId IS NOT NULL)
                    BEGIN
                        SET @Password = (SELECT [Password] FROM [User] U WHERE U.Id = @UserId)
                    END

                    IF(@EmployeeId IS NULL AND @UserId IS NOT NULL)
                    BEGIN
                        SET @EmployeeId = (SELECT Id FROM Employee E WHERE InActiveDateTime IS NULL AND E.UserId = @UserId)
                    END

                    DECLARE @Currentdate DATETIME = GETDATE()
                    
					DECLARE @IsNewUser BIT = NULL 
                    
                    SELECT @OldPassword = [Password] FROM [User] WHERE InActiveDateTime IS NULL AND Id = @UserId
                
				  IF(@UserId IS NULL)
				  BEGIN

					  SET @UserId = NEWID()
					  SET @IsNewUser = 1
					  INSERT INTO [dbo].[User](
                                [Id],
                                [CompanyId],
                                [FirstName],
                                [SurName],
                                [UserName],
                                [Password],
                                [IsActive],
                                [MobileNo],
                                [RegisteredDateTime],
                                [LastConnection],
                                [IsActiveOnMobile],
                                [InActiveDateTime],
                                [CreatedDateTime],
                                [CreatedByUserId],
								[CurrencyId],
                                UserAuthenticationId,
								[TimeZoneId])
                         SELECT @UserId,
                                @CompanyId,
                                @FirstName,
                                @Surname,
                                @Email,
                                ISNULL(@OldPassword,@Password),
                                @IsActive,
                                @MobileNo,
                                @DateOfJoining,
                                @DateOfLeaving,
                                @IsActiveOnMobile,
                                CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
                                @Currentdate,
                                @OperationsPerformedBy,
								@CurrencyId,
                                @UserAuthenticationId,
								@TimeZoneId
						
						INSERT INTO UserRole
						(Id
						,UserId
						,RoleId
						,CreatedByUserId
						,CreatedDateTime)
						SELECT NEWID()
						       ,@UserId
							   ,Id
							   ,@OperationsPerformedBy
							   ,@Currentdate
							FROM dbo.UfnSplit(@RoleIds)

                         --INSERT INTO [dbo].[Intro] (Id,UserId,ModuleId,CreatedByUserId,CreatedDateTime,EnableIntro)
                         --SELECT NEWID(),@UserId,M.Id AS ModuleId,@OperationsPerformedBy,GETDATE(),1
                         --FROM Module M
                         --WHERE M.Id IN (
                         --SELECT ModuleId FROM CompanyModule CM 
                         --WHERE CM.CompanyId = @CompanyId 
                         --      --AND CM.IsActive = 1 AND CM.IsEnabled = 1
                         --      AND CM.InActiveDateTime IS NULL
                         --)

						END
                        ELSE
						BEGIN

                            IF(@IsArchived = 1 OR @IsActive = 0)
                            BEGIN
                                UPDATE ActivityTrackerDesktop SET InActiveDateTime = GETUTCDATE() WHERE Id = 
                                (SELECT TOP 1 DesktopId FROM [User] WHERE Id = @UserId)
                            END

							UPDATE [dbo].[User]
								SET  [CompanyId]					=		  @CompanyId,
									 [FirstName]					=		  @FirstName,
									 [SurName]  					=		  @Surname,
									 [UserName] 					=		  @Email,
									 [Password]	    				=		  ISNULL(@OldPassword,@Password),
									 [IsActive]						=		  @IsActive,
									 [MobileNo]						=		  @MobileNo,
									 [RegisteredDateTime]			=		  @DateOfJoining,
									 [LastConnection]				=		  @DateOfLeaving,
									 [IsActiveOnMobile]				=		  @IsActiveOnMobile,
									 [InActiveDateTime]				=		  CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									 [UpdatedDateTime]				=		  @Currentdate,
									 [UpdatedByUserId]				=		  @OperationsPerformedBy,
									 [CurrencyId]					=		  @CurrencyId,
                                     UserAuthenticationId           =          @UserAuthenticationId,
									 [TimeZoneId]					=		  @TimeZoneId,
                                     [DesktopId]                        =   CASE WHEN @IsArchived = 1 OR @IsActive = 0 THEN NULL ELSE [DesktopId] END
								WHERE Id = @UserId

								DECLARE @RoleIdsList TABLE
					            (
					               RoleId UNIQUEIDENTIFIER
					            )
                          
					INSERT INTO @RoleIdsList(RoleId)
					SELECT Id FROM dbo.UfnSplit(@RoleIds)

					UPDATE UserRole SET InactiveDateTime = @Currentdate
					                               ,[UpdatedDateTime] = @Currentdate
					           				       ,[UpdatedByUserId] = @OperationsPerformedBy
					WHERE UserId = @UserId

					INSERT INTO UserRole
						(Id
						,UserId
						,RoleId
						,CreatedByUserId
						,CreatedDateTime)
						SELECT NEWID()
						       ,@UserId							 
							   ,RoleId
							   ,@OperationsPerformedBy
							   ,@Currentdate
						FROM @RoleIdsList RL 

						END
                    
                    --  INSERT INTO [dbo].[Intro] (Id,UserId,ModuleId,CreatedByUserId,CreatedDateTime,EnableIntro)
                    --  SELECT NEWID(),@UserId,M.Id AS ModuleId,@OperationsPerformedBy,GETDATE(),1
                    --  FROM Module M
                    --  WHERE M.Id IN (
                    --  SELECT ModuleId FROM CompanyModule CM 
                    --  WHERE CM.CompanyId = @CompanyId 
                            --AND CM.IsActive = 1 AND CM.IsEnabled = 1
                     --       AND CM.InActiveDateTime IS NULL
                    --  )

                    IF (@UserId IS NULL OR (@DateOfLeaving IS NOT NULL AND @IsArchived = 1))
                    BEGIN
                     
                        DECLARE @UserActiveDetailsId UNIQUEIDENTIFIER = (SELECT Id FROM UserActiveDetails WHERE UserId = @UserId)


					IF(@UserActiveDetailsId IS NULL)
					BEGIN

					SET @UserActiveDetailsId = NEWID()
                        INSERT INTO UserActiveDetails(
                                                      Id,
                                                      UserId,
                                                      ActiveFrom,
                                                      ActiveTo,
                                                      CreatedDateTime,
                                                      CreatedByUserId
                                                     )
                                               SELECT @UserActiveDetailsId,
                                                      @UserId,
                                                      @DateOfJoining,
                                                      @DateOfLeaving,
                                                      @Currentdate,
                                                      @OperationsPerformedBy
					
					END
					ELSE
					BEGIN

						UPDATE UserActiveDetails
											   	SET  UserId					=		@UserId,
                                                      ActiveFrom			=		@DateOfJoining,
                                                      ActiveTo				=		@DateOfLeaving,
                                                      UpdatedDateTime		=		@Currentdate,
                                                      UpdatedByUserId		=		@OperationsPerformedBy
												WHERE Id = @UserActiveDetailsId

					END

                    END

				   SET @OldEmployeeNumber  = (SELECT EmployeeNumber FROM Employee 
				   WHERE Id = @EmployeeId AND InActiveDateTime IS NULL)

                           SELECT @OldGenderId       = [GenderId],
                                  @OldMaritalStatusId= [MaritalStatusId],
                                  @OldNationalityId  = [NationalityId],
                                  @OldDateOfBirth    = [DateofBirth],
                                  @OldTaxcode        = [TaxCode],
                                  @OldEmployeeNumber = [EmployeeNumber],
                                  @OldMacAddress     = [MacAddress],
                                  @Inactive          = [InActiveDateTime]
                                  FROM Employee WHERE Id = @EmployeeId

                   IF(@EmployeeId IS NULL)
				   BEGIN

					   SET @EmployeeId = NEWID()
					   INSERT INTO [dbo].Employee(
                                [Id],
                                [UserId],
                                [GenderId],
                                [MaritalStatusId],
                                [MarriageDate],
                                [NationalityId],
                                [DateofBirth],
                                [TaxCode],
                                [EmployeeNumber],
								[MacAddress],
                                [InActiveDateTime],
                                [CreatedDateTime],
                                [CreatedByUserId],
                                [IPNumber],
								FormJson
                                )
                         SELECT @EmployeeId,
                                @UserId,
                                @GenderId,
                                @MaritalStatusId,
                                @MarriageDate,
                                @NationalityId,
                                @DateOfBirth,
                                @Taxcode,
                                @EmployeeNumber,
								@MacAddress,
                                CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
                                @Currentdate,
                                @OperationsPerformedBy,
                                @IPNumber,
								@FormJson
                        --for employee import
                        IF(ISNULL(@Salary,0) > 0)
                        BEGIN
                            SET @PayGradeId = (SELECT TOP 1 Id FROM PayGrade WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL)
                            
                            SET @PayFrequencyId = (SELECT TOP 1 Id FROM PayFrequency WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL)

                            IF(@PayrollTemplateId IS NULL) SET @PayrollTemplateId = (SELECT TOP 1 Id FROM PayrollTemplate WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL)

                            IF(@PayGradeId IS NULL)
                            BEGIN

                                SET @PayGradeId = NEWID()
			                    INSERT INTO [dbo].PayGrade(
			                                [Id],
			                                PayGradeName,
			                                [CreatedDateTime],
			                                [CreatedByUserId],
					            			CompanyId)
			                         SELECT @PayGradeId,
			                                'Basic',
			                                @Currentdate,
			                                @OperationsPerformedBy,
					            			@CompanyId

                            END
                            IF(@PayFrequencyId IS NULL)
                            BEGIN

                                INSERT INTO PayFrequency( 
						                            Id,
													PayFrequencyName,
													CompanyId,
													CreatedDateTime,
													CreatedByUserId
												   )
											SELECT  @PayFrequencyId,
											        'Monthly',
													@CompanyId,
													@CurrentDate,
													@OperationsPerformedBy

                            END

						DECLARE @HaveUpsertEmployeeSalaryDetailsPermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,'USP_UpsertEmployeeSalaryDetails'))
				     
							IF(@HaveUpsertEmployeeSalaryDetailsPermission = '1' )
							BEGIN

								EXEC [dbo].[USP_UpsertEmployeeSalaryDetails] @EmployeeId = @EmployeeId,
							    @PayGradeId = @PayGradeId,@PayFrequencyId = @PayFrequencyId,
							    @Amount = @Salary,@CurrencyId = @CurrencyId,@StartDate = @DateOfJoining,
							    @OperationsPerformedBy = @OperationsPerformedBy,@NetPayAmount = NULL,
							    @PayrollTemplateId = @PayrollTemplateId,@NotReturnValue = 1

							END

                        END

					END
					ELSE
					BEGIN

						UPDATE [dbo].Employee
							SET [UserId]					=		 @UserId,
                                [GenderId]					=		 @GenderId,
                                [MaritalStatusId]			=		 @MaritalStatusId,
                                [MarriageDate]              =        @MarriageDate,
                                [NationalityId]				=		 @NationalityId,
                                [DateofBirth]				=		 @DateOfBirth,
                                [TaxCode]					=		 @Taxcode,
                                [EmployeeNumber]			=		 @EmployeeNumber,
								[MacAddress]                =        @MacAddress,
                                [InActiveDateTime]			=		 CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
                                [UpdatedDateTime]			=		 @Currentdate,
                                [UpdatedByUserId]			=		 @OperationsPerformedBy,
                                [IPNumber] = @IPNumber,
								FormJson = @FormJson
							WHERE Id = @EmployeeId

						IF(@OldEmployeeNumber IS NULL OR @OldEmployeeNumber <> @EmployeeNumber)
						BEGIN

							DECLARE @StoreId UNIQUEIDENTIFIER = (SELECT Id FROM Store WHERE IsDefault = 1 AND IsCompany = 1 AND CompanyId = @CompanyId AND InActiveDateTime IS NULL)
						
							UPDATE Folder SET FolderName = @EmployeeNumber,
											  UpdatedDateTime = @Currentdate,
											  UpdatedByUserId = @OperationsPerformedBy
											  WHERE Id IN (SELECT Id FROM Folder WHERE FolderName = @OldEmployeeNumber AND StoreId = @StoreId AND InActiveDateTime IS NULL)
						END

					END

                    DECLARE @RecordTitle NVARCHAR(MAX) = (SELECT FirstName + ' ' + ISNULL(SurName,'') FROM [User] WHERE Id = @UserId)

                    SET @NewValue = (SELECT ',' + R.RoleName FROM [UserRole] UR JOIN [Role] R ON R.Id = UR.RoleId AND UR.InactiveDateTime IS NULL AND UR.UserId = @UserId FOR XML PATH(''))
                    SET @NewValue = (SELECT SUBSTRING(@NewValue,2,LEN(@NewValue)))

                    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Personal details',
					@FieldName = 'Role(s)',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

				    SET @OldValue = (SELECT CurrencyName  FROM Currency WHERE Id = @OldCurrencyId)
					SET @NewValue = (SELECT CurrencyName  FROM Currency WHERE Id = @CurrencyId)

                    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Personal details',
					@FieldName = 'Currency',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

                    SET @OldValue = (SELECT TimeZoneName  FROM TimeZone WHERE Id = @OldTimeZoneId)
					SET @NewValue = (SELECT TimeZoneName  FROM TimeZone WHERE Id = @TimeZoneId)

                    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Personal details',
					@FieldName = 'Time zone',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle


                    IF(ISNULL(@OldMobileNo,'') <> @MobileNo AND @MobileNo IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Personal details',
					@FieldName = 'Mobile number',@OldValue = @OldMobileNo,@NewValue = @MobileNo,@RecordTitle = @RecordTitle

                    IF(ISNULL(@OldFirstName,'') <> @FirstName AND @FirstName IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Personal details',
					@FieldName = 'First name',@OldValue = @OldFirstName,@NewValue = @FirstName,@RecordTitle = @RecordTitle

                    IF(ISNULL(@OldSurname,'') <> @Surname AND @Surname IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Personal details',
					@FieldName = 'Last name',@OldValue = @OldSurname,@NewValue = @Surname,@RecordTitle = @RecordTitle

                    IF(ISNULL(@OldEmail,'') <> @Email AND @Email IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Personal details',
					@FieldName = 'Email',@OldValue = @OldEmail,@NewValue = @Email,@RecordTitle = @RecordTitle

                    SET @OldValue =  CONVERT(NVARCHAR(40),@OldDateOfJoining,20)
					SET @NewValue =  CONVERT(NVARCHAR(40),@DateOfJoining,20)

                    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Personal details',
					@FieldName = 'Joining date',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

                    SET @OldValue =  CONVERT(NVARCHAR(40),@OldDateOfLeaving,20)
					SET @NewValue =  CONVERT(NVARCHAR(40),@DateOfLeaving,20)

                    IF(ISNULL(@OldEmail,'') <> @Email AND @Email IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Personal details',
					@FieldName = 'Leaving date',@OldValue = @OldEmail,@NewValue = @Email,@RecordTitle = @RecordTitle

                    SET @OldValue = IIF(ISNULL(@OldIsActive,0) = 0,'Inactive','Active')
					SET @NewValue = IIF(ISNULL(@IsActive,0) = 0,'Inctive','Active')
					    
					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Salary details',
					@FieldName = 'Status',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

                    SET @OldValue = IIF(ISNULL(@OldIsActiveOnMobile,0) = 0,'Inactive','Active')
					SET @NewValue = IIF(ISNULL(@IsActiveOnMobile,0) = 0,'Inactive','Active')
					    
					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Salary details',
					@FieldName = 'Active on mobile',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

                    SET @OldValue = IIF(@Inactive IS NOT NULL,'Archived','Unarchived')
					SET @NewValue = IIF(ISNULL(@IsArchived,0) = 0,'UnArchived','Archived')
					    
					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'User details',
					@FieldName = 'Archive',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

                    SET @OldValue = (SELECT MaritalStatus  FROM MaritalStatus WHERE Id = @OldMaritalStatusId)
					SET @NewValue = (SELECT MaritalStatus  FROM MaritalStatus WHERE Id = @MaritalStatusId)

                    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Personal details',
					@FieldName = 'Marital status',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

                    SET @OldValue = (SELECT Gender  FROM Gender WHERE Id = @OldGenderId)
					SET @NewValue = (SELECT Gender  FROM Gender WHERE Id = @GenderId)

                    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Personal details',
					@FieldName = 'Gender',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

                    SET @OldValue = (SELECT NationalityName  FROM Nationality WHERE Id = @OldNationalityId)
					SET @NewValue = (SELECT NationalityName  FROM Nationality WHERE Id = @NationalityId)

                    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Personal details',
					@FieldName = 'Nationality',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

                    IF(ISNULL(@OldEmployeeNumber,'') <> @EmployeeNumber AND @EmployeeNumber IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Personal details',
					@FieldName = 'Employee number',@OldValue = @OldEmployeeNumber,@NewValue = @EmployeeNumber,@RecordTitle = @RecordTitle

                    IF(ISNULL(@OldTaxcode,'') <> @Taxcode AND @Taxcode IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Personal details',
					@FieldName = 'Tax code',@OldValue = @OldTaxcode,@NewValue = @Taxcode,@RecordTitle = @RecordTitle

                    IF(ISNULL(@OldMacAddress,'') <> @MacAddress AND @MacAddress IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Personal details',
					@FieldName = 'Mac address',@OldValue = @OldMacAddress,@NewValue = @MacAddress,@RecordTitle = @RecordTitle

					SET @OldValue =  CONVERT(NVARCHAR(40),@OldDateOfBirth,20)
					SET @NewValue =  CONVERT(NVARCHAR(40),@DateOfBirth,20)

                    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Personal details',
					@FieldName = 'Date of birth',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

                    SET @OldValue = IIF(@Inactive IS NOT NULL,'Archived','Unarchived')
					SET @NewValue = IIF(ISNULL(@IsArchived,0) = 0,'UnArchived','Archived')
					    
					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Employee details',
					@FieldName = 'Archive',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

                    IF (@UserId IS NULL OR @ToUpdateJob = 1)
                    BEGIN

                    SELECT @OldEmploymentStatusId = EmploymentStatusId,
                           @OldJobCategoryId      = JobCategoryId,
                           @OldDesignationId      = DesignationId,
                           @OldDateOfJoining      = JoinedDate,
                           @OldDepartmentId       = DepartmentId,
                           @Inactive              = InActiveDateTime
                           FROM Job WHERE Id = @JobId

                    IF( @JobId IS NULL)
					BEGIN

					SET @JobId = NEWID()
                    INSERT INTO [dbo].[Job](
                                        Id,
                                        EmployeeId,
                                        EmploymentStatusId,
                                        JobCategoryId,
                                        DesignationId,
										BranchId,
                                        JoinedDate,
                                        DepartmentId,
                                        CreatedByUserId,
                                        CreatedDateTime,
                                        InActiveDateTime
                                       )
                                 SELECT @JobId,
                                        @EmployeeId,
                                        @EmploymentStatusId,
                                        @JobCategoryId,
                                        @DesignationId,
										@BranchId,
                                        @DateOfJoining,
                                        @DepartmentId,
                                        @OperationsPerformedBy,
                                        @Currentdate,
                                        CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END

				END
				ELSE
				BEGIN

					UPDATE [dbo].[Job]
									SET EmployeeId					=	    @EmployeeId,
                                        EmploymentStatusId			=	    @EmploymentStatusId,
                                        JobCategoryId				=	    @JobCategoryId,
                                        DesignationId				=	    @DesignationId,
										BranchId                    =       @BranchId,
                                        JoinedDate					=	    @DateOfJoining,
                                        DepartmentId				=	    @DepartmentId,
                                        UpdatedByUserId				=	    @OperationsPerformedBy,
                                        UpdatedDateTime				=	    @Currentdate,
                                        InActiveDateTime			=	    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
									WHERE Id = @JobId

				END

                        SET @OldValue = (SELECT DesignationName FROM Designation WHERE Id = @OldDesignationId)
					    SET @NewValue = (SELECT DesignationName FROM Designation WHERE Id = @DesignationId)
					    
					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Job details',
					    @FieldName = 'Designation',@OldValue = @OldValue,@NewValue = @NewValue
					    
					    SET @OldValue = (SELECT EmploymentStatusName FROM EmploymentStatus WHERE Id = @OldEmploymentStatusId)
					    SET @NewValue = (SELECT EmploymentStatusName FROM EmploymentStatus WHERE Id = @EmploymentStatusId)
					    
					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Job details',
					    @FieldName = 'Employment status',@OldValue = @OldValue,@NewValue = @NewValue
					    
					    SET @OldValue = (SELECT JobCategoryType FROM JobCategory WHERE Id = @JobCategoryId)
					    SET @NewValue = (SELECT JobCategoryType FROM JobCategory WHERE Id = @JobCategoryId)
					    
					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Job details',
					    @FieldName = 'Job category',@OldValue = @OldValue,@NewValue = @NewValue
					    
					    SET @OldValue = (SELECT DepartmentName FROM Department WHERE Id = @OldDepartmentId)
					    SET @NewValue = (SELECT DepartmentName FROM Department WHERE Id = @DepartmentId)
					    
					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Job details',
					    @FieldName = 'Department',@OldValue = @OldValue,@NewValue = @NewValue

                        SET @OldValue = IIF(@Inactive IS NOT NULL,'Archived','Unarchived')
					    SET @NewValue = IIF(ISNULL(@IsArchived,0) = 0,'UnArchived','Archived')
					        
					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Job details',
					    @FieldName = 'Archive',@OldValue = @OldValue,@NewValue = @NewValue

                    END
						  
						  DECLARE @EmployeeBranchTimeStamp TIMESTAMP  = (SELECT TOP 1 [TimeStamp] FROM EmployeeBranch WHERE ActiveFrom IS NOT NULL AND (ActiveTo IS NULL OR ActiveTo >= GETDATE()) AND EmployeeId = @EmployeeId ORDER BY ISNULL(UpdatedDateTime,CreatedDateTime) DESC)

                          DECLARE @BranchActiveFrom DATETIME = (ISNULL(@DateOfJoining,@Currentdate))
						                                                                                                                   
                          IF(((@BranchId IS NOT NULL AND (@OldEmployeeBranchId <> @BranchId OR (@OldActiveFromDate <> @BranchActiveFrom AND @OldActiveFromDate > @BranchActiveFrom))) OR (@EmployeeBranchId IS NULL AND @BranchId IS NOT NULL)) AND @IsUpsertEmployee = 1)
						  BEGIN

						    EXEC USP_UpsertEmployeeBranch @EmployeeBranchId = @EmployeeBranchId, @EmployeeId = @EmployeeId,
						    @OperationsPerformedBy= @OperationsPerformedBy,@BranchId = @BranchId,@IsArchived = @IsArchived,
						    @ActiveFrom = @BranchActiveFrom,@TimeStamp = @EmployeeBranchTimeStamp

						  END

                           --TODO : Inactive all entities and activating given entities
                           IF(@PermittedBranches IS NOT NULL AND @IsUpsertEmployee = 1)
                           BEGIN
                               
                               UPDATE EmployeeEntity SET InactiveDateTime = @Currentdate
                                                         ,UpdatedByUserId = @OperationsPerformedBy
                                                         ,UpdatedDateTime = @Currentdate
                                           WHERE EmployeeId = @EmployeeId

                               UPDATE EmployeeEntityBranch SET InactiveDateTime = @Currentdate
                                                         ,UpdatedByUserId = @OperationsPerformedBy
                                                         ,UpdatedDateTime = @Currentdate
                                           WHERE EmployeeId = @EmployeeId

                                INSERT INTO [dbo].[EmployeeEntity](
                                               [Id]
                                               ,[EmployeeId]
                                               ,[EntityId]
                                               ,[CreatedByUserId]
                                               ,[CreatedDateTime]
                                               )
                                   SELECT NEWID()
                                          ,@EmployeeId
                                          ,X.Y.value('(text())[1]','UNIQUEIDENTIFIER')
                                          ,@OperationsPerformedBy
                                          ,@Currentdate
                                   FROM @PermittedBranches.nodes('GenericListOfNullableOfGuid/ListItems/guid') AS X(Y)
                                
                                INSERT INTO EmployeeEntityBranch(Id,EmployeeId,BranchId,CreatedByUserId,CreatedDateTime)
                                SELECT NEWID(),@EmployeeId,T.BranchId,@OperationsPerformedBy,@Currentdate
                                FROM  (SELECT EB.BranchId
                                       FROM EmployeeEntity EN INNER JOIN EntityBranch EB ON EN.EntityId = EB.EntityId
                                       WHERE EN.EmployeeId = @EmployeeId AND EN.InactiveDateTime IS NULL
                                       GROUP BY EB.BranchId
                                      ) T

                           END

                           IF(@IsUpsertEmployee = 1)
                           BEGIN
                                
                                IF(@BusinessUnitXML IS NOT NULL)
                                BEGIN

                                    SELECT X.Y.value('(text())[1]', 'UNIQUEIDENTIFIER') AS BusinessUnitId
						            INTO #BusinessUnitList
						            FROM @BusinessUnitXML.nodes('/GenericListOfNullableOfGuid/*/guid') AS X(Y)

						            UPDATE BusinessUnitEmployeeConfiguration 
						            SET ActiveTo = @CurrentDate
						                ,UpdatedByUserId = @OperationsPerformedBy
						            	,UpdatedDateTime = @CurrentDate
						            WHERE EmployeeId = @EmployeeId
						                  AND BusinessUnitId NOT IN (SELECT BusinessUnitId FROM #BusinessUnitList)

						            UPDATE BusinessUnitEmployeeConfiguration
						            SET ActiveTo = NULL
						            	,UpdatedByUserId = @OperationsPerformedBy
						            	,UpdatedDateTime = @CurrentDate
						            WHERE EmployeeId = @EmployeeId
						                  AND BusinessUnitId IN (SELECT BusinessUnitId FROM #BusinessUnitList)

						            INSERT INTO BusinessUnitEmployeeConfiguration(Id,BusinessUnitId,EmployeeId,ActiveFrom,[CreatedDateTime],CreatedByUserId)
						            SELECT NEWID(),BusinessUnitId,@EmployeeId,@CurrentDate,@CurrentDate,@OperationsPerformedBy
						            FROM #BusinessUnitList 
						            WHERE BusinessUnitId NOT IN (SELECT BusinessUnitId FROM BusinessUnitEmployeeConfiguration EB 
                                                                 WHERE EmployeeId = @EmployeeId
                                                                 AND EB.ActiveFrom <= GETDATE() AND (EB.ActiveTo IS NULL OR EB.ActiveTo >= GETDATE())
                                                                 )
                                
                                END
                                ELSE IF(@BusinessUnitXML IS NULL)
                                BEGIN
                                    
                                    UPDATE BusinessUnitEmployeeConfiguration 
						            SET ActiveTo = @CurrentDate
						                ,UpdatedByUserId = @OperationsPerformedBy
						            	,UpdatedDateTime = @CurrentDate
						            WHERE EmployeeId = @EmployeeId

                                END

                        END

						DECLARE @EmployeeShiftTimingId UNIQUEIDENTIFIER 
                        DECLARE @OldEmployeeShiftTimingId UNIQUEIDENTIFIER
                        DECLARE @OldShiftTimingId UNIQUEIDENTIFIER 
                        DECLARE @IsShiftArchived BIT = 0
                        SELECT @EmployeeShiftTimingId = Id, @OldEmployeeShiftTimingId = ShiftTimingId ,
                        @OldShiftTimingId = ShiftTimingId FROM EmployeeShift WHERE EmployeeId = @EmployeeId 
                        AND InactiveDateTime IS NULL
                          IF(((@ShiftTimingId IS NOT NULL AND @OldEmployeeShiftTimingId <> @ShiftTimingId)
                              OR (@EmployeeShiftTimingId IS NULL AND @ShiftTimingId IS NOT NULL) 
                              OR (@OldShiftTimingId IS NOT NULL AND @ShiftTimingId IS NULL) 
                              OR (@OldShiftTimingId IS NULL AND @ShiftTimingId IS NOT NULL)) AND @IsUpsertEmployee = 1)
                          BEGIN
                        IF(@OldShiftTimingId IS NOT NULL AND @ShiftTimingId IS NULL)
                        BEGIN
                            SET @IsShiftArchived = 1 
                            SET @ShiftTimingId = @OldShiftTimingId
                        END
                        DECLARE @EmployeeShiftTimingTimeStamp TIMESTAMP = (SELECT [TimeStamp] FROM EmployeeShift WHERE EmployeeId = @EmployeeId AND Id = @EmployeeShiftId
                        AND InactiveDateTime IS NULL)
                          EXEC USP_UpsertEmployeeShift @EmployeeShiftId = @EmployeeShiftId, @EmployeeId = @EmployeeId,
                          @OperationsPerformedBy = @OperationsPerformedBy,@ShiftTimingId = @ShiftTimingId,
                          @ActiveFrom = @DateOfJoining, @TimeStamp = @EmployeeShiftTimingTimeStamp
						  
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
        END
    END TRY
    BEGIN CATCH
        
        THROW
    
    END CATCH
END
GO