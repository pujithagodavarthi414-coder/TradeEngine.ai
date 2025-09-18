----------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-10-24 00:00:00.000'
-- Purpose      To Get All Client Secondary Contacts by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetClientSecondaryContacts] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971', @ClientId = '951381FF-803D-48C1-A0F2-860CF3DD4BD5', @ClientSecondaryContactId = '7A857A45-D0B2-4FBA-8305-4D03CD93E8FD'
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetClientSecondaryContacts]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @ClientSecondaryContactId UNIQUEIDENTIFIER = NULL,
	@ClientId UNIQUEIDENTIFIER = NULL,  
	@IsArchived BIT = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY

        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        IF (@HavePermission = '1')
        BEGIN          

           IF(@ClientSecondaryContactId = '00000000-0000-0000-0000-000000000000') SET @ClientSecondaryContactId = NULL
           
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))       
                               
           SELECT CSC.Id AS ClientSecondaryContactId,
				  CSC.ClientId,
				  CSC.ClientReferenceUserId,
				  U.FirstName,
				  U.SurName AS LastName,
				  CONCAT(SUBSTRING(U.FirstName,1,1),' ',SUBSTRING(U.SurName,1,1)) AS AvatarName,
				  CONCAT(U.FirstName,' ',U.SurName)FullName,
				  U.UserName AS Email,
				  U.MobileNo,			
				  U.ProfileImage,
				  CSC.CreatedDateTime,
                  CSC.CreatedByUserId,
				  CSC.UpdatedDateTime,
				  CSC.UpdatedByUserId,
				  CSC.InActiveDateTime,
                  CSC.[TimeStamp],
                  STUFF((SELECT  ',' + CONVERT(NVARCHAR(36),UR.RoleId)
						FROM [UserRole] UR
						WHERE UR.UserId = U.Id AND InactiveDateTime IS NULL FOR XML PATH('')),1,1,''
						)AS RoleIds,
                  TotalCount = COUNT(1) OVER()
           FROM ClientSecondaryContact AS CSC
		   INNER JOIN Client C ON CSC.ClientId = C.Id
		   INNER JOIN [User] U ON CSC.ClientReferenceUserId = U.Id 
           WHERE --(U.CompanyId = @CompanyId)                            
					(@IsArchived IS NULL OR (@IsArchived = 1 AND CSC.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND CSC.InactiveDateTime IS NULL))
                AND (@ClientSecondaryContactId IS NULL OR CSC.Id = @ClientSecondaryContactId)  
				AND (@ClientId IS NULL OR CSC.ClientId = @ClientId)    
				--AND (@OperationsPerformedBy = CSC.CreatedByUserId)  
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