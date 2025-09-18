-------------------------------------------------------------------------------
-- Author       Sudha Goli
-- Created      '2019-03-05 00:00:00.000'
-- Purpose      To Get The LogTime Options
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetLogTimeOptions]  @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetLogTimeOptions]
(
  @LogTimeOptionId UNIQUEIDENTIFIER = NULL,
  @LogTimeOption NVARCHAR (250) = NULL,
  @SearchText NVARCHAR(250) = NULL,
  @IsArchived BIT = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
   SET NOCOUNT ON
     BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	  DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
              
      IF (@HavePermission = '1')
      BEGIN

	      IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL    

		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       
	      SELECT LT.Id AS LogTimeOptionId,
		         LT.LogTimeOption,
				 LT.CreatedDatetime,
				 LT.CreatedByUserId,
				 CASE WHEN LT.InactiveDateTime IS NULL THEN 0 ELSE 1 END AS IsArchived,
				 LT.[TimeStamp],
				 TotalCount = COUNT(1) OVER()
		  FROM  [dbo].[LogTimeOption] LT
		  WHERE (@LogTimeOptionId IS NULL OR LT.Id = @LogTimeOptionId)
		   AND (@LogTimeOption IS NULL OR LT.LogTimeOption = @LogTimeOption)
		   AND (@SearchText IS NULL OR LT.LogTimeOption LIKE '%' + @SearchText + '%')
		   AND (@IsArchived IS NULL OR (LT.InactiveDateTime IS NULL AND @IsArchived =0) OR (LT.InactiveDateTime IS NOT NULL AND @IsArchived = 1))

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