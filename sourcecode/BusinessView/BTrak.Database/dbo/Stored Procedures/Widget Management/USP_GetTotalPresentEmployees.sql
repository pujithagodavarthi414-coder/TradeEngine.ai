CREATE PROCEDURE [dbo].[USP_GetTotalPresentEmployees]
(
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @Date DATETIME = NULL
)
AS
BEGIN 
SET NOCOUNT ON

BEGIN TRY
	DECLARE @HavePermission NVARCHAR(250)  = 1 --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
	IF(@HavePermission= '1')
		BEGIN
		DECLARE @CompanyId UNIQUEIDENTIFIER = (select CompanyId from [User] where Id= @OperationsPerformedBy)

		DECLARE @Working INT = 0;

	IF(@Date IS NULL) SET @Date = CONVERT(DATE,GETDATE())	

	DECLARE @HaveFeatureAccess INT = (SELECT COUNT(1) FROM Feature AS F
								JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
								JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
								JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
								WHERE F.Id = 'AE34EE14-7BEB-4ECB-BCE8-5F6588DF57E5' AND U.Id = @OperationsPerformedBy)

	SELECT COUNT(1) AS Working FROM (
				select T.UserId,T.[Date] from TimeSheet T 
									INNER JOIN (SELECT U.Id FROM Employee E
															INNER JOIN [User] U ON U.Id = E.UserId
															WHERE U.CompanyId = @CompanyId
															AND (U.UserName <> 'support@snovasys.com') 
															AND U.Id <> @OperationsPerformedBy
						                        ) US ON US.Id = T.UserId AND US.Id <> @OperationsPerformedBy
									WHERE T.[Date] = @Date
									      AND T.InTime IS NOT NULL --AND T.OutTime IS NULL
				) Main
				LEFT JOIN UserBreak UB ON UB.UserId = Main.UserId AND CONVERT(DATE,UB.[Date]) = CONVERT(DATE,Main.[Date])
				        AND UB.Id = (SELECT TOP (1)Id AS BreakId FROM UserBreak UB WHERE UB.UserId = Main.UserId ORDER BY BreakIn DESC,CreatedDateTime DESC)
				WHERE (UB.BreakIn IS NULL OR (UB.BreakIn IS NOT NULL AND UB.BreakOut IS NOT NULL))
					AND (@HaveFeatureAccess > 0 OR Main.UserId IN (SELECT ChildId AS Child 
							                          FROM Ufn_GetEmployeeReportedMembers(@OperationsPerformedBy,@CompanyId)
							                          GROUP BY ChildId
							                          ))
	
		END
	ELSE
	BEGIN
	RAISERROR (@HavePermission,11, 1)
	END

END TRY
BEGIN CATCH
THROW

END CATCH
END