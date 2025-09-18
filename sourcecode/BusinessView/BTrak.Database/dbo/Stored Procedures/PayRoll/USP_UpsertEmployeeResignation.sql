CREATE PROCEDURE [dbo].[USP_UpsertEmployeeResignation]
(
   @EmployeeResignationId UNIQUEIDENTIFIER = NULL,
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @ResignationDate DATETIMEOFFSET,
   @LastDate DATETIMEOFFSET = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @CommentByEmployee VARCHAR(800),
   @CommentByEmployer VARCHAR(800),
   @IsApproved BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @ResignationStatusId UNIQUEIDENTIFIER

	IF(@EmployeeResignationId IS NULL)
	BEGIN
	SET @ResignationStatusId = (SELECT TOP 1 Id FROM ResignationStatus WHERE IsWaitingForApproval = 1)
	END
	
	IF(@EmployeeResignationId IS NOT NULL AND @IsApproved = 1)
	BEGIN
	SET @ResignationStatusId = (SELECT TOP 1 Id FROM ResignationStatus WHERE IsApproved = 1)
	END
	
	ELSE IF(@EmployeeResignationId IS NOT NULL AND @IsApproved = 0 )
	BEGIN
	SET @ResignationStatusId = (SELECT TOP 1 Id FROM ResignationStatus WHERE IsRejected = 1)	
	END
	ELSE IF(@EmployeeResignationId IS NOT NULL)
	BEGIN
	SET @ResignationStatusId = (SELECT TOP 1 ResignationStastusId FROM [EmployeeResignation] WHERE Id = @EmployeeResignationId)
	END

	DECLARE @ResignationApprovedById UNIQUEIDENTIFIER = (SELECT Id FROM Employee WHERE UserId = @OperationsPerformedBy)

		DECLARE @EmployeeResignationIdCount INT = (SELECT COUNT(1) FROM EmployeeResignation  WHERE Id = @EmployeeResignationId)
		DECLARE @EmployeeResignationCount INT = (SELECT COUNT(1) FROM EmployeeResignation WHERE @EmployeeResignationId IS NULL OR @EmployeeResignationId <> Id)
	    IF(@EmployeeResignationIdCount = 0 AND @EmployeeResignationId IS NOT NULL)
        BEGIN
            RAISERROR(50002,16, 2,'EmployeeResignation')
        END
        ELSE
		  BEGIN
		             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			         IF (@HavePermission = '1')
			         BEGIN
			         	DECLARE @IsLatest BIT = (CASE WHEN @EmployeeResignationId  IS NULL
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                           FROM [EmployeeResignation] WHERE Id = @EmployeeResignationId) = @TimeStamp
			         									THEN 1 ELSE 0 END END)
			             IF(@IsLatest = 1)
			         	BEGIN
			                 DECLARE @Currentdate DATETIME = GETDATE()
                            IF(@EmployeeResignationId IS NULL)
							BEGIN
							SET @EmployeeResignationId = NEWID()
							INSERT INTO [dbo].[EmployeeResignation](
                                                              [Id],
						                                      [EmployeeId],
															  [ResignationStastusId],
															  [ResginationApprovedByEmployeeId],
															  [ResignationDate],
															  [LastDate],
															  [ApprovedDate],
						                                      [InActiveDateTime],
						                                      [CreatedDateTime],
						                                      [CreatedByUserId],
															  [CommentByEmployee],
															  [CommentByEmployer],
															  [ResginationRejectedByEmployeeId],
															  [RejectedDate])
                                                       SELECT @EmployeeResignationId,
															  @EmployeeId,
															  @ResignationStatusId,
															  NULL,
															  @ResignationDate,
															  @LastDate,
															  NULL,
						                                      CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,						 
						                                      @Currentdate,
						                                      @OperationsPerformedBy,
															  @CommentByEmployee,
															  @CommentByEmployer,
															  NULL,
															  NULL
							END
							ELSE
							BEGIN
								  UPDATE [EmployeeResignation]
							      SET [EmployeeId] = @EmployeeId,
									  [ResignationStastusId] = @ResignationStatusId,
									  [ResginationApprovedByEmployeeId] = CASE WHEN @IsApproved = 1 THEN @ResignationApprovedById WHEN @IsApproved = 0 THEN NULL ELSE ER.ResginationApprovedByEmployeeId END,
									  [ResignationDate] = @ResignationDate,
									  [LastDate] = @LastDate,
									  [ApprovedDate] = CASE WHEN @IsApproved = 1 THEN @Currentdate WHEN @IsApproved = 0 THEN NULL ELSE  ER.ApprovedDate END,
									  InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									  UpdatedDateTime = @Currentdate,
									  UpdatedByUserId = @OperationsPerformedBy,
									  [CommentByEmployee] = CASE WHEN @CommentByEmployee IS NOT NULL THEN @CommentByEmployee ELSE ER.CommentByEmployee END ,
									  [CommentByEmployer] = @CommentByEmployer,
									  [ResginationRejectedByEmployeeId] = CASE WHEN @IsApproved = 0 THEN @ResignationApprovedById WHEN @IsApproved = 1 THEN NULL ELSE ER.ResginationRejectedByEmployeeId END,
									  [RejectedDate] = CASE WHEN @IsApproved = 0 THEN @Currentdate WHEN @IsApproved = 1 THEN NULL ELSE  ER.RejectedDate END
									  FROM EmployeeResignation AS ER
									  WHERE Id = @EmployeeResignationId
							END
							DECLARE @ResignationId UNIQUEIDENTIFIER = (SELECT Id FROM [dbo].[EmployeeResignation] WHERE Id = @EmployeeResignationId)
							DECLARE @UserId UNIQUEIDENTIFIER = (SELECT UserId FROM Employee WHERE Id = @EmployeeId)
							DECLARE @AppliedUserName NVARCHAR(200) = (SELECT SurName + ' ' + FirstName FROM [User] WHERE ID = @UserId)
							DECLARE @ReportToCount INT = (SELECT COUNT(1) FROM [dbo].[Ufn_GetEmployeeReportToMembers](@UserId))
							IF(@ReportToCount = 1)
							BEGIN
							DECLARE @ReportingToId UNIQUEIDENTIFIER = (SELECT 
																		T.UserId AS ReportToUserId
																		FROM
																		(SELECT RT.UserId
																				 ,U.SurName + ' ' + U.FirstName AS [FullName]
																				 ,U.UserName 
																				 FROM (SELECT * FROM [dbo].[Ufn_GetEmployeeReportToMembers](@UserId)) RT
																				 JOIN [User] U ON U.Id = RT.UserId AND U.InActiveDateTime IS NULL AND RT.UserLevel > 0
																		GROUP BY RT.UserId,U.SurName + ' ' + U.FirstName,U.UserName) T)
							END
							DECLARE @ApprovedOrRejectedUserName NVARCHAR(200) = NULL
							
							IF(@IsApproved = 1)
							SET @ApprovedOrRejectedUserName = (SELECT User1.FirstName + ' ' +User1.SurName FROM EmployeeResignation AS ER
																					INNER JOIN Employee EMP ON EMP.Id = ER.EmployeeId
																					INNER JOIN [User] U ON U.Id = EMP.UserId
																					LEFT JOIN Employee EMP1 ON EMP1.Id =ER.ResginationApprovedByEmployeeId
																					LEFT JOIN [User] User1 ON User1.Id= EMP1.UserId
																					WHERE ER.Id = @ResignationId
																					)

							IF(@IsApproved = 0)
							SET @ApprovedOrRejectedUserName = (SELECT User1.FirstName + ' ' +User1.SurName FROM EmployeeResignation AS ER
																					INNER JOIN Employee EMP ON EMP.Id = ER.EmployeeId
																					INNER JOIN [User] U ON U.Id = EMP.UserId
																					LEFT JOIN Employee EMP1 ON EMP1.Id =ER.ResginationRejectedByEmployeeId
																					LEFT JOIN [User] User1 ON User1.Id= EMP1.UserId
																					WHERE ER.Id = @ResignationId
																					)


						  

						  IF (@ReportToCount > 1)
							BEGIN

								SELECT @ResignationId AS EmployeeResignationId, 
									   @ReportingToId AS ReportingToId, 
									   @AppliedUserName AS AppliedUserName, 
									   @UserId AS AppliedUserId, 
									   @ApprovedOrRejectedUserName AS ApprovedOrRejectedUserName
									  ,T.UserId AS ReportingToId
									  FROM
									  (SELECT RT.UserId
											 ,U.SurName + ' ' + U.FirstName AS [FullName]
											 ,U.UserName 
											 FROM (SELECT * FROM [dbo].[Ufn_GetEmployeeReportToMembers](@UserId)) RT
											 JOIN [User] U ON U.Id = RT.UserId AND U.InActiveDateTime IS NULL AND RT.UserLevel > 0
							          GROUP BY RT.UserId,U.SurName + ' ' + U.FirstName,U.UserName) T

							END
							ELSE
							BEGIN
								SELECT 
								@ResignationId AS EmployeeResignationId, 
								@ReportingToId AS ReportingToId, 
								@AppliedUserName AS AppliedUserName, 
								@UserId AS AppliedUserId, 
								@ApprovedOrRejectedUserName AS ApprovedOrRejectedUserName
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
    END TRY
    BEGIN CATCH
        THROW
    END CATCH
END