--EXEC [dbo].[USP_GetPublicCustomApplicationById] 'E24BB53B-7EAE-4A26-87E4-599A1EF2BBEB'
CREATE PROCEDURE [dbo].[USP_GetPublicCustomApplicationById]
(
    @CustomApplicationId UNIQUEIDENTIFIER = NULL,
    @CustomApplicationName NVARCHAR(500),
    @GenericFormName NVARCHAR(500)
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
           SET @CustomApplicationId = (SELECT CAF.Id FROM [dbo].[CustomApplicationForms] CAF 
                                       INNER JOIN [CustomApplication] CA ON CA.Id = CAF.CustomApplicationId 
                                       --INNER JOIN [GenericForm] GF ON GF.Id = CAF.GenericFormId 
                                        WHERE CA.CustomApplicationName = @CustomApplicationName 
                                              --AND GF.FormName = @GenericFormName AND GF.InActiveDateTime IS NULL
                                              AND CA.InActiveDateTime IS NULL AND CAF.InActiveDateTime IS NULL)
           
 --          DECLARE @FormJson NVARCHAR(MAX) = (
 --          SELECT [FormJson]
 --          FROM [dbo].[GenericForm] GF INNER JOIN [dbo].[CustomApplicationForms] CA ON GF.Id = CA.GenericFormId AND CA.InActiveDateTime IS NULL AND GF.InActiveDateTime IS NULL
 --          WHERE CA.Id = @CustomApplicationId)
           
           
 --DECLARE @Value INT = 0,@SqlQuery NVARCHAR(MAX)
 --DECLARE @finalJSON NVARCHAR(MAX) = '{"components": []}'
 
 --   DECLARE @OpenJsonData NVARCHAR(MAX) = ''
 --   DECLARE @Var1 NVARCHAR(MAX) = (SELECT Value FROM OPENJSON(@FormJson))
 --WHILE (@OpenJsonData IS NOT NULL)
 --BEGIN
 --   SET @SqlQuery = ''
    
 --   SET @OpenJsonData = ''
    
 --   SET @OpenJsonData = (SELECT valuepair FROM (SELECT [key] AS keypair,value AS valuepair FROM OPENJSON(@Var1)) T WHERE keypair = @Value)
 --   DECLARE @Var BIT = CASE WHEN EXISTS(SELECT 1  
 --                                       FROM CustomApplicationKey CAK
 --                                            INNER JOIN GenericFormKey GFK ON GFK.Id = CAK.GenericFormKeyId
 --                                            JOIN CustomApplicationForms CAF ON CAF.ID = @CustomApplicationId
 --                           AND GFK.InActiveDateTime IS NULL AND CAK.InActiveDateTime IS NULL  
 --                          WHERE CAK.IsPrivate = 1 AND CAK.CustomApplicationId = CAF.CustomApplicationId
 --                                 AND GFK.[Key] = JSON_VALUE(@OpenJsonData,'$.key')
 --                                      ) THEN 1 ELSE 0 END
 --   IF(@Var = 0 AND @OpenJsonData IS NOT NULL)
 --   BEGIN
 --    SET @finalJSON = JSON_MODIFY(@finalJSON, 'append $.components',JSON_QUERY(@OpenJsonData))
 --   END
 --   SET @Value = @Value + 1
 --END
 SELECT CAF.Id AS CustomApplicationId,'' AS FormJson, CAF.GenericFormId AS FormId,PublicMessage from CustomApplication CA
                        JOIN CustomApplicationForms CAF ON CAF.CustomApplicationId = CA.Id WHERE CAF.Id = @CustomApplicationId AND CA.InActiveDateTime IS NULL
            
    END TRY
    BEGIN CATCH
           SELECT ERROR_NUMBER() AS ErrorNumber,
                  ERROR_SEVERITY() AS ErrorSeverity,
                  ERROR_STATE() AS ErrorState,
                  ERROR_PROCEDURE() AS ErrorProcedure,
                  ERROR_LINE() AS ErrorLine,
                  ERROR_MESSAGE() AS ErrorMessage
    END CATCH
END
GO