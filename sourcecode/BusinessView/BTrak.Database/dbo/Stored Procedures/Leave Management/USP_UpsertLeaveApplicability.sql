----------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-08-09 00:00:00.000'
-- Purpose      To Upsert Leave Applicability by applying differnt filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
--EXEC [dbo].[UpsertLeaveApplicability]  @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971', @RoleId = '90D51FD0-F599-4B89-AD20-31A74F1A93EA', @LeaveTypeId = '314EB7D7-19C1-4B0E-AF87-C4CCD091FBDF',
--@EmployeeTypeId = '2C7C3D13-A1C1-4847-AB61-FEC937B6C7D5', @TotalOffLeaveId = '1862A820-6A8F-48EB-A2F4-ECAEEDD221B9', @DateFrom = '2019-08-09 00:00:00.000', @IsArchived = 0,
--@ApplicationXml = N'<?xml version="1.0" encoding="UTF-16"?>
--<GenericListOfXmlList xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
--<ListItems>
--<XmlList>
--<RoleId>860484f4-2e1f-4a0a-bd36-3509611ea6e3</RoleId>
--<GenderId>73d964d8-238f-4e8b-a269-1856a7caddc6</GenderId>
--<MaritalStatusId>60520164-8b24-465a-b875-8e4b4b6c0539</MaritalStatusId>
--<BranchId>63053486-89d4-47b6-ab2a-934a9f238812</BranchId>
--</XmlList>
--</ListItems>
--<GenericListOfXmlList/>'
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertLeaveApplicability]
(
	@LeaveApplicabiltyId UNIQUEIDENTIFIER = NULL,
	@LeaveTypeId UNIQUEIDENTIFIER = NULL,
	@EmployeeTypeId UNIQUEIDENTIFIER = NULL,
	@MinExperienceInMonths FLOAT = NULL,
	@MaxExperienceInMonths FLOAT = NULL,
	@MaxLeaves INT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@IsArchived BIT = NULL,
	@DepartmentId UNIQUEIDENTIFIER = NULL,
    @TimeStamp TIMESTAMP = NULL,
	@RoleIdXml XML = NULL,
	@BranchIdXml XML = NULL,
	@GenderIdXml XML = NULL,
	@MaritalStatusIdXml XML = NULL,
	@EmployeeIdXml XML = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		
		IF(@EmployeeTypeId = '00000000-0000-0000-0000-000000000000') SET @EmployeeTypeId = NULL  
		
		IF(@LeaveTypeId = '00000000-0000-0000-0000-000000000000') SET @LeaveTypeId = NULL  
        
		IF(@LeaveTypeId IS NULL)
		BEGIN
		
			RAISERROR(50011,16, 2, 'LeaveType')
		  
		END	
		ELSE
		BEGIN

			DECLARE @LeaveApplicabilityIdCount INT = (SELECT COUNT(1) FROM LeaveApplicability WHERE Id = @LeaveApplicabiltyId)

			IF(@LeaveApplicabilityIdCount = 0 AND @LeaveApplicabiltyId IS NOT NULL)

			BEGIN
              
		  		RAISERROR(50002,16, 2,'LeaveApplicability')
          
			END
			ELSE
			BEGIN

				DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

				IF (@HavePermission = '1')
				BEGIN
				    
					DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

					DECLARE @IsLatest BIT = (CASE WHEN @LeaveApplicabiltyId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM LeaveApplicability WHERE Id = @LeaveApplicabiltyId) = @TimeStamp THEN 1 ELSE 0 END END)
			        
					IF(@IsLatest = 1)
					BEGIN

						CREATE TABLE #RoleApplicable (
											  Id UNIQUEIDENTIFIER,
											  LeaveTypeId UNIQUEIDENTIFIER,
											  RoleId UNIQUEIDENTIFIER,
											  OriginalRoleId UNIQUEIDENTIFIER,
											  IsRole BIT
					                         )
											 
						CREATE TABLE #BranchApplicable (
											  Id UNIQUEIDENTIFIER,
											  LeaveTypeId UNIQUEIDENTIFIER,
											  BranchId UNIQUEIDENTIFIER,
											  OriginalBranchId UNIQUEIDENTIFIER,
											  IsBranch BIT
					                         )

											 
						CREATE TABLE #GenderApplicable (
											  Id UNIQUEIDENTIFIER,
											  LeaveTypeId UNIQUEIDENTIFIER,
											  GenderId UNIQUEIDENTIFIER,
											  OriginalGenderId UNIQUEIDENTIFIER,
											  IsGender BIT
					                         )

											 
						CREATE TABLE #MariatalStatusApplicable (
											  Id UNIQUEIDENTIFIER,
											  LeaveTypeId UNIQUEIDENTIFIER,
											  MariatalStatusId UNIQUEIDENTIFIER,
											  OriginalMariatalId UNIQUEIDENTIFIER,
											  IsMariatalStatus BIT
					                         )

					   CREATE TABLE #EmployeeApplicable (
											  Id UNIQUEIDENTIFIER,
											  LeaveTypeId UNIQUEIDENTIFIER,
											  EmployeeId UNIQUEIDENTIFIER,
											  OriginalEmployeeId UNIQUEIDENTIFIER,
											  IsEmployee BIT
					                         )

					INSERT INTO #RoleApplicable (Id,LeaveTypeId,RoleId)
					SELECT NEWID(),
					       @LeaveTypeId,
						   x.y.value('(text())[1]', 'uniqueidentifier')
						   FROM @RoleIdXml.nodes('GenericListOfNullableOfGuid/ListItems/guid') AS x(y)


					INSERT INTO #BranchApplicable (Id,LeaveTypeId,BranchId)
					SELECT NEWID(),
					       @LeaveTypeId,
						   x.y.value('(text())[1]', 'uniqueidentifier')
						   FROM @BranchIdXml.nodes('GenericListOfNullableOfGuid/ListItems/guid') AS x(y)

					INSERT INTO #GenderApplicable (Id,LeaveTypeId,GenderId)
					SELECT NEWID(),
					       @LeaveTypeId,
						   x.y.value('(text())[1]', 'uniqueidentifier')
						   FROM @GenderIdXml.nodes('GenericListOfNullableOfGuid/ListItems/guid') AS x(y)

					INSERT INTO #MariatalStatusApplicable (Id,LeaveTypeId,MariatalStatusId)
					SELECT NEWID(),
					       @LeaveTypeId,
						   x.y.value('(text())[1]', 'uniqueidentifier')
						   FROM @MaritalStatusIdXml.nodes('GenericListOfNullableOfGuid/ListItems/guid') AS x(y)

				    INSERT INTO #EmployeeApplicable (Id,LeaveTypeId,EmployeeId)
					SELECT NEWID(),
					       @LeaveTypeId,
						   x.y.value('(text())[1]', 'uniqueidentifier')
						   FROM @EmployeeIdXml.nodes('GenericListOfNullableOfGuid/ListItems/guid') AS x(y)
                    
					UPDATE #RoleApplicable SET OriginalRoleId = RLT.Id 
					                      ,IsRole = CASE WHEN A.RoleId = RLT.RoleId AND A.LeaveTypeId = RLT.LeaveTypeId THEN 1 ELSE 0 END
					                   FROM RoleLeaveType RLT JOIN #RoleApplicable A ON A.RoleId = RLT.RoleId AND A.LeaveTypeId = RLT.LeaveTypeId
					
					UPDATE RoleLeaveType SET InactiveDateTime = GETDATE(),UpdatedByUserId = @OperationsPerformedBy,UpdatedDateTime = GETDATE() WHERE LeaveTypeId = @LeaveTypeId AND Id NOT IN (SELECT OriginalRoleId FROM #RoleApplicable) AND InactiveDateTime IS NULL

					UPDATE RoleLeaveType SET InactiveDateTime = NULL,UpdatedByUserId = @OperationsPerformedBy,UpdatedDateTime = GETDATE() WHERE LeaveTypeId = @LeaveTypeId AND Id IN (SELECT OriginalRoleId FROM #RoleApplicable) AND InactiveDateTime IS NOT NULL

					IF(@RoleIdXml IS NULL AND @EmployeeIdXml IS NULL)
					BEGIN

					INSERT INTO RoleLeaveType (
										       Id
											  ,RoleId
											  ,LeaveTypeId
											  ,CompanyId
											  ,CreatedByUserId
											  ,CreatedDateTime
											  ,IsAccessAll
											  )
										SELECT NEWID()
										      ,NULL
											  ,@LeaveTypeId
											  ,@CompanyId
											  ,@OperationsPerformedBy
											  ,GETDATE()
											  ,1

					END
					ELSE
					BEGIN

					UPDATE RoleLeaveType SET InactiveDateTime = GETDATE(),UpdatedByUserId = @OperationsPerformedBy,UpdatedDateTime = GETDATE() WHERE LeaveTypeId = @LeaveTypeId AND IsAccessAll = 1 AND InactiveDateTime IS NULL

					END

					INSERT INTO RoleLeaveType (
										       Id
											  ,RoleId
											  ,LeaveTypeId
											  ,CompanyId
											  ,CreatedByUserId
											  ,CreatedDateTime
											  )
										SELECT NEWID()
										      ,A.RoleId
											  ,@LeaveTypeId
											  ,@CompanyId
											  ,@OperationsPerformedBy
											  ,GETDATE()
										       FROM #RoleApplicable A WHERE (IsRole IS NULL OR IsRole = 0)

					UPDATE #BranchApplicable SET OriginalBranchId = BLT.Id
					                      ,IsBranch = CASE WHEN A.BranchId = BLT.BranchId AND A.LeaveTypeId = BLT.LeaveTypeId THEN 1 ELSE 0 END
					                   FROM BranchLeaveType BLT JOIN #BranchApplicable A ON A.BranchId = BLT.BranchId AND A.LeaveTypeId = BLT.LeaveTypeId
					
					UPDATE BranchLeaveType SET InactiveDateTime = GETDATE(),UpdatedByUserId = @OperationsPerformedBy,UpdatedDateTime = GETDATE() WHERE LeaveTypeId = @LeaveTypeId AND Id NOT IN (SELECT OriginalBranchId FROM #BranchApplicable) AND InactiveDateTime IS NULL

					UPDATE BranchLeaveType SET InactiveDateTime = NULL,UpdatedByUserId = @OperationsPerformedBy,UpdatedDateTime = GETDATE() WHERE LeaveTypeId = @LeaveTypeId AND Id IN (SELECT OriginalBranchId FROM #BranchApplicable) AND InactiveDateTime IS NOT NULL


					IF(@BranchIdXml IS NULL AND @EmployeeIdXml IS NULL)
					BEGIN

					INSERT INTO BranchLeaveType (
										       Id
											  ,BranchId
											  ,LeaveTypeId
											  ,CompanyId
											  ,CreatedByUserId
											  ,CreatedDateTime
											  ,IsAccessAll
											  )
										SELECT NEWID()
										      ,NULL
											  ,@LeaveTypeId
											  ,@CompanyId
											  ,@OperationsPerformedBy
											  ,GETDATE()
											  ,1

					END
					ELSE
					BEGIN

					UPDATE BranchLeaveType SET InactiveDateTime = GETDATE(),UpdatedByUserId = @OperationsPerformedBy,UpdatedDateTime = GETDATE() WHERE LeaveTypeId = @LeaveTypeId AND IsAccessAll = 1 AND InactiveDateTime IS NULL

					END

					INSERT INTO BranchLeaveType (
										       Id
											  ,BranchId
											  ,LeaveTypeId
											  ,CompanyId
											  ,CreatedByUserId
											  ,CreatedDateTime
											  )
										SELECT NEWID()
										      ,A.BranchId
											  ,@LeaveTypeId
											  ,@CompanyId
											  ,@OperationsPerformedBy
											  ,GETDATE()
										       FROM #BranchApplicable A WHERE (IsBranch IS NULL OR IsBranch = 0)

					UPDATE #GenderApplicable SET OriginalGenderId = GLT.Id
					                      ,IsGender = CASE WHEN A.GenderId = GLT.GenderId AND A.LeaveTypeId = GLT.LeaveTypeId THEN 1 ELSE 0 END
					                   FROM GenderLeaveType GLT JOIN #GenderApplicable A ON A.GenderId = GLT.GenderId AND A.LeaveTypeId = GLT.LeaveTypeId
					
					UPDATE GenderLeaveType SET InactiveDateTime = GETDATE(),UpdatedByUserId = @OperationsPerformedBy,UpdatedDateTime = GETDATE() WHERE LeaveTypeId = @LeaveTypeId AND Id NOT IN (SELECT OriginalGenderId FROM #GenderApplicable) AND InactiveDateTime IS NULL

					UPDATE GenderLeaveType SET InactiveDateTime = NULL,UpdatedByUserId = @OperationsPerformedBy,UpdatedDateTime = GETDATE() WHERE LeaveTypeId = @LeaveTypeId AND Id IN (SELECT OriginalGenderId FROM #GenderApplicable) AND InactiveDateTime IS NOT NULL

					IF(@GenderIdXml IS NULL AND @EmployeeIdXml IS NULL)
					BEGIN

					INSERT INTO GenderLeaveType (
										       Id
											  ,GenderId
											  ,LeaveTypeId
											  ,CompanyId
											  ,CreatedByUserId
											  ,CreatedDateTime
											  ,IsAccessAll
											  )
										SELECT NEWID()
										      ,NULL
											  ,@LeaveTypeId
											  ,@CompanyId
											  ,@OperationsPerformedBy
											  ,GETDATE()
											  ,1

					END
					ELSE
					BEGIN

					UPDATE GenderLeaveType SET InactiveDateTime = GETDATE(),UpdatedByUserId = @OperationsPerformedBy,UpdatedDateTime = GETDATE() WHERE LeaveTypeId = @LeaveTypeId AND IsAccessAll = 1 AND InactiveDateTime IS NULL

					END

					INSERT INTO GenderLeaveType (
										       Id
											  ,GenderId
											  ,LeaveTypeId
											  ,CompanyId
											  ,CreatedByUserId
											  ,CreatedDateTime
											  )
										SELECT NEWID()
										      ,A.GenderId
											  ,@LeaveTypeId
											  ,@CompanyId
											  ,@OperationsPerformedBy
											  ,GETDATE()
										       FROM #GenderApplicable A WHERE (IsGender IS NULL OR IsGender = 0)

					UPDATE #MariatalStatusApplicable SET OriginalMariatalId = MLT.Id
					                      ,IsMariatalstatus = CASE WHEN A.MariatalStatusId = MLT.MariatalStatusId AND A.LeaveTypeId = MLT.LeaveTypeId THEN 1 ELSE 0 END
					                   FROM MariatalStatusLeaveType MLT JOIN #MariatalStatusApplicable A ON A.MariatalStatusId = MLT.MariatalStatusId AND A.LeaveTypeId = MLT.LeaveTypeId
					
					UPDATE MariatalStatusLeaveType SET InactiveDateTime = GETDATE(),UpdatedByUserId = @OperationsPerformedBy,UpdatedDateTime = GETDATE() WHERE LeaveTypeId = @LeaveTypeId AND Id NOT IN (SELECT OriginalMariatalId FROM #MariatalStatusApplicable) AND InactiveDateTime IS NULL

					UPDATE MariatalStatusLeaveType SET InactiveDateTime = NULL,UpdatedByUserId = @OperationsPerformedBy,UpdatedDateTime = GETDATE() WHERE LeaveTypeId = @LeaveTypeId AND Id IN (SELECT OriginalMariatalId FROM #MariatalStatusApplicable) AND InactiveDateTime IS NOT NULL

					IF(@MaritalStatusIdXml IS NULL AND @EmployeeIdXml IS NULL)
					BEGIN

					INSERT INTO MariatalStatusLeaveType (
										       Id
											  ,MariatalStatusId
											  ,LeaveTypeId
											  ,CompanyId
											  ,CreatedByUserId
											  ,CreatedDateTime
											  ,IsAccessAll
											  )
										SELECT NEWID()
										      ,NULL
											  ,@LeaveTypeId
											  ,@CompanyId
											  ,@OperationsPerformedBy
											  ,GETDATE()
											  ,1

					END
					ELSE
					BEGIN

					UPDATE MariatalStatusLeaveType SET InactiveDateTime = GETDATE(),UpdatedByUserId = @OperationsPerformedBy,UpdatedDateTime = GETDATE() WHERE LeaveTypeId = @LeaveTypeId AND IsAccessAll = 1 AND InactiveDateTime IS NULL

					END

					INSERT INTO MariatalStatusLeaveType (
										                 Id
											            ,MariatalStatusId
											            ,LeaveTypeId
											            ,CompanyId
											            ,CreatedByUserId
											            ,CreatedDateTime
											            )
										          SELECT NEWID()
										                ,A.MariatalStatusId
										           	    ,@LeaveTypeId
										           	    ,@CompanyId
										           	    ,@OperationsPerformedBy
										           	    ,GETDATE()
										                FROM #MariatalStatusApplicable A WHERE (IsMariatalstatus IS NULL OR IsMariatalstatus = 0) 

					UPDATE #EmployeeApplicable SET OriginalEmployeeId = ELT.Id
					                      ,IsEmployee = CASE WHEN A.EmployeeId = ELT.EmployeeId AND A.LeaveTypeId = ELT.LeaveTypeId THEN 1 ELSE 0 END
					                   FROM EmployeeLeaveType ELT JOIN #EmployeeApplicable A ON A.EmployeeId = ELT.EmployeeId AND A.LeaveTypeId = ELT.LeaveTypeId
					
					UPDATE EmployeeLeaveType SET InactiveDateTime = GETDATE(),UpdatedByUserId = @OperationsPerformedBy,UpdatedDateTime = GETDATE() WHERE LeaveTypeId = @LeaveTypeId AND Id NOT IN (SELECT OriginalEmployeeId FROM #EmployeeApplicable) AND InactiveDateTime IS NULL

					UPDATE EmployeeLeaveType SET InactiveDateTime = NULL,UpdatedByUserId = @OperationsPerformedBy,UpdatedDateTime = GETDATE() WHERE LeaveTypeId = @LeaveTypeId AND Id IN (SELECT OriginalEmployeeId FROM #EmployeeApplicable) AND InactiveDateTime IS NOT NULL

					INSERT INTO EmployeeLeaveType (Id
											      ,EmployeeId
											      ,LeaveTypeId
											      ,CompanyId
											      ,CreatedByUserId
											      ,CreatedDateTime)
									       SELECT NEWID()
										          ,A.EmployeeId
										          ,@LeaveTypeId
										          ,@CompanyId
										          ,@OperationsPerformedBy
										          ,GETDATE()
										     FROM #EmployeeApplicable A WHERE (IsEmployee IS NULL OR IsEmployee = 0)

					DECLARE @Currentdate DATETIME = GETDATE()

					DECLARE @NewLeaveApplicabilityId UNIQUEIDENTIFIER = NEWID()

					SET @MinExperienceInMonths = CASE WHEN @MinExperienceInMonths IS NULL THEN 0 ELSE @MinExperienceInMonths END

					IF(@LeaveApplicabiltyId IS NULL)
					BEGIN
					INSERT INTO [dbo].[LeaveApplicability](
								                           [Id],
								                           [MinExperienceInMonths],
								                           [MaxExperienceInMonths],
								                           [MaxLaves],
								                           [LeaveTypeId],
								                           [EmployeeTypeId],
								                           [InActiveDateTime]
								                          )
						                            SELECT @NewLeaveApplicabilityId,
						                            	   @MinExperienceInMonths * 12.0,
						                            	   @MaxExperienceInMonths * 12.0,
						                            	   @MaxLeaves,
						                            	   @LeaveTypeId,
						                            	   @EmployeeTypeId,
						                            	   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
					END
					ELSE
					BEGIN
						
						UPDATE LeaveApplicability SET  [MinExperienceInMonths] = @MinExperienceInMonths * 12.0,
								                       [MaxExperienceInMonths]= @MaxExperienceInMonths * 12.0,
								                       [MaxLaves] = @MaxLeaves,
								                       [LeaveTypeId] = @LeaveTypeId,
								                       [EmployeeTypeId] = @EmployeeTypeId,
								                       [InActiveDateTime] =  CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
													   WHERE Id = @LeaveApplicabiltyId
					END
					END
					ELSE

						RAISERROR(50008,11,1)

				END
				ELSE

					RAISERROR(@HavePermission,11,1)
			END
		 END
	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
GO