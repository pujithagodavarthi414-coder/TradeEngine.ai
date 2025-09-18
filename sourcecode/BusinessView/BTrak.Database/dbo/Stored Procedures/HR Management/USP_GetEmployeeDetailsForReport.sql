CREATE PROCEDURE [dbo].[USP_GetEmployeeDetailsForReport]
(
   @EmployeeId  UNIQUEIDENTIFIER = NULL, 
   @DocumentTemplateName  NVARCHAR(800) = NULL, 
   @OperationPerformedBy  UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	
		DECLARE @HavePermission NVARCHAR(250)  = 1--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationPerformedBy))

		IF (@HavePermission = '1')
	    BEGIN
	      IF(@EmployeeId = '00000000-0000-0000-0000-000000000000') SET @EmployeeId = NULL
	      
	      IF(@OperationPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationPerformedBy = NULL

	      SELECT E.Id,
		         E.UserId,
				 U.FirstName + ISNULL(U.SurName,'') AS FullName,
				 U.FirstName,
				 U.SurName,
                 E.EmployeeNumber,
                 E.GenderId,
                 E.MaritalStatusId,
                 E.NationalityId,
                 ECD.DateofBirth,
				 ECD.Address1 AS AddressLine1,
				 ECD.Address2 AS AddressLine2,
				 ECD.PostalCode,
				 ECD.StateId,
				 ED.DesignationId,
				 D.DesignationName,
				 S.StateName,
				 ECD.CountryId,
				 C.CountryName,
				 ECD.Mobile AS PhoneNumber,
                 E.Smoker,
                 E.MilitaryService,
                 E.NickName,
                 E.CreatedDateTime,
                 E.CreatedByUserId
		  FROM  [dbo].[Employee] AS E WITH (NOLOCK)
				INNER JOIN [User] U ON U.Id = E.UserId
				INNER JOIN [UserRole] UR ON UR.UserId = U.Id AND UR.InactiveDateTime IS NULL
				INNER JOIN Gender G ON G.Id = E.GenderId AND G.InActiveDateTime IS NULL
				INNER JOIN MaritalStatus M ON M.Id = E.MaritalStatusId AND M.InActiveDateTime IS NULL
				INNER JOIN Nationality N ON N.Id = E.NationalityId AND N.InActiveDateTime IS NULL
				LEFT JOIN EmployeeContactDetails ECD ON ECD.EmployeeId = E.Id AND ECD.InActiveDateTime IS NULL
				LEFT JOIN [State] S ON ECD.StateId = S.Id AND S.InActiveDateTime IS NULL
				LEFT JOIN Country C ON ECD.CountryId = C.Id AND C.InActiveDateTime IS NULL
				LEFT JOIN EmployeeDesignation ED ON ED.EmployeeId = E.Id
				LEFT JOIN Designation D ON ED.DesignationId = D.Id AND D.InActiveDateTime IS NULL
		  WHERE ((@EmployeeId IS NULL OR E.Id = @EmployeeId)) AND U.CompanyId = @CompanyId
	END
	 END TRY  
	 BEGIN CATCH 
		
	    	EXEC USP_GetErrorInformation

	END CATCH
END