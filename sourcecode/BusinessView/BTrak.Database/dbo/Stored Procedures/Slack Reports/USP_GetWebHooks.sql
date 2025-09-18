-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetWebHooks] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@UserId ='995D3431-2CFA-4A4C-9F9F-DD8D2ABA5CA2'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetWebHooks]
(
  @UserId UNIQUEIDENTIFIER = NULL,
  @ProjectId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER
) 
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
	
	 IF (@HavePermission = '1')
	 BEGIN
          IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
          
          IF(@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL
          
          IF(@ProjectId = '00000000-0000-0000-0000-000000000000') SET @ProjectId = NULL
          DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
          
		 --DECLARE @WebHookUserId UNIQUEIDENTIFIER = (SELECT UserId from WebHook WHERE UserId = @UserId )
		
		   SELECT WH.Id WebHookId,
				U.Id UserId,
				WH.ProjectId,
				WH.WebHookUrl 
			FROM Employee E
				JOIN [User] U ON U.Id=E.UserId
				JOIN WebHook WH ON WH.UserId=U.Id
				JOIN EmployeeReportTo ERT ON ERT.ReportToEmployeeId=E.Id
					AND (ERT.ActiveFrom <= GETDATE() AND ERT.ActiveFrom IS NOT NULL) AND (ERT.ActiveTo > = GETDATE() OR ERT.ActiveTo IS NULL)
				JOIN [Employee] E1 ON ERT.EmployeeId=E1.Id
				JOIN [User] U1 ON U1.Id=E1.UserId
			where (@UserId IS NULL OR U1.Id = @UserId)
			AND (@ProjectId IS NULL OR ProjectId = @ProjectId)
            AND( U.CompanyId = @CompanyId)
		
		UNION 

		SELECT WH.Id WebHookId,
				U.Id UserId,
				WH.ProjectId,
				WH.WebHookUrl 
				FROM WebHook WH 
				     JOIN [User] U ON WH.UserId = U.Id AND WH.UserId = @UserId 

    END
	END TRY
    BEGIN CATCH
        THROW
    END CATCH
END