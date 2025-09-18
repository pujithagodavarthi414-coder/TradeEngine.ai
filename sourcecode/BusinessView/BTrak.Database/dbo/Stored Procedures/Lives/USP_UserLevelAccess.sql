CREATE procedure [dbo].[USP_UserLevelAccess]
(
  @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
  @UserId UNIQUEIDENTIFIER = NULL,
  @ProgramId UNIQUEIDENTIFIER = NULL,
  @LevelIds XML = NULL,
  @RoleIds XML = NULL,
  @IsLevelRemovel BIT = NULL
)
AS
BEGIN
	  DECLARE @RoleTable Table(Id UNIQUEIDENTIFIER)
		INSERT INTO @RoleTable (Id)
				SELECT [Table].[Column].value('(text())[1]', 'NVARCHAR(500)') FROM @RoleIds.nodes('GenericListOfNullableOfGuid/ListItems/guid') 
				AS [Table]([Column])
	 DECLARE @LevelPriority TABLE (LevelId UNIQUEIDENTIFIER,LevelPriority NVARCHAR(100))
					   INSERT INTO @LevelPriority(LevelId,LevelPriority) VALUES ('98B3DA9D-2989-468F-9E12-16F1DBF97983','2')
					   INSERT INTO @LevelPriority(LevelId,LevelPriority) VALUES ('8964657D-706D-472B-956A-95482C374E85','3')
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
    IF(@LevelIds IS NOT NULL)
    BEGIN
	    IF(@IsLevelRemovel = 1)
		BEGIN
			DELETE UL FROM UserLevel UL
				   LEFT JOIN @LevelPriority LP ON LP.LevelId = UL.LevelId
			       WHERE UserId = @UserId AND ProgramId = @ProgramId
		END
		DECLARE @LevelTable Table(Id UNIQUEIDENTIFIER)
		INSERT INTO @LevelTable (Id)
				SELECT [Table].[Column].value('(text())[1]', 'NVARCHAR(500)') FROM @LevelIds.nodes('GenericListOfNullableOfGuid/ListItems/guid') 
				AS [Table]([Column])

		INSERT INTO UserLevel (Id,UserId,ProgramId,LevelId,CreatedDateTime,CreatedByUserId) 
		SELECT NEWID(),@UserId,@ProgramId,LT.Id,GETDATE(),@OperationsPerformedBy FROM @LevelTable LT
		LEFT JOIN UserLevel UL ON UL.LevelId = LT.Id AND UL.UserId = @UserId AND UL.ProgramId = @ProgramId
		WHERE UL.Id IS NULL
	END
	ELSE
	BEGIN
		IF(@RoleIds IS NOT NULL)
		BEGIN
					   
			    SELECT U.Id AS UserId,
                        U.FirstName +' '+ISNULL(U.SurName,'') as FullName,
						ISNULL((SELECT TOP 1 UL.LevelId FROM UserLevel UL 
					   INNER JOIN @LevelPriority LP ON LP.LevelId = UL.LevelId WHERE UL.UserId = U.Id AND UL.ProgramId = @ProgramId
					   ORDER BY LP.LevelPriority DESC),'E78444E9-07F3-4FAA-BF91-CC1A664B54F9') AS LevelId,
					   (SELECT TOP 1 UL.ProgramId FROM UserLevel UL WHERE UL.UserId = U.ID AND UL.ProgramId = @ProgramId) AS ProgramId 
                 FROM  [dbo].[User] U WITH (NOLOCK)
				 WHERE  (@RoleIds IS NULL OR U.Id IN (SELECT UserId FROM UserRole UR  INNER JOIN @RoleTable T 
				ON T.Id = UR.RoleId AND UR.InactiveDateTime IS NULL
				INNER JOIN [Role] R ON R.Id = T.Id AND R.InactiveDateTime  IS NULL
				)) AND U.InActiveDateTime IS NULL AND U.CompanyId = (SELECT Id FROM [dbo].[Company] C WHERE C.Id =@CompanyId AND
				C.InActiveDateTime IS NULL AND C.IsVerify =1) AND U.IsActive = 1
		END
		ELSE IF(@UserId IS NOT NULL)
		BEGIN
			SELECT UserId,LevelId,ProgramId FROM UserLevel WHERE UserId = @UserId AND ProgramId = @ProgramId
		END
	END
END