-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-23 00:00:00.000'
-- Purpose      To Get Employee MemberShip Details
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetEmployeeMembershipDetails] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetEmployeeMembershipDetails]
(
   @EmployeeMembershipid UNIQUEIDENTIFIER = NULL,
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy  UNIQUEIDENTIFIER ,
   @SearchText NVARCHAR(250) = NULL,
   @SortDirection NVARCHAR(50) = NULL,
   @SortBy NVARCHAR(100) = NULL,
   @IsArchived BIT = NULL,
   @PageNo INT = 1,
   @PageSize INT = 10
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @ProcName NVARCHAR(250) = (SELECT OBJECT_NAME(@@PROCID))
        
		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,@ProcName))
		
		IF (@HavePermission = '1')
	    BEGIN

			 IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT[dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		     IF (@SortDirection = NULL) SET @SortDirection = 'ASC'

			 IF (@SortBy = NULL) SET @SortBy = 'Membership'
	      
		     IF(@SearchText = '') SET @SearchText = NULL

			 SET @SearchText = '%'+ RTRIM(LTRIM(@SearchText)) +'%'

		     SELECT E.Id EmployeeId,
			         U.FirstName,
					 EM.Id EmployeeMembershipId,
					 E.UserId,
					 U.SurName,
					 U.UserName Email,
					 EM.CommenceDate,
					 EM.RenewalDate,
					 EM.SubscriptionAmount,
					 EM.SubscriptionId,
					 S.SubscriptionPaidByName,
					 MS.MemberShipType Membership,
					 EM.MembershipId,
					 EM.CurrencyId,
					 C.CurrencyName,
					 EM.[TimeStamp],
					 EM.IssueCertifyingAuthority,
					 EM.NameOfTheCertificate,
					 U.FirstName + ' ' + U.SurName UserName,
					 CASE WHEN EM.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
					 TotalCount = COUNT(1) OVER()

			  FROM  [dbo].EmployeeMembership EM WITH (NOLOCK)
					JOIN Employee E ON E.Id = EM.EmployeeId AND E.InactiveDateTime IS NULL
			        JOIN [User] U ON U.Id = E.UserId AND U.InactiveDateTime IS NULL
					LEFT JOIN MemberShip MS ON MS.Id = EM.MembershipId AND MS.InactiveDateTime IS NULL
					LEFT JOIN SubscriptionPaidBy S ON  S.Id = EM.SubscriptionId AND S.InactiveDateTime IS NULL
					LEFT JOIN Currency C ON C.Id = EM.CurrencyId AND C.InactiveDateTime IS NULL
			  WHERE  (@EmployeeMembershipid IS NULL OR EM.Id = @EmployeeMembershipid)
			       AND (@EmployeeId IS NULL OR E.Id = @EmployeeId)
				  AND U.CompanyId = @CompanyId
				   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND EM.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND EM.InactiveDateTime IS NULL))
			       AND (@SearchText IS NULL 
						OR (S.SubscriptionPaidByName LIKE @SearchText)
						OR (EM.SubscriptionAmount LIKE @SearchText)
						OR (C.CurrencyName LIKE @SearchText)
						OR (MS.MemberShipType LIKE @SearchText)
						OR (EM.NameOfTheCertificate LIKE @SearchText)
						OR (EM.IssueCertifyingAuthority LIKE @SearchText)
						OR (REPLACE(CONVERT(NVARCHAR,EM.CommenceDate,106),' ','-') LIKE @SearchText)
						OR (REPLACE(CONVERT(NVARCHAR,EM.RenewalDate,106),' ','-') LIKE @SearchText))
			  ORDER BY
			     CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN
                         CASE WHEN(@SortBy = 'UserName')                 THEN U.FirstName + ' ' + U.SurName
                              WHEN(@SortBy = 'Membership')               THEN  MS.MemberShipType
                              WHEN(@SortBy = 'SubscriptionPaidByName')       THEN  S.SubscriptionPaidByName
                              WHEN(@SortBy = 'CurrencyName')                 THEN C.CurrencyName
                              WHEN(@SortBy = 'CommenceDate') THEN CAST(CONVERT(DATETIME,EM.CommenceDate,121) AS sql_variant)
                              WHEN(@SortBy = 'RenewalDate')  THEN CAST(CONVERT(DATETIME,EM.RenewalDate,121) AS sql_variant)
                              WHEN(@SortBy = 'SubscriptionAmount')       THEN EM.SubscriptionAmount
							  WHEN(@SortBy = 'NameOfTheCertificate')       THEN EM.NameOfTheCertificate
							  WHEN(@SortBy = 'IssueCertifyingAuthority')       THEN EM.IssueCertifyingAuthority
                          END
                      END ASC,
                      CASE WHEN @SortDirection = 'DESC' THEN
                         CASE WHEN(@SortBy = 'UserName')                 THEN U.FirstName + ' ' + U.SurName
                              WHEN(@SortBy = 'Membership')               THEN  MS.MemberShipType
                              WHEN(@SortBy = 'SubscriptionPaidByName')       THEN  S.SubscriptionPaidByName
                              WHEN(@SortBy = 'CurrencyName')                 THEN C.CurrencyName
                              WHEN(@SortBy = 'CommenceDate') THEN CAST(CONVERT(DATETIME,EM.CommenceDate,121) AS sql_variant)
                              WHEN(@SortBy = 'RenewalDate')  THEN CAST(CONVERT(DATETIME,EM.RenewalDate,121) AS sql_variant)
                              WHEN(@SortBy = 'SubscriptionAmount')       THEN EM.SubscriptionAmount
							  WHEN(@SortBy = 'IssueCertifyingAuthority')       THEN EM.IssueCertifyingAuthority
							  WHEN(@SortBy = 'NameOfTheCertificate')       THEN EM.NameOfTheCertificate
                          END
                      END DESC
			  OFFSET ((@PageNo - 1) * @PageSize) ROWS

		     FETCH NEXT @PageSize ROWS ONLY
		END
		ELSE
		   
		   RAISERROR(@HavePermission,11,1)

	 END TRY  
	 BEGIN CATCH 
		
		   THROW

	END CATCH
END

