-----------------------------------------------------------------------------------------
-- Author       Aswani K
-- Created      '2019-04-04 00:00:00.000'
-- Purpose      To Get number formats
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-----------------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetIndustries] 
-----------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetIndustries]
(
  @IndustryId UNIQUEIDENTIFIER = NULL,
  @SearchText NVARCHAR(500) = NULL,
  @IsArchived BIT = NULL
)
AS
BEGIN
     SET NOCOUNT ON
     BEGIN TRY
           
		       IF(@IndustryId = '00000000-0000-0000-0000-000000000000') SET @IndustryId = NULL

               IF(@SearchText = '') SET  @SearchText = NULL
             
               SET @SearchText = '%'+ @SearchText +'%'

                SELECT I.[Id] AS IndustryId,
                       I.[IndustryName],
		   			   I.InActiveDateTime,
		   			   I.CreatedDateTime,
		   			   I.[TimeStamp],	
					   CASE WHEN I.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   			   TotalCount = COUNT(1) OVER()
					
               FROM  [dbo].[Industry] I WITH (NOLOCK)
			   JOIN  (SELECT IndustryId FROM [dbo].[IndustryModule] WHERE InActiveDateTime IS NULL GROUP BY IndustryId) IM ON IM.IndustryId = I.Id
               WHERE (@IndustryId IS NULL OR I.Id = @IndustryId) 
                     AND (@SearchText IS NULL OR (IndustryName LIKE @SearchText))
					 AND (@IsArchived IS NULL OR (@IsArchived = 1 AND I.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND I.InActiveDateTime IS NULL))
               ORDER BY IndustryName ASC
          
     END TRY  
     BEGIN CATCH 
        
          THROW

    END CATCH

END
GO