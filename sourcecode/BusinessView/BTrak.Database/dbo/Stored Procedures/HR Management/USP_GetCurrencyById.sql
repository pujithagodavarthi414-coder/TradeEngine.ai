CREATE PROCEDURE [dbo].[USP_GetCurrencyById]
(
    @OperationPerformedBy UNIQUEIDENTIFIER ,
    @CurrencyTypeId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
        
	    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		IF (@HavePermission = '1')
		BEGIN

			    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationPerformedBy))
			   
			    SELECT C.Id,
			           C.CurrencyName AS CurrencyType
			    FROM Currency AS C 
			    INNER JOIN [User] AS U ON C.CreatedByUserId = U.Id and U.InActiveDateTime IS NULL
			    WHERE C.Id = @CurrencyTypeId AND C.InActiveDateTime IS NULL
					   AND U.CompanyId = @CompanyId

		END
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