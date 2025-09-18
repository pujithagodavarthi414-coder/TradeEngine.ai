-- EXEC [dbo].[USP_GetBranchDetailsByUserId] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@UserId = '127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetBranchDetailsByUserId]
(
   @UserId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
     SET NOCOUNT ON
     BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	   DECLARE @HavePermission NVARCHAR(250)  = 1--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN

             IF(@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL

             IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

             DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

             SELECT EB.BranchId,
                    B.BranchName,
                    B.CreatedByUserId,
                    B.CreatedDateTime,
				    (CASE WHEN B.InActiveDateTime IS NULL THEN 0 ELSE 1 END) AS IsArchived
              FROM  [dbo].[User] U WITH (NOLOCK)
			  INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
			  LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id-- AND EB.InActiveDateTime IS NULL
			  JOIN Branch B ON EB.BranchId = B.Id AND B.InActiveDateTime IS NULL
			  WHERE U.Id = @UserId AND U.InActiveDateTime IS NULL
	    END
	    ELSE
	    BEGIN
	    
	    		RAISERROR (@HavePermission,11, 1)
	    		
	    END
     END TRY  
     BEGIN CATCH 
        
          EXEC USP_GetErrorInformation

    END CATCH
END