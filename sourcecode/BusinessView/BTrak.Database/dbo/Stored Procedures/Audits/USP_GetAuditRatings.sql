CREATE PROCEDURE [dbo].[USP_GetAuditRatings]
(
     @OperationsPerformedBy UNIQUEIDENTIFIER,
	 @AuditRatingName NVARCHAR(250)= NULL,
     @AuditRatingId UNIQUEIDENTIFIER = NULL,
     @IsArchived BIT = NULL
)
 AS
 BEGIN
 SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
				
		IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

        IF(@IsArchived IS NULL) SET @IsArchived = 0

         DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
         
         IF (@HavePermission = '1')
         BEGIN
        
		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		  SELECT AR.Id AuditRatingId,
				 AR.AuditRatingName,
				 AR.CompanyId,
				 AR.[TimeStamp]
				FROM AuditRating AR
				WHERE CompanyId = @CompanyId
				     AND (@AuditRatingId  IS NULL OR AR.Id = @AuditRatingId)
				     AND (@AuditRatingName IS NULL OR AR.AuditRatingName = @AuditRatingName)
                     AND (@IsArchived IS NULL OR (@IsArchived = 1 AND AR.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND AR.InactiveDateTime IS NULL))
				ORDER BY AuditRatingName
				
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
 GO