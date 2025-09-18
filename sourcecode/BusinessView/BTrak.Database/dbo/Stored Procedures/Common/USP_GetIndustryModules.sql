-----------------------------------------------------------------------------------------
-- Author       Aswani K
-- Created      '2019-04-04 00:00:00.000'
-- Purpose      To Get industry modules
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-----------------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetIndustryModules] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-----------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetIndustryModules]
(
  @IndustryModuleId UNIQUEIDENTIFIER = NULL,
  @SearchText NVARCHAR(500) = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @IsArchived BIT = NULL       
)
AS
BEGIN
     SET NOCOUNT ON
     BEGIN TRY
     SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	 
		   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

           IF (@HavePermission = '1')
           BEGIN

		       IF(@IndustryModuleId = '00000000-0000-0000-0000-000000000000') SET @IndustryModuleId = NULL

               IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

               DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

               IF(@SearchText = '') SET  @SearchText = NULL
             
               SET @SearchText = '%'+ @SearchText +'%'

               SELECT IM.[Id] AS IndustryModuleId,
					  IM.[IndustryId],
					  IM.[ModuleId],
					  IM.[TimeStamp],
					  IM.[CreatedByUserId],
					  IM.[CreatedDateTime],
					  I.[IndustryName],
					  M.[ModuleName],
					  IM.[TimeStamp],	
					  CASE WHEN IM.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   			  TotalCount = COUNT(1) OVER()

               FROM  [dbo].[IndustryModule] IM WITH (NOLOCK)
			         JOIN Industry I WITH (NOLOCK) ON  I.Id = IM.IndustryId
					 JOIN Module M WITH (NOLOCK) ON M.Id = IM.ModuleId
               WHERE (@IndustryModuleId IS NULL OR IM.Id = @IndustryModuleId) 
                     AND (@SearchText IS NULL OR (I.IndustryName LIKE @SearchText) OR (M.ModuleName LIKE @SearchText))
					 AND (@IsArchived IS NULL OR (@IsArchived = 1 AND IM.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND IM.InActiveDateTime IS NULL))

               ORDER BY IndustryName ASC
          END

          ELSE

            RAISERROR (@HavePermission,11, 1)
           
     END TRY  
     BEGIN CATCH 
        
          THROW

    END CATCH

END
GO