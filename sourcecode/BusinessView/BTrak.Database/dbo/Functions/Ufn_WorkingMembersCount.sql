CREATE FUNCTION [dbo].[Ufn_WorkingMembersCount]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@CompanyId UNIQUEIDENTIFIER
)
RETURNS @returntable TABLE
(
	Working INTEGER 
)
AS
BEGIN

	DECLARE @Working INT = 0;

	IF((SELECT COUNT(1) FROM Feature AS F
								JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
								JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
								JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
								WHERE F.Id = 'AE34EE14-7BEB-4ECB-BCE8-5F6588DF57E5' AND U.Id = @OperationsPerformedBy) > 0)
	BEGIN
		SELECT @Working = COUNT(1) FROM (
				select T.UserId,T.[Date] from TimeSheet T 
									INNER JOIN (SELECT U.Id FROM Employee E
															INNER JOIN [User] U ON U.Id = E.UserId
															WHERE U.CompanyId = @CompanyId
															AND (U.UserName <> 'support@snovasys.com') AND U.Id <> @OperationsPerformedBy
						                        ) US ON US.Id = T.UserId AND US.Id <> @OperationsPerformedBy
									WHERE T.[Date] = (SELECT MAX([Date]) FROM TimeSheet WHERE UserId = @OperationsPerformedBy)
									      AND T.InTime IS NOT NULL AND T.OutTime IS NULL
				) Main
				LEFT JOIN UserBreak UB ON UB.UserId = Main.UserId AND CONVERT(DATE,UB.[Date]) = CONVERT(DATE,Main.[Date])
				        AND UB.Id = (SELECT TOP (1)Id AS BreakId FROM UserBreak UB WHERE UB.UserId = Main.UserId ORDER BY BreakIn DESC,CreatedDateTime DESC)
				WHERE (UB.BreakIn IS NULL OR (UB.BreakIn IS NOT NULL AND UB.BreakOut IS NOT NULL))
	END

	ELSE 
		BEGIN
			SELECT @Working = COUNT(1) FROM (
					select T.UserId,T.[Date] from TimeSheet T 
										INNER JOIN (SELECT ChildId AS Child 
							                          FROM Ufn_GetEmployeeReportedMembers(@OperationsPerformedBy,@CompanyId)
							                          GROUP BY ChildId
							                          ) RM ON RM.Child = T.UserId AND RM.Child <> @OperationsPerformedBy
										WHERE T.[Date] = (SELECT MAX([Date]) FROM TimeSheet WHERE UserId = @OperationsPerformedBy)
										      AND T.InTime IS NOT NULL AND T.OutTime IS NULL
					) Main
					LEFT JOIN UserBreak UB ON UB.UserId = Main.UserId AND CONVERT(DATE,UB.[Date]) = CONVERT(DATE,Main.[Date])
					        AND UB.Id = (SELECT TOP (1)Id AS BreakId FROM UserBreak UB WHERE UB.UserId = Main.UserId ORDER BY BreakIn DESC,CreatedDateTime DESC)
					WHERE (UB.BreakIn IS NULL OR (UB.BreakIn IS NOT NULL AND UB.BreakOut IS NOT NULL))
		END
		INSERT INTO @returntable VALUES(@Working)
	RETURN
END
