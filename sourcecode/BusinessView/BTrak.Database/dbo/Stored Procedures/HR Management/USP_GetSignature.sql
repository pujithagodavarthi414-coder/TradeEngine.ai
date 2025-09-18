-------------------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2019-05-15 00:00:00.000'
-- Purpose      To Get Signatures
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetSignature] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetSignature]
(
     @OperationsPerformedBy UNIQUEIDENTIFIER,
     @ReferenceId UNIQUEIDENTIFIER,
	 @InviteeId UNIQUEIDENTIFIER = NULL,
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
 
            IF(@ReferenceId = '00000000-0000-0000-0000-000000000000') SET @ReferenceId = NULL

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
            
              SELECT  S.Id AS SignatureId,
                      S.ReferenceId,
					  S.InviteeId,
					  U.FirstName + ' ' + ISNULL(U.SurName,'') AS InviteeName,
					  U.UserName AS InviteeMail,
					  U.ProfileImage AS InviteeImage,
					  S.SignatureUrl,
                      S.CreatedDateTime,
                      S.CreatedByUserId,
					  IU.FirstName + ' ' + ISNULL(IU.SurName,'') AS InvitedByName,
					  IU.ProfileImage AS InvitedByImage,
					  CASE WHEN S.InactiveDateTime IS NOT NULL THEN 1 ELSE 0 END IsArchived,
					  UF.[FileName],
					  UF.FilePath,
					  UF.FileExtension
            FROM [Signature] S 
				 JOIN [User] IU ON IU.Id = S.CreatedByUserId AND IU.InActiveDateTime IS NULL
				 LEFT JOIN [User] U ON U.Id = S.InviteeId AND U.InActiveDateTime IS NULL
				 LEFT JOIN UploadFile UF ON UF.Id = S.ReferenceId
			WHERE S.CompanyId = @CompanyId AND S.InActiveDateTime IS NULL 
				AND (UF.Id IS NULL OR UF.InActiveDateTime IS NULL)
				AND (@ReferenceId IS NULL OR S.ReferenceId = @ReferenceId)
				AND (@InviteeId IS NULL OR (InviteeId = @InviteeId AND SignatureUrl IS NULL ))
 
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
