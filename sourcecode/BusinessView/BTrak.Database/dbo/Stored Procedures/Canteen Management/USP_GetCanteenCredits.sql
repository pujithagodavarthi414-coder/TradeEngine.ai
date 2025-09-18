-------------------------------------------------------------------------------
-- Author       Aswani Katam
-- Created      '2019-02-19 00:00:00.000'
-- Purpose      To Get The LogTime Report By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
-- EXEC [dbo].[USP_GetCanteenCredits] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@IsOffered=1

CREATE PROCEDURE [dbo].[USP_GetCanteenCredits]
(
  @CanteenCreditId  UNIQUEIDENTIFIER = NULL,
  @SearchText NVARCHAR(250) = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @IsOffered BIT,
  @CreditedByUserId UNIQUEIDENTIFIER = NULL,
  @PageNo INT = 1,
  @PageSize INT = 10
)
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF (@CanteenCreditId = '00000000-0000-0000-0000-000000000000') SET @CanteenCreditId = NULL

	    IF (@CreditedByUserId = '00000000-0000-0000-0000-000000000000') SET @CreditedByUserId = NULL
	
	    IF(@SearchText = '') SET @SearchText = NULL

		 SET @SearchText =  '%'+ @SearchText+'%'

        IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	    SELECT UCC.Id AS CanteenCreditId,
		       UCC.Amount,
			   UCC.IsOffered,
			   UCC.CreatedDateTime,
			   UCC.CreatedByUserId,
			   U.FirstName +' '+ISNULL(U.SurName,'') as CreditedByUserName,
               U.FirstName CreditedByUserFirstName,
               U.SurName CreditedByUserSurName,
               U.UserName AS CreditedByUserEmail,
               U.ProfileImage AS CreditedByUserProfileImage,
			   U1.FirstName +' '+ISNULL(U1.SurName,'') as CreditedToUserName,
               U1.FirstName CreditedToUserFirstName,
               U1.SurName CreditedToUserSurName,
               U1.UserName AS CreditedToUserEmail,
               U1.ProfileImage AS CreditedToUserProfileImage,
			   UCC.[TimeStamp],
			   TotalCount = COUNT(1) OVER()
        FROM [dbo].[UserCanteenCredit] UCC WITH (NOLOCK)
		       LEFT JOIN [dbo].[User] U ON U.Id = UCC.CreditedByUserId AND U.InActiveDateTime IS NULL
			   LEFT JOIN [dbo].[User] U1 ON U1.Id = UCC.CreditedToUserId AND U1.InActiveDateTime IS NULL
	    WHERE (@CanteenCreditId IS NULL OR UCC.Id = @CanteenCreditId) 
		       AND (@IsOffered IS NULL OR UCC.IsOffered = @IsOffered) 
			   AND (@CreditedByUserId IS NULL OR UCC.CreditedByUserId = @CreditedByUserId)
		       AND ((@SearchText IS NULL OR (U.SurName LIKE  @SearchText)) OR
			       (@SearchText IS NULL OR (U.FirstName LIKE  @SearchText)) OR 
			       (@SearchText IS NULL OR (U1.SurName LIKE @SearchText)) OR
			       (@SearchText IS NULL OR (U1.FirstName LIKE  @SearchText)))
			   AND (U.CompanyId = @CompanyId)

	    ORDER BY UCC.CreatedDateTime OFFSET ((@PageNo - 1) * @PageSize) ROWS

        FETCH NEXT @PageSize ROWS ONLY

	END TRY  
	BEGIN CATCH 
		
		THROW

	END CATCH

END
GO
