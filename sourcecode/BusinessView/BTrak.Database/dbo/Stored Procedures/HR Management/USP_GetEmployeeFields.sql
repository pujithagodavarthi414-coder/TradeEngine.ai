CREATE PROCEDURE [dbo].[USP_GetEmployeeFields]
(
   @OperationsPerformedBy  UNIQUEIDENTIFIER
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
             
             SELECT Id, FieldName,Edit AS IsEdit, Hide AS IsHide, Mandatory AS IsRequired,[TimeStamp] FROM EmployeeFields WHERE CompanyId=@CompanyId AND InactiveDateTime IS NULL Order By FieldName ASC
        END
        ELSE

            RAISERROR(@HavePermission,16,1)

     END TRY  
     BEGIN CATCH
       
           THROW
    END CATCH
END