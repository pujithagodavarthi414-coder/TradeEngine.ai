CREATE PROCEDURE [dbo].[USP_GetDocumentsDescriptions]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @ReferenceTypeId UNIQUEIDENTIFIER
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY

        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        IF (@HavePermission = '1')
        BEGIN
           
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))       

								SELECT  (SELECT DD.[Description],
													DD.ReferenceTypeId,
													DD.Id,
													DD.OrderNumber
                                                   FROM DocumentsDescription DD
                                             WHERE DD.ReferenceTypeId = @ReferenceTypeId AND DD.InActiveDateTime IS NULL AND DD.ReferenceId='1912F3AC-5BAA-4EDC-894D-10103F96AF58'
											 GROUP BY DD.Id,DD.[Description],DD.ReferenceId,DD.ReferenceTypeId,DD.OrderNumber
                                             ORDER BY DD.OrderNumber ASC
                                             FOR XML PATH('InitialDocumentsDescription'), ROOT('InitialDocumentsDescription'), TYPE) AS InitialDocumentsDescriptionXml
											 
				
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