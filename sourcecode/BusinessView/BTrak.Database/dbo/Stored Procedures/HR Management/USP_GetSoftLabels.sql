-------------------------------------------------------------------------------------------------------
-- Author       Aswani k
-- Created      '2019-05-06 00:00:00.000'
-- Purpose      To Save or Update SoftLabel
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetSoftLabels]  @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
---------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetSoftLabels]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@SoftLabelId UNIQUEIDENTIFIER = NULL,	
	@SoftLabelName NVARCHAR(250) = NULL,
	@SearchText NVARCHAR(250) = NULL,
	@IsArchive BIT= NULL	
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN

		   IF(@SearchText = '') SET @SearchText = NULL

		   IF(@SoftLabelName = '') SET @SoftLabelName = NULL
		   
		   SET @SearchText = '%'+ @SearchText +'%'

		   IF(@SoftLabelId = '00000000-0000-0000-0000-000000000000') SET @SoftLabelId = NULL		  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT SL.Id AS SoftLabelId,
		   	      SL.CompanyId,
		   	      SL.SoftLabelName,
				  SL.BranchId,
				  B.BranchName,
				  SL.SoftLabelKeyType,
				  SL.SoftLabelValue,
		   	      SL.InActiveDateTime,
		   	      SL.CreatedDateTime ,
		   	      SL.CreatedByUserId,
		   	      SL.[TimeStamp],	
		   	      TotalCount = COUNT(*) OVER()
           FROM SoftLabel AS SL	
		   JOIN Branch B WITH (NOLOCK) ON B.Id = SL.BranchId AND B.InActiveDateTime IS NULL
           WHERE SL.CompanyId = @CompanyId
		   	   AND (@SoftLabelId IS NULL OR SL.Id = @SoftLabelId)
			   AND (@SoftLabelName IS NULL OR (SL.SoftLabelName = @SoftLabelName))
			   AND (@SearchText IS NULL 
			        OR (SL.SoftLabelName LIKE  @SearchText)
					OR (SL.SoftLabelKeyType LIKE  @SearchText)
					OR (SL.SoftLabelValue LIKE  @SearchText))
			   AND (@IsArchive IS NULL 
			        OR(@IsArchive = 0 AND SL.InActiveDateTime IS NULL)
					OR(@IsArchive = 1 AND SL.InActiveDateTime IS NOT NULL))
		   	    
           ORDER BY SL.SoftLabelName ASC

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