-------------------------------------------------------------------------------
-- Author       Aswani Katam
-- Created      '2019-01-22 00:00:00.000'
-- Purpose      To Get Employee By Applying EmployeeId Filter
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetEmployeeById] @OperationPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@EmployeeId='CD94F9B5-9A49-4EDE-BE2F-092178E0E801'

CREATE PROCEDURE [dbo].[USP_GetEmployeeById]
(
   @EmployeeId  UNIQUEIDENTIFIER = NULL, 
   @OperationPerformedBy  UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	
		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationPerformedBy))

		IF (@HavePermission = '1')
	    BEGIN
	      IF(@EmployeeId = '00000000-0000-0000-0000-000000000000') SET @EmployeeId = NULL
	      
	      IF(@OperationPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationPerformedBy = NULL

	      SELECT E.Id,
		         UserId,
                 EmployeeNumber,
                 GenderId,
                 MaritalStatusId,
                 NationalityId,
                 DateofBirth,
                 Smoker,
                 MilitaryService,
                 NickName,
                 E.CreatedDateTime,
                 E.CreatedByUserId
		  FROM  [dbo].[Employee] AS E WITH (NOLOCK)
				INNER JOIN [User] U ON U.Id = E.UserId
		  WHERE  ((@EmployeeId IS NULL OR E.Id = @EmployeeId)) AND U.CompanyId = @CompanyId
	END
	 END TRY  
	 BEGIN CATCH 
		
	    	EXEC USP_GetErrorInformation

	END CATCH
END