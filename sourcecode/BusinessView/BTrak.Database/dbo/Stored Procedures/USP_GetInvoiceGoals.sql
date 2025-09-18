----------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-10-04 00:00:00.000'
-- Purpose      To Get Invoice Goals by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetInvoiceGoals] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971', @InvoiceGoalId = 'DD75AEE7-959F-450A-B4F1-783512B65B08'
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetInvoiceGoals]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER, 
    @InvoiceGoalId UNIQUEIDENTIFIER = NULL, 
	@InvoiceId UNIQUEIDENTIFIER = NULL, 
    @SearchText NVARCHAR(250) = NULL,
	@IsArchived BIT = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY

        DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        IF (@HavePermission = '1')
        BEGIN

           IF(@SearchText = '') SET @SearchText = NULL

		   SET @SearchText = '%'+ @SearchText +'%';              

           IF(@InvoiceGoalId = '00000000-0000-0000-0000-000000000000') SET @InvoiceGoalId = NULL
           
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))       
                               
           SELECT IG.Id AS InvoiceGoalId,
				  IG.InvoiceId,
				  IG.GoalId,
				  G.GoalName,
				  G.GoalStatusId,
				  G.GoalStatusColor,
				  GS.GoalStatusName,
				  IG.CreatedDateTime,
                  IG.CreatedByUserId,
				  IG.UpdatedDateTime,
				  IG.UpdatedByUserId,
				  IG.InActiveDateTime,
                  IG.[TimeStamp],  
                  TotalCount = COUNT(1) OVER()
           FROM InvoiceGoals AS IG
		   INNER JOIN Invoice_New I ON I.Id = IG.InvoiceId
		   INNER JOIN Goal G ON G.Id = IG.GoalId
		   INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId
           WHERE (@IsArchived IS NULL OR (@IsArchived = 1 AND IG.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND IG.InactiveDateTime IS NULL))
				AND IG.CompanyId = @CompanyId AND I.CompanyId = @CompanyId
                AND (@InvoiceGoalId IS NULL OR IG.Id = @InvoiceGoalId)
				AND (@InvoiceId IS NULL OR IG.InvoiceId = @InvoiceId)
				AND (@SearchText IS NULL OR (G.GoalName LIKE @SearchText ))
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
