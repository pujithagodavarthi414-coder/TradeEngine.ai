CREATE FUNCTION [dbo].[Ufn_TeamMembersCount]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@CompanyId UNIQUEIDENTIFIER
)
RETURNS @ret TABLE
(
   TeamMembers INTEGER 
)
AS
BEGIN

	DECLARE @TeamMembers INT = 0;

	IF((SELECT COUNT(1) FROM Feature AS F
								JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
								JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
								JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
								WHERE F.Id = 'AE34EE14-7BEB-4ECB-BCE8-5F6588DF57E5' AND U.Id = @OperationsPerformedBy) > 0)
			BEGIN
				SELECT @TeamMembers = COUNT(1)
								FROM Employee E
								INNER JOIN [User] U ON U.Id = E.UserId AND U.InActiveDateTime IS NULL AND U.IsActive = 1
								WHERE U.CompanyId = @CompanyId
									  AND (U.UserName <> 'support@snovasys.com') AND U.Id <> @OperationsPerformedBy
			END
		ELSE 
			BEGIN
				SELECT @TeamMembers = COUNT(1)
				              FROM [User] U 
				              INNER JOIN (SELECT ChildId AS Child 
				                          FROM Ufn_GetEmployeeReportedMembers(@OperationsPerformedBy,@CompanyId)
				                          GROUP BY ChildId
				                          ) T ON T.Child = U.Id  AND U.InActiveDateTime IS NULL AND T.Child <> @OperationsPerformedBy
							  WHERE U.CompanyId = @CompanyId 
		END

	INSERT INTO @ret VALUES(@TeamMembers)

	RETURN 
END
