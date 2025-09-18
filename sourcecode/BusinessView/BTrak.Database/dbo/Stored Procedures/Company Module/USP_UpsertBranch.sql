-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-07 00:00:00.000'
-- Purpose      To Save or Update Branch
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertBranch] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',
-- @BranchName = 'Test1'						  
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertBranch]
(
   @BranchId UNIQUEIDENTIFIER = NULL,
   @BranchName NVARCHAR(50) = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @IsHeadOffice BIT = NULL,
   @Address NVARCHAR(1000) = NULL,
   @TimeZoneId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		DECLARE @EmployeeBranchRecordsCount INT = (SELECT COUNT(1) FROM EmployeeBranch WHERE BranchId = @BranchId)
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		IF(@IsArchived = 1 AND @BranchId IS NOT NULL)
		BEGIN
		      DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
	          IF(EXISTS(SELECT Id FROM EmployeeBranch WHERE BranchId = @BranchId))
	          BEGIN
	          SET @IsEligibleToArchive = 'ThisBranchUsedInEmployeeBranchPleaseDeleteTheDependenciesAndTryAgain'
	          END
	          ELSE IF(EXISTS(SELECT Id FROM SeatingArrangement WHERE BranchId = @BranchId))
	          BEGIN
	          SET @IsEligibleToArchive = 'ThisBranchUsedInSeatingArrangementPleaseDeleteTheDependenciesAndTryAgain'
	          END
	          IF(EXISTS(SELECT Id FROM SoftLabel WHERE BranchId = @BranchId))
	          BEGIN
	          SET @IsEligibleToArchive = 'ThisBranchUsedInSoftLabelPleaseDeleteTheDependenciesAndTryAgain'
	          END
	          IF(EXISTS(SELECT Id FROM Asset WHERE BranchId = @BranchId))
	          BEGIN
	          SET @IsEligibleToArchive = 'ThisBranchUsedInAssetPleaseDeleteTheDependenciesAndTryAgain'
	          END
		      IF(@IsEligibleToArchive <> '1')
		      BEGIN
		         RAISERROR (@isEligibleToArchive,11, 1)
		     END
	    END
		IF(@IsArchived = 1 AND @BranchId IS NOT NULL AND @EmployeeBranchRecordsCount > 0)
		BEGIN
				RAISERROR(50017,11,1)	
		END
		ELSE
		BEGIN
			IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
			IF(@BranchName = '') SET @BranchName = NULL
			IF(@BranchName IS NULL)
			BEGIN
			    RAISERROR(50011,16, 2, 'BranchName')
			END
			ELSE
			BEGIN
			DECLARE @BranchIdCount INT = (SELECT COUNT(1) FROM Branch  WHERE Id = @BranchId)
			DECLARE @BranchNameCount INT = (SELECT COUNT(1) FROM Branch WHERE BranchName = @BranchName AND CompanyId = @CompanyId AND (@BranchId IS NULL OR Id <> @BranchId))
			IF(@BranchIdCount = 0 AND @BranchId IS NOT NULL)
			BEGIN
			    RAISERROR(50002,16, 2,'Branch')
			END
			ELSE IF(@BranchNameCount > 0)
			BEGIN
			  RAISERROR(50001,16,1,'Branch')
			 END
			 ELSE
			  BEGIN
			     DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
				 IF (@HavePermission = '1')
				 BEGIN
				 	DECLARE @IsLatest BIT = (CASE WHEN @BranchId  IS NULL
				 	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
				                                                            FROM [Branch] WHERE Id = @BranchId ) = @TimeStamp
				 													THEN 1 ELSE 0 END END)
					 IF(@IsLatest = 1)
					 BEGIN
					 	  --DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
					      DECLARE @Currentdate DATETIME = GETDATE()
						
						IF(@BranchId IS NULL)
						BEGIN

						
						DECLARE @NewEntityId UNIQUEIDENTIFIER = (SELECT Id FROM Entity WHERE CompanyId = @CompanyId 
						                                         AND EntityName = (SELECT CompanyName FROM Company WHERE Id = @CompanyId))
						
						DECLARE @EmployeeId UNIQUEIDENTIFIER = (SELECT Id FROM Employee WHERE UserId = @OperationsPerformedBy)

						SET @BranchId = NEWID()

						INSERT INTO [dbo].[Branch](
						             [Id],
									 [CompanyId],
									 [BranchName],
									 [InActiveDateTime],
									 [CreatedDateTime],
									 [CreatedByUserId],
									 [IsHeadOffice],
									 [Address],
									 [TimeZoneId]
									 )
						      SELECT @BranchId,
									 @CompanyId,
									 @BranchName,
									 CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
									 @Currentdate,
									 @OperationsPerformedBy,
									 @IsHeadOffice,
									 @Address,
									 @TimeZoneId
									 
							INSERT INTO [dbo].[Entity](
							                 Id
											 ,EntityName
											 ,CreatedDateTime
											 ,CreatedByUserId
											 ,InactiveDateTime
											 ,CompanyId
											 ,ParentEntityId)
							          SELECT @BranchId
									         ,@BranchName
											 ,@Currentdate
											 ,@OperationsPerformedBy
											 ,CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END
											 ,@CompanyId
											 ,@NewEntityId

							INSERT INTO [dbo].[EntityBranch](
							            [Id]
										,[EntityId]
										,[BranchId]
										,[CreatedByUserId]
										,[CreatedDateTime]
										,[InactiveDateTime]
										)
								VALUES(NEWID()
								       ,@BranchId
								       ,@BranchId
									   ,@OperationsPerformedBy
									   ,@Currentdate
									   ,CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END)
									   ,(NEWID()
								       ,@NewEntityId
								       ,@BranchId
									   ,@OperationsPerformedBy
									   ,@Currentdate
									   ,CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END)

							 INSERT INTO [dbo].[EmployeeEntity]([Id],EmployeeId,EntityId,[CreatedByUserId],[CreatedDateTime])
							 SELECT NEWID(),@EmployeeId,@BranchId,@OperationsPerformedBy,GETDATE()
							 
							INSERT INTO [dbo].[EmployeeEntityBranch] ([Id],[EmployeeId],[BranchId],[CreatedByUserId],[CreatedDateTime])
							SELECT NEWID(),@EmployeeId,T.BranchId,@OperationsPerformedBy,GETDATE()
							FROM  (SELECT EB.BranchId,EN.EmployeeId
							       FROM EmployeeEntity EN 
								        INNER JOIN EntityBranch EB ON EN.EntityId = EB.EntityId
							       WHERE EN.EmployeeId = @EmployeeId AND EN.EntityId = @BranchId
										AND EN.InactiveDateTime IS NULL
							       GROUP BY EB.BranchId,EN.EmployeeId
							      ) T

							--INSERT INTO ProfessionalTaxRange(Id,FromRange,ToRange,TaxAmount,ActiveFrom,IsArchived,BranchId)
							--VALUES(NEWID(),0.0000,15000.0000,0.0000,@Currentdate,0,@BranchId)

							--INSERT INTO ProfessionalTaxRange(Id,FromRange,ToRange,TaxAmount,ActiveFrom,IsArchived,BranchId)
							--VALUES(NEWID(),15001.0000,20000.0000,150.0000,@Currentdate,0,@BranchId)

							--INSERT INTO ProfessionalTaxRange(Id,FromRange,ToRange,TaxAmount,ActiveFrom,IsArchived,BranchId)
							--VALUES(NEWID(),20001.0000,NULL,200.0000,@Currentdate,0,@BranchId)

							--INSERT INTO ShiftTiming(Id,CompanyId,ShiftName,BranchId,CreatedDateTime,CreatedByUserId)
							--VALUES(NEWId(),@CompanyId,'Morning Shift',@BranchId,@CurrentDate,@OperationsPerformedBy)

							--DECLARE @ShiftTimingId UNIQUEIDENTIFIER

							--SELECT @ShiftTimingId = Id FROM ShiftTiming WHERE ShiftName = 'Morning Shift' AND BranchId = @BranchId AND CompanyId = @CompanyId

							--INSERT INTO ShiftWeek(Id,ShiftTimingId,[DayOfWeek],StartTime,EndTime,DeadLine,IsPaidBreak,CreatedDateTime,CreatedByUserId)
							--VALUES(NEWId(),@ShiftTimingId,'Monday','03:30:00','12:30:00','03:45:00',0,@Currentdate,@OperationsPerformedBy)

							--INSERT INTO ShiftWeek(Id,ShiftTimingId,[DayOfWeek],StartTime,EndTime,DeadLine,IsPaidBreak,CreatedDateTime,CreatedByUserId)
							--VALUES(NEWId(),@ShiftTimingId,'Tuesday','03:30:00','12:30:00','03:45:00',0,@Currentdate,@OperationsPerformedBy)

							--INSERT INTO ShiftWeek(Id,ShiftTimingId,[DayOfWeek],StartTime,EndTime,DeadLine,IsPaidBreak,CreatedDateTime,CreatedByUserId)
							--VALUES(NEWId(),@ShiftTimingId,'Wednesday','03:30:00','12:30:00','03:45:00',0,@Currentdate,@OperationsPerformedBy)

							--INSERT INTO ShiftWeek(Id,ShiftTimingId,[DayOfWeek],StartTime,EndTime,DeadLine,IsPaidBreak,CreatedDateTime,CreatedByUserId)
							--VALUES(NEWId(),@ShiftTimingId,'Thursday','03:30:00','12:30:00','03:45:00',0,@Currentdate,@OperationsPerformedBy)

							--INSERT INTO ShiftWeek(Id,ShiftTimingId,[DayOfWeek],StartTime,EndTime,DeadLine,IsPaidBreak,CreatedDateTime,CreatedByUserId)
							--VALUES(NEWId(),@ShiftTimingId,'Friday','03:30:00','12:30:00','03:45:00',0,@Currentdate,@OperationsPerformedBy)

						END
						ELSE
						BEGIN

							UPDATE [dbo].[Branch]
								SET [CompanyId]				=   @CompanyId,
									 [BranchName]			=   @BranchName,
									 [InActiveDateTime]		=   CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
									 [UpdatedDateTime]		=   @Currentdate,
									 [UpdatedByUserId]		=   @OperationsPerformedBy,
									 [IsHeadOffice]			=	@IsHeadOffice,
									 [Address]				=	@Address,
									 [TimeZoneId]           =   @TimeZoneId
								WHERE Id = @BranchId
								
							UPDATE [dbo].[Entity] 
							SET EntityName = @BranchName
								,[InActiveDateTime]		=   CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END
								,[UpdatedDateTime]		=   @Currentdate
								,[UpdatedByUserId]		=   @OperationsPerformedBy
						   WHERE Id = @BranchId

						   UPDATE [dbo].[EntityBranch]
						   SET [InActiveDateTime]		=   CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END
								,[UpdatedDateTime]		=   @Currentdate
								,[UpdatedByUserId]		=   @OperationsPerformedBy
						   WHERE EntityId = @BranchId

						END
						             SELECT Id FROM [dbo].[Branch] WHERE Id = @BranchId
									 IF(@IsHeadOffice = 1)
									 BEGIN
										UPDATE [dbo].[Branch]
											SET [IsHeadOffice] = 0 WHERE Id <> @BranchId
								
									 END
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
		END
    END TRY
    BEGIN CATCH
        THROW
    END CATCH
END
GO
