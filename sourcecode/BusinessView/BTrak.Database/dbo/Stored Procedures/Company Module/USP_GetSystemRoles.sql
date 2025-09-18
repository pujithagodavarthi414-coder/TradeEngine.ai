-------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-07-26 00:00:00.000'
-- Purpose      To Get the SystemRoles By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved delete from 
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetSystemRoles] 

CREATE PROCEDURE [dbo].[USP_GetSystemRoles]
(

   @SearchText NVARCHAR(250) = NULL,
   @IsArchived BIT = NULL	
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY


	      SELECT R.Id RoleId,
				 R.RoleName,
				 R.CreatedDateTime, 
				 CASE WHEN R.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
				 R.[TimeStamp],
		   	     TotalCount = COUNT(1) OVER()
				 
		  FROM  [dbo].[SYS_Role] AS R WITH (NOLOCK)
		  WHERE (@SearchText IS NULL OR R.RoleName LIKE '%'+ @SearchText+'%')
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND R.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND R.InActiveDateTime IS NULL))

		  ORDER BY RoleName ASC 

	 END TRY  
	 BEGIN CATCH 
		
		   THROW

	END CATCH
END