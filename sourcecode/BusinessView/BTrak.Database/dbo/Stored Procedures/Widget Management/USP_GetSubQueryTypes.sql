CREATE PROCEDURE [dbo].[USP_GetSubQueryTypes] 
(
@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    BEGIN TRY
            DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
            IF (@HavePermission = '1')
            BEGIN

			      SELECT Id AS subQueryTypeId, SubQueryType FROM CustomAppSubQueryType

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
