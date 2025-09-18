-------------------------------------------------------------------------------
-- Author       Raghavendra Gududhuru
-- Created      '2022-08-05 00:00:00.000'
-- Purpose      To Get EmployeeId by UserAuthenticationId
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].USP_GetEmployeeIdByUserAuthenticatonId] @UserAuthenticationId='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetEmployeeIdByUserAuthenticatonId]
(
   @UserAuthenticationId  UNIQUEIDENTIFIER,
   @OperationPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	
		DECLARE @HavePermission NVARCHAR(250)  = '1'
		
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationPerformedBy))

		IF (@HavePermission = '1')
	    BEGIN
	      
	      IF(@OperationPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationPerformedBy = NULL

	      SELECT 
			E.Id AS EmployeeId
		  FROM  [dbo].[User] AS U 
				INNER JOIN [Employee] E ON E.UserId = U.Id
		  WHERE  U.UserAuthenticationId = @UserAuthenticationId AND U.CompanyId = @CompanyId
	END
	 END TRY  
	 BEGIN CATCH 
		
	    	EXEC USP_GetErrorInformation

	END CATCH
END